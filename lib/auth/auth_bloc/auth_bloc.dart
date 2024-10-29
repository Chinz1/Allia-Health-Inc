import 'package:allia_health_inc_test_app/auth/domain_layer/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
// import '../../domain/login_usecase.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc(this.loginUseCase) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await loginUseCase(event.email, event.password);
        emit(AuthSuccess(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          chatToken: response.chatToken,
          clientId: response.client.id, // Extract the client ID here
        ));
       
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<TokenExpired>((event, emit) async {
      emit(AuthLoading());
      try {
        // Call the refresh token function
        final response = await loginUseCase.refreshAccessToken(event.refreshToken);
        emit(AuthSuccess(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          chatToken: response.chatToken,
          clientId: response.client.id,
        ));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
