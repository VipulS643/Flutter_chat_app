import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../repository/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      final response = await repository.login(
        event.email,
        event.password,
        event.role,
      );

      print("Login response: $response");

      if (response["data"] != null) {
        emit(LoginSuccess(response));
      } else {
        emit(LoginFailure(response["message"] ?? "Login failed"));
      }
    });
  }
}
