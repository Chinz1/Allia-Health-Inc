import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_bloc.dart';
import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_state.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_bloc.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_event.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_state.dart';
import 'package:allia_health_inc_test_app/question_and_answer/screens/self_report_completed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondQuestionAndAnswerScreen extends StatefulWidget {
  final String selectedEmoji; // Passed emoji from the first screen
  final int
      selectedOptionIdFromFirstScreen; // Passed selected option ID from the first screen
  final int questionIdFromFirstScreen;
  final String selectedOptionFromFirstScreen;

  const SecondQuestionAndAnswerScreen({
    super.key,
    required this.selectedEmoji,
    required this.selectedOptionFromFirstScreen,
    required this.selectedOptionIdFromFirstScreen,
    required this.questionIdFromFirstScreen,
  });

  @override
  State<SecondQuestionAndAnswerScreen> createState() =>
      _SecondQuestionAndAnswerScreenState();
}

class _SecondQuestionAndAnswerScreenState
    extends State<SecondQuestionAndAnswerScreen> {
  double _emojiPosition = 0.0; // Position of the emoji on the Likert
  int _selectedOptionId = 1; // Default to the first option (bottom-most)
  Map<String, dynamic>? _selectedOption; // Variable to hold selected option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F3),
      ),
      backgroundColor: const Color(0xFFF9F7F3),
      body: BlocListener<QuestionBloc, QuestionState>(
        listener: (context, state) {
          if (state is SelfReportSubmitted) {
            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Submission successful!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is QuestionFailure) {
            // Show failure snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Submission failed: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<QuestionBloc, QuestionState>(
          builder: (context, state) {
            if (state is QuestionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuestionLoaded) {
              final secondQuestion = state.questions[1];

              // Create a list of options from the second question
              final List<Map<String, dynamic>> options =
                  List<Map<String, dynamic>>.from(
                      secondQuestion.options.map((option) => {
                            "id": option
                                .id, // Ensure these fields match your Option model
                            "option": option.option,
                            "isFreeForm": option.isFreeForm,
                          }));

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "You're feeling", // Display the question text
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${widget.selectedOptionFromFirstScreen}", // Display the question text
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAC8E63), // Set the color to #AC8E63
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        secondQuestion.question, // Display the question text
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Grading scale on the left
                          _buildGradingScale(),
                          const SizedBox(width: 10),
                          // Space between the grading scale and thermometer
                          GestureDetector(
                            onVerticalDragUpdate: (details) {
                              setState(() {
                                // Update the emoji position based on drag, ensuring it's within bounds
                                _emojiPosition += details.delta.dy;
                                if (_emojiPosition < 0) _emojiPosition = -20;
                                if (_emojiPosition > 300)
                                  _emojiPosition =
                                      300; // Maximum height for the scale
                  
                                // Map the position to the selected option based on options available
                                _selectedOptionId = ((320 - _emojiPosition) ~/
                                        (300 / options.length))
                                    .clamp(0, options.length - 1);
                                // Update the selected option based on the id
                                _selectedOption = options[_selectedOptionId];
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior:
                                  Clip.none, // Ensure nothing is clipped
                              children: [
                                // Likert scale thermometer
                                Container(
                                  width: 40, // Container width remains small
                                  height: 350, // Height of the thermometer
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(
                                            0xFFF1EDE3), // Above the emoji
                                        const Color(
                                            0xFF2E959E), // Below the emoji
                                      ],
                                      stops: [
                                        _emojiPosition / 300,
                                        _emojiPosition / 300,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                ),
                                // Emoji that the user can drag
                                Positioned(
                                  top: _emojiPosition,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      widget
                                          .selectedEmoji, // Use the emoji passed from the first screen
                                      width:
                                          80, // Make the emoji wider than the container
                                      height: 80, // Adjust height proportionally
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Space between the thermometer and grading scale
                          _buildGradingScale(isRight: true),
                        ],
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          final bloc = BlocProvider.of<QuestionBloc>(context);
                          final secondQuestionId =
                              secondQuestion.id.toString(); // Convert to String
                          final authBloc = context.read<AuthBloc>();
                          final authState = authBloc.state;
                  
                          if (authState is AuthSuccess) {
                            // Check if _selectedOption is not null before accessing its ID
                            if (_selectedOption != null) {
                              // Dispatch the event to submit the answer
                              bloc.add(SubmitSelfReport(
                                accessTokens: authState.accessToken,
                                clientId: authState.clientId,
                                questionId:
                                    secondQuestionId, // Ensure this is a String
                                selectedOptionId: [
                                  _selectedOption?['id'],
                                ],
                                selectedOptionIdFromFirstScreen:
                                    widget.selectedOptionIdFromFirstScreen,
                                questionIdFromFirstScreen:
                                    widget.questionIdFromFirstScreen,
                              ));
                            } else {
                              // Handle case where no option is selected (optional)
                            }
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelfReportCompletedScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E959E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (state is QuestionFailure) {
              return Center(
                child: Text(
                  'Failed to load questions: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }

  // Function to build the grading scale
  Widget _buildGradingScale({bool isRight = false}) {
    final gradingLines = List<Widget>.generate(5, (index) {
      // Generate only 5 grades
      double position = index * (300 / 4); // Adjust spacing for 5 grades
      return Column(
        children: [
          Container(
            width: 32,
            height: 3,
            color: _emojiPosition / (320 / 5) > index
                ? const Color(0xFFF1EDE3)
                : const Color(0xFF2E959E),
          ),
          const SizedBox(height: 60), // Maintain spacing between each grade
        ],
      );
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:
          isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: gradingLines,
    );
  }
}
