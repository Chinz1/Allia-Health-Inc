import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_bloc.dart';
import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_event.dart';
import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_state.dart';
import 'package:allia_health_inc_test_app/question_and_answer/screens/first_question_and_answer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final secureStorage = FlutterSecureStorage();

    // Listen to authBloc stream and handle AuthSuccess
    authBloc.stream.listen((state) {
      if (state is AuthSuccess) {
        secureStorage.write(key: "accessToken", value: state.accessToken);
      }
    });
    return Scaffold(
      backgroundColor: Color(0xFFF9F7F3), // Background color #ffffff
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi David, How are you?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000), // Text color #000000
              ),
            ),
            SizedBox(height: 16), // Space between text and container
            Container(
              width: MediaQuery.of(context).size.width, // Full screen width
              height: 144, // Height of the container
              decoration: BoxDecoration(
                color: Color(0xFFAC8E63), // Container color #AC8E63
                borderRadius: BorderRadius.circular(
                    16.0), // Curving all edges with 16.0 radius
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(16.0), // Padding inside the container
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help your Therapist know',
                      style: TextStyle(
                        color: Color(0xFFE1D9C5), // Text color #E1D9C5
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    const SizedBox(height: 8.0), // Space between texts
                    Text(
                      'how to best support you',
                      style: TextStyle(
                        color: Color(0xFFE1D9C5), // Text color #E1D9C5
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24.0), // Space between texts
                    InkWell(
                      onTap: () async {
                        // Retrieve the refresh token from secure storage
                        String? refreshToken =
                            await secureStorage.read(key: "accessToken");

                        if (refreshToken != null) {
                          // Trigger TokenExpired with the actual token
                          authBloc
                              .add(TokenExpired(refreshToken: refreshToken));
                          authBloc.stream.listen((state) {
                            if (state is AuthSuccess) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FirstQuestionAndAnswerScreen(),
                                ),
                              );
                            }
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FirstQuestionAndAnswerScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Take A Check-in',
                        style: TextStyle(
                          color:
                              Color(0xFFFFFFFF), // Text color #FFFFFF (white)
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
