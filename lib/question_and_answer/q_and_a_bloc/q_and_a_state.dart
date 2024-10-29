// States
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/question_model.dart';

abstract class QuestionState {}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final List<Question> questions;

  QuestionLoaded(this.questions);
}

class QuestionError extends QuestionState {
  final String error;

  QuestionError(this.error);
}

class QuestionFailure extends QuestionState {
  final String error;

  QuestionFailure(this.error);
}

class SelfReportSubmitted extends QuestionState {}
