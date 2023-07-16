import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../models/models.dart';
import '/repositories/repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final DatabaseRepository _databaseRepository;
  StreamSubscription<auth.User?>? _authUserSubscription;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required DatabaseRepository databaseRepository,
  })  : _authRepository = authRepository,
        _databaseRepository = databaseRepository,
        super(AuthState.unknown()) {
    on<AuthUserChanged>(_onAuthUserChanged);

    _authUserSubscription = _authRepository.user.listen((authUser) {
      if (authUser != null) {
        _databaseRepository.getUser(authUser.uid).listen((user) {
          add(AuthUserChanged(
            authUser: authUser,
            user: user,
          ));
        });
      } else {
        add(AuthUserChanged(authUser: authUser));
      }
    });
  }

  void _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    event.authUser != null
        ? emit(AuthState.authenticated(
            authUser: event.authUser!,
            user: event.user!,
          ))
        : emit(AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
