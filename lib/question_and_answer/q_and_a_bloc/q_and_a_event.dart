// Events
import 'dart:ffi';

abstract class QuestionEvent {}

class FetchQuestions extends QuestionEvent {
  final String accessTokens;
  final int clientId;

  FetchQuestions({
    required this.accessTokens,
    required this.clientId,
  });
}


class SubmitSelfReport extends QuestionEvent {
  final String accessTokens;
  final int clientId;
  final int selectedOptionIdFromFirstScreen;
  final int questionIdFromFirstScreen;
  final String questionId;
  final List<int> selectedOptionId;

  SubmitSelfReport({
    required this.accessTokens,
    required this.clientId,
    required this.selectedOptionIdFromFirstScreen, 
    required this.questionIdFromFirstScreen, 
    required this.questionId,
    required this.selectedOptionId,
  });
}

