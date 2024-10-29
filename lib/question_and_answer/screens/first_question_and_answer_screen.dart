import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_bloc.dart';
import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_state.dart';
import 'package:allia_health_inc_test_app/gen/assets.gen.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/models/question_model.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_bloc.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_event.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_state.dart';
import 'package:allia_health_inc_test_app/question_and_answer/screens/second_question_and_answer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class FirstQuestionAndAnswerScreen extends StatefulWidget {
  @override
  _FirstQuestionAndAnswerScreenState createState() =>
      _FirstQuestionAndAnswerScreenState();
}

class _FirstQuestionAndAnswerScreenState
    extends State<FirstQuestionAndAnswerScreen>
    with AutomaticKeepAliveClientMixin<FirstQuestionAndAnswerScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.55);
  int? _selectedIndex; // Track selected emoji index

  @override
  bool get wantKeepAlive => false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authBloc = context.read<AuthBloc>();
    BlocProvider.of<QuestionBloc>(context).add(
      FetchQuestions(
        accessToken: (authBloc.state as AuthSuccess).accessToken,
        clientId: (authBloc.state as AuthSuccess).clientId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: BlocBuilder<QuestionBloc, QuestionState>(
        builder: (context, state) {
          if (state is QuestionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuestionLoaded) {
            final firstQuestion = state.questions[0];
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      firstQuestion.question,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select the number that best represents your ${_getEmotionLevel(_getSelectedOption(firstQuestion))} level.',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 291,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: firstQuestion.options.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex =
                                index; // Track the selected emoji index
                          });
                        },
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            animation: _pageController,
                            builder: (context, child) {
                              double scale = 1.0;
                              if (_pageController.position.haveDimensions) {
                                double currentPage = _pageController.page ??
                                    _pageController.initialPage.toDouble();
                                scale = (1 - (currentPage - index).abs())
                                    .clamp(0.7, 1.0);
                              }
                              return Center(
                                child: Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    width: 266,
                                    height: 291,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: const Offset(0, 4),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          _getSvgPath(firstQuestion
                                              .options[index].option),
                                          width: 100,
                                          height: 100,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          firstQuestion.options[index].option,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFFAC8E63),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 88),
                    GestureDetector(
                      onTap: _selectedIndex != null
                          ? () {
                              // Navigate to SecondQuestionAndAnswerScreen with selected emoji
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SecondQuestionAndAnswerScreen(
                                    selectedEmoji: _getSvgPath(firstQuestion
                                        .options[_selectedIndex!].option),
                                    selectedOptionIdFromFirstScreen:
                                        firstQuestion
                                            .options[_selectedIndex!].id,
                                    selectedOptionFromFirstScreen: firstQuestion
                                        .options[_selectedIndex!].option,
                                    questionIdFromFirstScreen: firstQuestion.id,
                                  ),
                                ),
                              );
                            }
                          : null, // Do nothing if no emoji is selected
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _selectedIndex != null
                              ? const Color(0xFF2E959E)
                              : Colors
                                  .grey, // Disable color if no emoji is selected
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.forward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          } else if (state is QuestionFailure) {
            return Center(
                child: Text('Failed to load questions: ${state.error}'));
          }
          return Container();
        },
      ),
    );
  }

  String _getSelectedOption(Question firstQuestion) {
    if (_selectedIndex != null &&
        _selectedIndex! < firstQuestion.options.length) {
      return firstQuestion.options[_selectedIndex!].option;
    }
    return 'your mood'; // Default text if _selectedIndex is null or out of range
  }

  String _getSvgPath(String option) {
    switch (option.toLowerCase()) {
      case 'angry':
        return 'assets/images/angry.svg';
      case 'excited':
        return 'assets/images/excited.svg';
      case 'frustrated':
        return 'assets/images/frustrated.svg';
      case 'happy':
        return 'assets/images/happy.svg';
      case 'peaceful':
        return 'assets/images/peaceful.svg';
      case 'sad':
        return 'assets/images/sad.svg';
      default:
        return 'assets/images/happy.svg'; // Default SVG path
    }
  }

  // Define the helper function to get the appropriate emotion level
  String _getEmotionLevel(String option) {
    switch (option.toLowerCase()) {
      case 'excited':
        return 'Excitement';
      case 'angry':
        return 'Anger';
      case 'happy':
        return 'Happiness';
      case 'frustrated':
        return 'Frustration';
      case 'sad':
        return 'Sadness';
      case 'peaceful':
        return 'Peace';
      default:
        return ''; // Return an empty string if option is unrecognized
    }
  }
}
