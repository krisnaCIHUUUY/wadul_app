class UsersModel {
  final String uid;
  final String nama;
  final String email;
  final String role;

  UsersModel({
    required this.uid,
    required this.nama,
    required this.email,
    required this.role,
  });

  factory UsersModel.fromJson(Map<String, dynamic> map, String id) {
    return UsersModel(
      uid: id,
      nama: map["nama"] ?? '',
      email: map["email"] ?? '',
      role: map["role"] ?? '',
    );
  }
}
