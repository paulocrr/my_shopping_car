import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_shopping_car/failures/failure.dart';
import 'package:my_shopping_car/models/user.dart';
import 'package:my_shopping_car/services/auth_service.dart';
import 'package:my_shopping_car/utilities/base_state.dart';

class AuthBloc extends HydratedCubit<AuthState> {
  final authService = AuthService();
  StreamSubscription<User?>? _userSubscription;

  AuthBloc() : super(const AuthState()) {
    _userSubscription = authService.user.listen((user) {
      if (user == null) {
        emit(const AuthState());
      } else {
        emit(AuthState(user: user));
      }
    });
  }

  void signInWithGoogle() async {
    _emitLoading();

    final either = await authService.logInWithGoogle();

    either.fold((f) {
      emit(AuthState(failure: Some(f)));
    }, (r) {
      emit(AuthState(user: r));
    });
  }

  void signOutWithGoogle() async {
    _emitLoading();

    final either = await authService.googleLogOut();

    either.fold((f) {
      emit(AuthState(failure: Some(f)));
    }, (r) {
      emit(const AuthState());
    });
  }

  void _emitLoading() =>
      emit(state.copyWith(isLoading: true, failure: const None()));

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toMap();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}

class AuthState extends BaseState {
  final User? user;

  static const _keyUser = 'user';

  bool get isAuthenticated {
    return user != null;
  }

  const AuthState({
    super.failure = const None(),
    super.isLoading = false,
    this.user,
  });

  AuthState copyWith({
    Option<Failure>? failure,
    bool? isLoading,
    User? user,
  }) {
    return AuthState(
      failure: failure ?? this.failure,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [...super.props, user];

  Map<String, dynamic> toMap() => {
        _keyUser: user?.toMap(),
      };

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      user: map[_keyUser] != null ? User.fromMap(map[_keyUser]) : null,
    );
  }
}
