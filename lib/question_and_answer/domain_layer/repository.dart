import 'package:allia_health_inc_test_app/question_and_answer/data_layer/api_service.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/questions_response.dart';

abstract class QuestionRepository {
  Future<QuestionsResponse> fetchQuestions(int clientId);
}

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionService service;

  QuestionRepositoryImpl(this.service);

  @override
  Future<QuestionsResponse> fetchQuestions(int clientId) {
    // Pass the access token and client id
    return service.getQuestions(clientId);
  }
}
