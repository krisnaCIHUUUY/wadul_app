part of 'instansi_cubit.dart';

sealed class InstansiState extends Equatable {
  const InstansiState();

  @override
  List<Object> get props => [];
}

final class InstansiInitial extends InstansiState {}

class InstansiLoading extends InstansiState {}

class InstansiLoaded extends InstansiState {
  final List<InstansiEntity> instansiList;
  const InstansiLoaded(this.instansiList);

  @override
  List<Object> get props => [instansiList];
}

class InstansiError extends InstansiState {
  final String message;
  const InstansiError(this.message);

  @override
  List<Object> get props => [message];
}
