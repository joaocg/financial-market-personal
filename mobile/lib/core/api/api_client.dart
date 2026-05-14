import 'package:dio/dio.dart';
import '../config/env.dart';
import '../auth/token_storage.dart';

class ApiClient {
  final TokenStorage _tokenStorage;
  late final Dio _dio;

  ApiClient({required TokenStorage tokenStorage})
      : _tokenStorage = tokenStorage {
    _dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // TODO: Implement token refresh logic here
        }
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
