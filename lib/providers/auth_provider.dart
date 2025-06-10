import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mi_ticket_desayuno_app/client/dio_service.dart';
import 'package:mi_ticket_desayuno_app/models/user_model.dart';
import 'package:mi_ticket_desayuno_app/preferences/preferences.dart';

class AuthProvider with ChangeNotifier {
  final dio = DioService.instance.client;
  bool isLoading = false;
  User user = User(id: '', name: '', email: '', role: '');

  void setIsLoading() {
    isLoading = true;
    notifyListeners();
  }

  void setHasLoaded() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await Preferences().deleteToken();
    user = User(id: '', name: '', email: '', role: '');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final token = response.data['token'];
      if (token != null) {
        await saveUserData(token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> saveUserData(token) async {
    await Preferences().saveToken(token);
    final decodedToken = JwtDecoder.decode(token);
    user = User.fromJson(decodedToken);
    notifyListeners();
  }

  Future<void> saveUserDataWithoutNotify(token) async {
    await Preferences().saveToken(token);
    final decodedToken = JwtDecoder.decode(token);
    user = User.fromJson(decodedToken);
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final dio = DioService.instance.client;
      final response = await dio.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        bool loginResult = await login(email, password);

        if (loginResult) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkLogin() async {
    String? token = await Preferences().getToken();
    if (token == null) {
      return false;
    }
    if (JwtDecoder.isExpired(token)) {
      return false;
    }
    await saveUserDataWithoutNotify(token);
    return true;
  }

  Future<bool> checkUserExists(String userId) async {
    try {
      final response = await dio.get('/auth/user/$userId');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['id'] != null) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
