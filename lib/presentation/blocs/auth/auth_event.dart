// import 'package:equatable/equatable.dart';

// abstract class AuthEvent extends Equatable {
//   const AuthEvent();

//   @override
//   List<Object> get props => [];
// }

// class AuthStarted extends AuthEvent {}

// class AuthSignInRequested extends AuthEvent {
//   final String email;
//   final String password;

//   const AuthSignInRequested({required this.email, required this.password});

//   @override
//   List<Object> get props => [email, password];
// }

// class AuthSignUpRequested extends AuthEvent {
//   final String email;
//   final String password;

//   const AuthSignUpRequested({required this.email, required this.password});

//   @override
//   List<Object> get props => [email, password];
// }

// class AuthSignOutRequested extends AuthEvent {}

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final User? user;

  const AuthUserChanged({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {}