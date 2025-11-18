import 'package:equatable/equatable.dart';
import 'package:wadul_app/features/authentication/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final UserEntity userEntity;
  const AuthLoaded(this.userEntity);

  @override
  List<Object> get props => [userEntity];
}

class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class Authenticated extends AuthState {
  final String uid;
  final String email;

  const Authenticated(this.uid, this.email);

  @override
  List<Object?> get props => [uid, email];
}

class Unauthenticated extends AuthState {}
