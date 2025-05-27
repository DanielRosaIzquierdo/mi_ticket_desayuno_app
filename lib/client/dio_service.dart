import 'package:dio/dio.dart';
import 'package:mi_ticket_desayuno_app/preferences/preferences.dart';
import 'package:mi_ticket_desayuno_app/config/constants.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;
  DioService._internal() {
    _dio = Dio(BaseOptions(baseUrl: Constants.apiUrl));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await Preferences().getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  late final Dio _dio;

  Dio get client => _dio;
}