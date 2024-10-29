// import 'dart:convert';

// import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_bloc.dart';
// import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_event.dart';
// import 'package:allia_health_inc_test_app/auth/auth_bloc/auth_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// bool isTokenExpired(String token) {
//   final payload = token.split('.')[1];
//   final normalized = base64Url.normalize(payload);
//   final decoded = utf8.decode(base64Url.decode(normalized));
//   final exp = jsonDecode(decoded)['exp'];

//   final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//   return exp < now;
// }

// // void makeApiCall(BuildContext context, String accessToken, String refreshToken, Function onApiCall) {
// //   if (isTokenExpired(accessToken)) {
// //     // Dispatch a token refresh event
// //     context.read<AuthBloc>().add(TokenExpired(refreshToken: refreshToken));

// //     // Listen for when the token is successfully refreshed
// //     context.read<AuthBloc>().stream.listen((state) {
// //       if (state is AuthSuccess) {
// //         // When the token is refreshed, retry the API call with the new token
// //         onApiCall(state.accessToken); // Use the new access token from AuthSuccess
// //       } else if (state is AuthFailure) {
// //         // Handle token refresh error
// //       }
// //     });
// //   } else {
// //     // Proceed with the API call using the valid current access token
// //     onApiCall(accessToken);
// //   }
// // }



// Future<void> makeApiCall({
//   required BuildContext context,
//   required String accessToken,
//   required String refreshToken,
//   required Function(String) onApiCall,
// }) async {
//   if (isTokenExpired(accessToken)) {
//     context.read<AuthBloc>().add(TokenExpired(refreshToken: refreshToken));

//     await for (var state in context.read<AuthBloc>().stream) {
//       if (state is AuthSuccess) {
//         // Use the new access token from AuthSuccess and retry the API call
//         onApiCall(state.accessToken);
//         break; // Exit the stream once the new token is available
//       } else if (state is AuthFailure) {
//         // Handle token refresh error, like showing a logout option
//         break; // Exit the stream on failure as well
//       }
//     }
//   } else {
//     // Use the valid access token
//     onApiCall(accessToken);
//   }
// }
