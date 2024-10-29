import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_bloc.dart';
import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_state.dart';
import 'package:allia_health_inc_test_app/auth/domain_layer/login_usecase.dart';
import 'package:allia_health_inc_test_app/auth/repository/auth_repository.dart';
import 'package:allia_health_inc_test_app/auth/screens/log_in_screen.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/api_service.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/repository.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/usecase.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_bloc.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_event.dart';
import 'package:allia_health_inc_test_app/widget/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  debugPaintBaselinesEnabled = false;


  // Setup the system UI overlay and orientation
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set up dependencies
    final authRepository = AuthRepository();
    final loginUseCase = LoginUseCase(authRepository);

    // Initialize the QuestionService and QuestionRepository
    final questionService =
        QuestionService(); // No need to pass the base URL now
    final questionRepository = QuestionRepositoryImpl(questionService);
    final getQuestionsUseCase = GetQuestionsUseCase(questionRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(loginUseCase),
        ),
        BlocProvider(
          create: (context) {
            // Obtain accessToken and clientId from AuthBloc after successful login
            final authBloc = context.read<AuthBloc>();
            final questionBloc =
                QuestionBloc(questionService); // Pass the questionService here
            questionBloc.add(
              FetchQuestions(
                accessToken: (authBloc.state as AuthSuccess).accessToken,
                clientId: (authBloc.state as AuthSuccess).clientId,
              ),
            );
            return questionBloc;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          // Initialize Dims.deviceSize with MediaQuery data
          Dims.setSize(MediaQuery.of(context));
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
              fontFamily: "SF-Pro",
            ),
            home: LoginScreen(),
          );
        },
      ),
    );
  }
}
