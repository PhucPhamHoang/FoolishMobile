part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class OnLoginAuthenticationEvent extends AuthenticationEvent {
  final String userName;
  final String password;

  const OnLoginAuthenticationEvent(this.userName, this.password);
}
