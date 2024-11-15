import 'package:allia_health_inc_test_app/auth/services/secure_storage_service.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/api_service.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/dio/dio_error.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/dio/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkProvider {
  bool _isRefreshing = false;
  final SecureStorageService secureStorageService = SecureStorageService();
  Dio _getDioInstance() {
    var dio = Dio(BaseOptions(
      baseUrl: 'https://api-dev.allia.health',
      connectTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 60000),
    ));
    dio.interceptors.add(LoggerInterceptor());
    dio.interceptors.add(AuthorizationInterceptor());
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorageService.read(key: 'accessToken');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          options.headers['Connection'] = 'keep-alive';
          options.headers["Client-Id"] = await secureStorageService.read(key: 'Client-Id');
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401 && !_isRefreshing) {
            _isRefreshing = true;
            try {
              final newToken = await QuestionService(dio, secureStorageService).refreshAccessToken();
              if (newToken != null) {
                // Update the request with the new token
                e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                final retryResponse = await dio.fetch(e.requestOptions);
                return handler.resolve(retryResponse);
              }
            } catch (refreshError) {
              // Handle refresh token failure
              return handler.reject(DioError(
                requestOptions: e.requestOptions,
                error: 'Token refresh failed; please log in again.',
              ));
            } finally {
              _isRefreshing = false;
            }
          }
          return handler.next(e);
        },
      ),
    );
    dio.interceptors.add(LogInterceptor(
        responseBody: true, error: true, request: true, requestBody: true));
    return dio;
  }

  Future<Response?> call(
      {required String path,
      BuildContext? context,
      required RequestMethod method,
      dynamic body = const {},
      Map<String, dynamic> queryParams = const {}}) async {
    Response? response;
    try {
      switch (method) {
        case RequestMethod.get:
          response =
              await _getDioInstance().get(path, queryParameters: queryParams);
          break;
        case RequestMethod.post:
          if (context != null) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          response = await _getDioInstance()
              .post(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.patch:
          if (context != null) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          response = await _getDioInstance()
              .patch(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.put:
          if (context != null) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          response = await _getDioInstance()
              .put(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.delete:
          if (context != null) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          response = await _getDioInstance()
              .delete(path, data: body, queryParameters: queryParams);
          break;
      }
      return response;
    } on DioException catch (error) {
      return response?.data ?? Future.error(ApiError.fromDio(error));
    }
  }
}

class AuthorizationInterceptor extends Interceptor {
  final SecureStorageService secureStorageService = SecureStorageService();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await secureStorageService.read(key: 'Access-Token');
    final clientId = await secureStorageService.read(key: 'Client-Id');
    if (token != "" && token?.isNotEmpty == true) {
      options.headers["Authorization"] = "Bearer $token";
    }
    options.headers['Content-Type'] = 'multipart/form-data';
    options.headers["Accept"] = "application/json";
    options.headers["Content-Type"] = "application/json";
    options.headers["Client-Id"] = clientId;
    super.onRequest(options, handler);
  }
}

enum RequestMethod { get, post, put, patch, delete }
