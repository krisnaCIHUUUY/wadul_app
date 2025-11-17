import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Documentation extends Equatable {
  final String fotoUrl;
  final String deskripsi;
  final DateTime createdAt;

  const Documentation({
    required this.fotoUrl,
    required this.deskripsi,
    required this.createdAt,
  });

  factory Documentation.fromMap(Map<String, dynamic> map) {
    return Documentation(
      fotoUrl: map['fotoUrl'] as String,
      deskripsi: map['deskripsi'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'fotoUrl': fotoUrl, 'deskripsi': deskripsi, 'createdAt': createdAt};
  }

  @override
  List<Object> get props => [fotoUrl, deskripsi, createdAt];
}

class ReportEntity extends Equatable {
  final String? id;
  final String judul;
  final String deskripsi;
  final String kategori;
  final String lokasi;
  final String buktiFotoURL;
  final DateTime tanggal;
  final String userID;
  final String status;
  final List<Documentation> documentation;

  const ReportEntity({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.lokasi,
    required this.buktiFotoURL,
    required this.tanggal,
    required this.userID,
    required this.status,
    this.documentation = const [],
  });

  //  untuk CREATE
  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'lokasi': lokasi,
      'buktiFotoURL': buktiFotoURL,
      'tanggal': FieldValue.serverTimestamp(),
      'userID': userID,
      'status': status,
      'documentation': documentation.map((doc) => doc.toMap()).toList(),
    };
  }

  // untuk GET
  factory ReportEntity.fromMap(Map<String, dynamic> map, String id) {
    final timestamp = map['tanggal'] as Timestamp?;
    final documentationList = (map['documentation'] as List<dynamic>? ?? [])
        .map((docMap) => Documentation.fromMap(docMap as Map<String, dynamic>))
        .toList();

    return ReportEntity(
      id: id,
      judul: map['judul'] as String,
      deskripsi: map['deskripsi'] as String,
      kategori: map['kategori'] as String,
      lokasi: map['lokasi'] as String,
      buktiFotoURL: map['buktiFotoURL'] as String,
      tanggal: timestamp?.toDate() ?? DateTime.now(),
      userID: map['userID'] as String,
      status: map['status'] as String,
      documentation: documentationList,
    );
  }

  @override
  List<Object?> get props => [
    id,
    judul,
    deskripsi,
    kategori,
    lokasi,
    buktiFotoURL,
    tanggal,
    userID,
    status,
    documentation,
  ];
}
