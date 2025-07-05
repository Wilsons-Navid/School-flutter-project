// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:wilson_note_taker/data/repositories/auth_repository.dart';
// import 'package:wilson_note_taker/presentation/blocs/auth/auth_event.dart';
// import 'package:wilson_note_taker/presentation/blocs/auth/auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository _authRepository;

//   AuthBloc({required AuthRepository authRepository})
//     : _authRepository = authRepository,
//       super(AuthInitial()) {
//     on<AuthStarted>(_onAuthStarted);
//     on<AuthSignInRequested>(_onAuthSignInRequested);
//     on<AuthSignUpRequested>(_onAuthSignUpRequested);
//     on<AuthSignOutRequested>(_onAuthSignOutRequested);
//   }

//   void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
//     final user = _authRepository.currentUser;
//     if (user != null) {
//       emit(AuthAuthenticated());
//     } else {
//       emit(AuthUnauthenticated());
//     }
//   }

//   Future<void> _onAuthSignInRequested(
//     AuthSignInRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       await _authRepository.signInWithEmailAndPassword(
//         email: event.email,
//         password: event.password,
//       );
//       emit(AuthAuthenticated());
//     } on FirebaseAuthException catch (e) {
//       emit(AuthError(message: _getErrorMessage(e)));
//     } catch (e) {
//       emit(AuthError(message: 'An unexpected error occurred'));
//     }
//   }

//   Future<void> _onAuthSignUpRequested(
//     AuthSignUpRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       await _authRepository.createUserWithEmailAndPassword(
//         email: event.email,
//         password: event.password,
//       );
//       emit(AuthAuthenticated());
//     } on FirebaseAuthException catch (e) {
//       emit(AuthError(message: _getErrorMessage(e)));
//     } catch (e) {
//       emit(AuthError(message: 'An unexpected error occurred'));
//     }
//   }

//   Future<void> _onAuthSignOutRequested(
//     AuthSignOutRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     try {
//       await _authRepository.signOut();
//       emit(AuthUnauthenticated());
//     } catch (e) {
//       emit(AuthError(message: 'Failed to sign out'));
//     }
//   }

//   String _getErrorMessage(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'user-not-found':
//         return 'No user found with this email address.';
//       case 'wrong-password':
//         return 'Incorrect password. Please try again.';
//       case 'email-already-in-use':
//         return 'An account already exists with this email address.';
//       case 'weak-password':
//         return 'Password is too weak. Please use at least 6 characters.';
//       case 'invalid-email':
//         return 'Please enter a valid email address.';
//       default:
//         return e.message ?? 'An error occurred during authentication.';
//     }
//   }
// }


import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wilson_note_taker/data/repositories/auth_repository.dart';
import 'package:wilson_note_taker/presentation/blocs/auth/auth_event.dart';
import 'package:wilson_note_taker/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<User?> _authStreamSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    
    // Listen to auth state changes
    _authStreamSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          add(AuthUserChanged(user: user));
        } else {
          add(AuthUserChanged(user: null));
        }
      },
    );

    on<AuthStarted>(_onAuthStarted);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      // Don't emit here - let the stream handle it
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      // Don't emit here - let the stream handle it
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
      // Don't emit here - let the stream handle it
    } catch (e) {
      emit(AuthError(message: 'Failed to sign out'));
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return e.message ?? 'An error occurred during authentication.';
    }
  }

  @override
  Future<void> close() {
    _authStreamSubscription.cancel();
    return super.close();
  }
}