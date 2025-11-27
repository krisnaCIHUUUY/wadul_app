import 'package:equatable/equatable.dart';

class InstansiEntity extends Equatable {
  final String id;
  final String nama;
  final String jenis;
  final String deskripsi;
  final String alamat;
  final String email;
  final String fotoUrl;

  const InstansiEntity({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.deskripsi,
    required this.alamat,
    required this.email,
    required this.fotoUrl,
  });

  factory InstansiEntity.fromFirestore(Map<String, dynamic> map, String id) {
    return InstansiEntity(
      id: id,
      nama: map['nama'] ?? '',
      jenis: map['jenis'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      alamat: map['alamat'] ?? '',
      email: map['email'] ?? '',
      fotoUrl: map['fotoUrl'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    nama,
    jenis,
    deskripsi,
    alamat,
    email,
    fotoUrl,
  ];
}
