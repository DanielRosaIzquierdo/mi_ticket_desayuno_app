import 'package:dio/dio.dart';
import 'package:mi_ticket_desayuno_app/preferences/preferences.dart';
import 'package:mi_ticket_desayuno_app/config/constants.dart';

class DioService {
  static final DioService _instance = DioService._internal();

  static DioService get instance => _instance;

  late final Dio _dio;

  DioService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: Constants.apiUrl,
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),   
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ))
      ..interceptors.add(InterceptorsWrapper(onRequest: _addAuthorizationHeader));
  }

  Dio get client => _dio;

  Future<void> _addAuthorizationHeader(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await Preferences().getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
