import 'dart:ffi';

import 'package:allia_health_inc_test_app/auth/services/get_it.dart';
import 'package:allia_health_inc_test_app/auth/services/secure_storage_service.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/option_model.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/questions_response.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/dio/dio_client.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/dio/dio_error.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/questions_response.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/question_model.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/option_model.dart';

class QuestionService {
  final Dio dio;
  final SecureStorageService secureStorageService;
  final String _baseUrl = 'https://api-dev.allia.health';
  final NetworkProvider networkProvider = NetworkProvider();
  bool _isRefreshing = false; // Flag to track if token is being refreshed
  // final SecureStorageService secureStorageService = SecureStorageService();

  QuestionService(this.dio, this.secureStorageService);
  Future<String?> getRefreshToken() async {
    final refreshToken = await secureStorageService.read(key: 'Refresh-Token');
    return refreshToken;
  }

  // Future<String?> refreshAccessToken() async {

  //   try {
  //     final response = await dio.post(
  //       '$_baseUrl/api/client/auth/refresh-token',
  //       data: {'refreshToken': refreshToken},
  //     );
  //     if (response.statusCode == 200) {
  //       final newToken = response.data['accessToken'];
  //       await _saveAccessToken(newToken);
  //       return newToken;
  //     }
  //   } catch (e) {
  //     print('Failed to refresh access token: $e');
  //     return null;
  //   }
  //   return null;
  // }

  Future<String?> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    try {
      final response = await networkProvider.call(
        path: '/api/client/auth/refresh-token',
        method: RequestMethod.post,
        body: {'refreshToken': refreshToken},
      );
      if (response?.statusCode == 200) {
        final newToken = response?.data['accessToken'];
        await _saveAccessToken(newToken);
        return newToken;
      }
    } on DioException catch (e) {
      final errorMessage = Future.error(ApiError.fromDio(e));
      return e.response?.data["message"] ?? errorMessage;
    } catch (err) {
      throw err.toString();
    }
  }

  // Future<String?> _getRefreshToken() async {
  //   return await secureStorageService.read(key: 'refreshToken');
  // }

  Future<void> _saveAccessToken(String token) async {
    await secureStorageService.write(key: 'Access-Token', value: token);
  }

  // Future<QuestionsResponse> getQuestions(
  //     String accessTokens, int clientId) async {
  //   try {
  //     final response = await dio.get(
  //       '$_baseUrl/api/client/self-report/question',
  //       options: Options(
  //         headers: {
  //           'Client-Id': '$clientId',
  //         },
  //       ),
  //     );
  //     return QuestionsResponse.fromJson(response.data);
  //   } on DioError catch (e) {
  //     throw Exception(
  //         e.response?.data['message'] ?? 'Failed to load questions');
  //   }
  // }

  Future<QuestionsResponse> getQuestions(int clientId) async {
    await secureStorageService.write(
        key: 'Client-Id', value: clientId.toString());
    try {
      final response = await networkProvider.call(
        path: '/api/client/self-report/question',
        method: RequestMethod.get,
      );
      final responseData = QuestionsResponse.fromJson(response?.data);
      return responseData;
    } on DioException catch (e) {
      final errorMessage = Future.error(ApiError.fromDio(e));
      return e.response?.data["message"] ?? errorMessage;
    } catch (err) {
      throw err.toString();
    }
  }

  // Future<void> submitSelfReport(
  //   String accessTokens,
  //   int clientId,
  //   int selectedOptionIdFromFirstScreen,
  //   int questionIdFromFirstScreen,
  //   List<Option> selectedOptions,
  // ) async {
  //   final answers = [
  //     {
  //       "questionId": questionIdFromFirstScreen,
  //       "selectedOptionId": selectedOptionIdFromFirstScreen,
  //       "freeformValue": null,
  //     },
  //     ...selectedOptions
  //         .map((option) => {
  //               "questionId": option.questionId,
  //               "selectedOptionId": option.id,
  //               "freeformValue": null,
  //             })
  //         .toList(),
  //   ];

  //   try {
  //     final response = await dio.post(
  //       '$_baseUrl/api/client/self-report/answer',
  //       data: {'answers': answers},
  //       options: Options(
  //         headers: {
  //           'Client-Id': '$clientId',
  //         },
  //       ),
  //     );

  //     if (response.statusCode != 200 && response.statusCode != 201) {
  //       throw Exception(
  //           response.data['message'] ?? 'Failed to submit self-report');
  //     }
  //   } on DioError catch (e) {
  //     throw Exception(
  //         e.response?.data['message'] ?? 'Failed to submit self-report');
  //   }
  // }

  Future<void> submitSelfReport(
    int clientId,
    int selectedOptionIdFromFirstScreen,
    int questionIdFromFirstScreen,
    List<Option> selectedOptions,
  ) async {
    await secureStorageService.write(
        key: 'Client-Id', value: clientId.toString());

    final answers = [
      {
        "questionId": questionIdFromFirstScreen,
        "selectedOptionId": selectedOptionIdFromFirstScreen,
        "freeformValue": null,
      },
      ...selectedOptions
          .map((option) => {
                "questionId": option.questionId,
                "selectedOptionId": option.id,
                "freeformValue": null,
              })
          .toList(),
    ];
    try {
      final response = await networkProvider.call(
        path: '/api/client/self-report/answer',
        method: RequestMethod.post,
        body: {'answers': answers},
      );
       if (response?.statusCode != 200 && response?.statusCode != 201) {
        throw Exception(
            response?.data['message'] ?? 'Failed to submit self-report');
      }
    } on DioException catch (e) {
      final errorMessage = Future.error(ApiError.fromDio(e));
      return e.response?.data["message"] ?? errorMessage;
    } catch (err) {
      throw err.toString();
    }
  }
}
