import 'package:firebase_auth/firebase_auth.dart';
import 'package:wadul_app/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, super.email, super.displayName});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'displayName': displayName};
  }
}
