import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/question_model.dart';

class QuestionsResponse {
  final List<Question> questions;

  QuestionsResponse({required this.questions});

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) {
    return QuestionsResponse(
      questions: (json['body'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
    );
  }
}
