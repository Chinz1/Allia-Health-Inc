import 'dart:ffi';

import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/option_model.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/questions_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionService {
  final String _baseUrl = 'https://api-dev.allia.health';

  // Fetch questions based on the access token and client ID provided after login
  Future<QuestionsResponse> getQuestions(
      String accessToken, int clientId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/client/self-report/question'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Client-Id': '$clientId',
      },
    );

    // Handle successful response
    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return QuestionsResponse.fromJson(jsonResponse);
    } else {
      // Handle errors and throw appropriate exception
      final errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['error'] ?? 'Failed to load questions';
      throw (errorMessage);
    }
  }

  // New method to submit the self-report answers
  Future<void> submitSelfReport(
    String accessToken,
    int clientId,
    int selectedOptionIdFromFirstScreen,
    int questionIdFromFirstScreen,
    List<Option> selectedOptions,
  ) async {
    // Create the initial answer with the first screen's selected option
    final Map<String, dynamic> firstScreenAnswer = {
      "questionId": questionIdFromFirstScreen, // From the first screen
      "selectedOptionId":
          selectedOptionIdFromFirstScreen, // From the first screen
      "freeformValue": null, // Hardcoded as per requirement
    };

    // Map through selectedOptions for additional answers
    final List<Map<String, dynamic>> additionalAnswers =
        selectedOptions.map((option) {
      if (option is Option) {
        return {
          "questionId": option.questionId, // Ensure questionId exists in Option
          "selectedOptionId": option.id, // Ensure id exists and is not null
          "freeformValue": null, // Hardcoded as per requirement
        };
      } else {
        throw ('Invalid option type'); // Handle unexpected option type
      }
    }).toList();

    // Combine the first screen answer with other answers
    final List<Map<String, dynamic>> answers = [
      firstScreenAnswer, // Include first screen answer
      ...additionalAnswers, // Spread the additional answers
    ];

    final response = await http.post(
      Uri.parse('$_baseUrl/api/client/self-report/answer'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Client-Id': '$clientId',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "answers": answers, // Combine both sets of answers
      }),
    );
    // print("iddd: ${_selectedOption?['id']}"); 
    print("iddd: $answers"); 
    

    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['error'] ?? 'Failed to submit self-report';
      throw (errorMessage);
    }
  }
}
