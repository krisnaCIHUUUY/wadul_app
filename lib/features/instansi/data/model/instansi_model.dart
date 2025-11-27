import 'package:wadul_app/features/instansi/domain/entities/instansi_entity.dart';

class InstansiModel extends InstansiEntity {
  const InstansiModel({
    required super.id,
    required super.nama,
    required super.jenis,
    required super.deskripsi,
    required super.alamat,
    required super.email,
    required super.fotoUrl
  });

  factory InstansiModel.fromMap(Map<String, dynamic> map, String id) {
    return InstansiModel(
      id: id,
      nama: map['nama'] as String,
      jenis: map['jenis'] as String,
      deskripsi:  map['deskripsi'] as String,
      alamat:  map['alamat'] as String,
      email: map['email'] as String,
      fotoUrl: map['fotoUrl'] as String
    );
  }

  // 2. TO MAP (Tidak wajib di sini karena hanya untuk Read, tapi berguna jika ada Update)
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jenis': jenis,
      'deskripsi': deskripsi,
      'alamat': alamat,
      'email': email,
      'fotoUrl': fotoUrl
      // ID tidak disertakan karena ID adalah kunci dokumen
    };
  }
}
