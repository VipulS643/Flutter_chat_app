import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> data;

  LoginSuccess(this.data);

  String get userId => data["data"]["user"]["_id"];

  @override
  List<Object?> get props => [data];
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}
