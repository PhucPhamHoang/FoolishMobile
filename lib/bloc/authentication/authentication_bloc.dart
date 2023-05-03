import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/entity/User.dart';
import '../../repository/AuthenticationRepository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  User? currentUser;

  AuthenticationBloc(this._authenticationRepository) : super(AuthenticationInitial()) {
    on<OnLoginAuthenticationEvent>((event, emit) async {
      emit(AuthenticationLoadingState());

      try{
        dynamic response = await _authenticationRepository.login(event.userName, event.password);

        if(response is User) {
          currentUser = response;
          emit(AuthenticationLoggedInState(response));
        }
        else {
          print(response.toString());
          emit(AuthenticationErrorState(response.toString()));
        }

      }
      catch(e) {
        emit(AuthenticationErrorState(e.toString()));
      }
    });
  }
}
