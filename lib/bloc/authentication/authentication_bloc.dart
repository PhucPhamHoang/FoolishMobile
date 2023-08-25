import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/user.dart';
import '../../repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  User? currentUser;
  String registerMessage = '';
  String logoutMessage = '';

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial()) {
    on<OnLoginAuthenticationEvent>((event, emit) async {
      emit(AuthenticationLoadingState());

      try {
        dynamic response = await _authenticationRepository.login(
          event.userName,
          event.password,
        );

        if (response is User) {
          currentUser = response;
          emit(AuthenticationLoggedInState(response));
        } else {
          debugPrint(response.toString());
          emit(AuthenticationErrorState(response.toString()));
        }
      } catch (e) {
        emit(AuthenticationErrorState(e.toString()));
      }
    });

    on<OnRegisterAuthenticationEvent>((event, emit) async {
      emit(AuthenticationLoadingState());

      try {
        String response = await _authenticationRepository.register(
          event.userName,
          event.password,
          event.name,
          event.email,
          event.phoneNumber,
        );

        if (response == 'Register successfully') {
          registerMessage = response;
          emit(AuthenticationRegisteredState(response));
        } else {
          registerMessage = response;
          emit(AuthenticationErrorState(response));
        }
      } catch (e) {
        emit(AuthenticationErrorState(e.toString()));
      }
    });

    on<OnUpdateNewAvatarAuthenticationEvent>((event, emit) {
      currentUser?.avatar = event.newFileId;
      emit(AuthenticationAvatarUpdatedState(event.newFileId));
    });

    on<OnLogoutAuthenticationEvent>((event, emit) async {
      emit(AuthenticationLoadingState());

      String response = await _authenticationRepository.logout();

      if (response == 'Logout successfully') {
        logoutMessage = response;
        emit(AuthenticationLoggedOutState(response));
      } else {
        emit(AuthenticationErrorState(response));
      }
    });
  }
}
