import 'package:fpdart/fpdart.dart';
import 'package:wadul_app/core/error/failure.dart';
import 'package:wadul_app/features/authentication/domain/entities/user_entity.dart';
import 'package:wadul_app/features/authentication/domain/repository/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;
  GetCurrentUser(this.repository);
  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
