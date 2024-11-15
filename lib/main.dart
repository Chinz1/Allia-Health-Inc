import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_bloc.dart';
import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_event.dart';
import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_state.dart';
import 'package:allia_health_inc_test_app/auth/domain_layer/login_usecase.dart';
import 'package:allia_health_inc_test_app/auth/repository/auth_repository.dart';
import 'package:allia_health_inc_test_app/auth/screens/log_in_screen.dart';
import 'package:allia_health_inc_test_app/auth/services/secure_storage_service.dart';
import 'package:allia_health_inc_test_app/question_and_answer/data_layer/api_service.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/repository.dart';
import 'package:allia_health_inc_test_app/question_and_answer/domain_layer/usecase.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_bloc.dart';
import 'package:allia_health_inc_test_app/question_and_answer/q_and_a_bloc/q_and_a_event.dart';
import 'package:allia_health_inc_test_app/widget/dimensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// Initialize GetIt service locator
final GetIt serviceLocator = GetIt.instance;

// Setting up dependencies
void setupServiceLocator() {
  serviceLocator.registerSingleton<SecureStorageService>(SecureStorageService());
  serviceLocator.registerSingleton<Dio>(Dio());
  serviceLocator.registerSingleton<QuestionService>(
    QuestionService(
      serviceLocator<Dio>(),
      serviceLocator<SecureStorageService>(),
    ),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();

  final authRepository = AuthRepository();
  final loginUseCase = LoginUseCase(authRepository);
  final authBloc = AuthBloc(loginUseCase);

  // Set Bloc observer for AuthMiddleware
  Bloc.observer = AuthMiddleware(authBloc);

   // Setup the system UI overlay and orientation
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);

  runApp(MyApp(authBloc: authBloc, loginUseCase: loginUseCase));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final LoginUseCase loginUseCase;

  MyApp({required this.authBloc, required this.loginUseCase});

  @override
  Widget build(BuildContext context) {
    final questionService = serviceLocator<QuestionService>();
    final questionRepository = QuestionRepositoryImpl(questionService);
    final getQuestionsUseCase = GetQuestionsUseCase(questionRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: authBloc,
        ),
        BlocProvider(
          create: (context) {
            final questionBloc = QuestionBloc(questionService);
            // Check AuthBloc's state and initialize QuestionBloc if authenticated
            final authState = authBloc.state;
            if (authState is AuthSuccess) {
              questionBloc.add(
                FetchQuestions(
                  accessTokens: authState.accessToken,
                  clientId: authState.clientId,
                ),
              );
            }
            return questionBloc;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          // Initialize Dims.deviceSize using MediaQuery data
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
