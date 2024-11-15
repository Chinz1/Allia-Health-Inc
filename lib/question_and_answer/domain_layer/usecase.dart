import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/questions_response.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/repository.dart';

class GetQuestionsUseCase {
  final QuestionRepository repository;

  GetQuestionsUseCase(this.repository);

  // Modify the use case to accept accessToken and clientId
  Future<QuestionsResponse> call(int clientId) async {
    return await repository.fetchQuestions( clientId);
  }
}
