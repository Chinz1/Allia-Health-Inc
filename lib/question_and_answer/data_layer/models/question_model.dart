import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/option_model.dart';

class Question {
  final int id;
  final String question;
  final String answerType;
  final List<Option> options;

  Question({
    required this.id,
    required this.question,
    required this.answerType,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      answerType: json['answerType'],
      options: (json['options'] as List)
          .map((option) => Option.fromJson(option))
          .toList(),
    );
  }
}
