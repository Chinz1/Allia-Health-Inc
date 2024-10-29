import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_bloc.dart';
import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_event.dart';
import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_state.dart';
import 'package:allia_health_inc_test_app/home/home_screen.dart';
import 'package:allia_health_inc_test_app/widget/app_filled_button.dart';
import 'package:allia_health_inc_test_app/widget/app_text_button.dart';
import 'package:allia_health_inc_test_app/widget/app_text_field.dart';
import 'package:allia_health_inc_test_app/widget/custom_bottom_modal.dart';
import 'package:allia_health_inc_test_app/widget/dimensions.dart';
import 'package:allia_health_inc_test_app/widget/strings.dart';
import 'package:allia_health_inc_test_app/widget/theme.dart';
import 'package:allia_health_inc_test_app/widget/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome!',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: appColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),

                      //
                      const Text(
                        'Securely login to your Allia Health Inc account',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFFAC8E63),
                        ),
                      ),

                      const SizedBox(height: 42),
                      const SizedBox(height: 60.0),
                      AppTextField(
                          title: 'Email address',
                          labelText: 'Email address',
                          textInputAction: TextInputAction.next,
                          controller: _emailController,
                          validator: Validator.nonEmptyField),
                      const SizedBox(height: 24),
                      AppTextField(
                        title: 'Password',
                        labelText: 'Password',
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        // validator: Validator.password,
                      ),
                      const SizedBox(height: 100.0),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          } else if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.red,
                                  content:
                                      Text('Login failed: ${state.error}')),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return AppFilledButton(
                            buttonText: kLogin,
                            onPressed: () async {
                              if (_formKey.currentState?.validate() == true) {
                                final email = _emailController.text;
                                final password = _passwordController.text;

                                // Dispatch the LoginRequested event
                                context.read<AuthBloc>().add(LoginRequested(
                                      email: email,
                                      password: password,
                                    ));
                              }
                            },
                            buttonColor: const Color(0xFF2E959E),
                          );
                        },
                      ),
                      const SizedBox(height: 30.0),
                      // Sign up button
                      Center(
                        child: AppRichTextButton(
                            highLightedText: kRegister,
                            text: kDontHaveAcct,
                            onTap: () => ()),
                      ),
                      const SizedBox(height: 10.0),

                      // Forgot password
                      AppTextButton(
                          text: kForgotPassword,
                          onPressed: () {
                            customBottomModal(
                              context,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: hPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    YBox(38.dy),
                                    Text(
                                      'Forgot Username or Password?',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: appColors.textColor,
                                      ),
                                    ),
                                    YBox(15.dy),
                                    Text(
                                      'It seems you forgot your username or password?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: appColors.grey,
                                      ),
                                    ),
                                    const YBox(5),
                                    Text(
                                      'Provide your email address so we can help you',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: appColors.grey,
                                      ),
                                    ),
                                    YBox(32.dy),
                                    const Form(
                                      child: AppTextField(
                                        title: 'Email Address',
                                        labelText: 'Email',
                                        isPassword: false,
                                        textInputAction: TextInputAction.done,
                                        // controller: _emailController,
                                        validator: Validator.emailValidator,
                                      ),
                                    ),
                                    YBox(54.dy),
                                    AppFilledButton(
                                      buttonText: 'Next',
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      buttonColor: const Color(0xFF2E959E),
                                    ),
                                    YBox(54.dy),
                                  ],
                                ),
                              ),
                            );
                          })
                    ]))));
  }
}
