// Bloc
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/api_service.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/option_model.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/usecase.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_event.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final QuestionService questionService;

  QuestionBloc(this.questionService) : super(QuestionInitial()) {
    on<FetchQuestions>((event, emit) async {
      emit(QuestionLoading());
      try {
        final questionsResponse = await questionService.getQuestions(
          // event.accessTokens,
          event.clientId,
        );

        emit(QuestionLoaded(
            questionsResponse.questions)); // Pass the list of questions
      } catch (e) {
        emit(QuestionFailure(e.toString()));
      }
    });

    // New event for submitting the self-report answers
    on<SubmitSelfReport>((event, emit) async {
      try {
        // Assuming you have access to the state where options are available
        final state =
            this.state; // Get current state, ensure it's of the correct type
        if (state is QuestionLoaded) {
          // Create a list of selected Option objects based on selectedOptionId
          final List<Option> selectedOptions = event.selectedOptionId
              .map((id) => state.questions
                  .expand(
                      (q) => q.options) // Get all options from all questions
                  .firstWhere(
                      (option) => option.id == id)) // Find the Option by id
              .toList();

          await questionService.submitSelfReport(
            // event.accessTokens,
            event.clientId,
            event.selectedOptionIdFromFirstScreen,
            event.questionIdFromFirstScreen,
            selectedOptions, // Pass the selectedOptions list now
          );
          emit(SelfReportSubmitted());
        }
      } catch (e) {
        emit(QuestionFailure(e.toString()));
      }
    });
  }
}
