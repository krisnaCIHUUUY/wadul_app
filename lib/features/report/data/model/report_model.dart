import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart'; // Import ReportEntity

// Model untuk Dokumentasi (sebagai turunan dari Documentation Entity)
class DocumentationModel extends Documentation {
  const DocumentationModel({
    required super.fotoUrl,
    required super.deskripsi,
    required super.createdAt,
  });

  // Konversi dari Map Firestore ke DocumentationModel
  factory DocumentationModel.fromMap(Map<String, dynamic> map) {
    final timestamp = map['createdAt'] as Timestamp?;
    return DocumentationModel(
      fotoUrl: map['fotoUrl'] as String,
      deskripsi: map['deskripsi'] as String,
      createdAt: timestamp?.toDate() ?? DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'fotoUrl': fotoUrl,
      'deskripsi': deskripsi,
      'createdAt': createdAt,
    };
  }
}

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.id,
    required super.judul,
    required super.deskripsi,
    required super.kategori,
    required super.lokasi,
    required super.buktiFotoURL,
    required super.tanggal,
    required super.userID,
    required super.status,
    super.documentation, 
  });

  // ------------------------------------------------------------------
  // 1. FACTORY FROM MAP (Mengambil data dari Firestore)
  // ------------------------------------------------------------------
  // Metode ini menerima Map<String, dynamic> dan ID dokumen
  factory ReportModel.fromMap(Map<String, dynamic> map, String id) {
    final timestamp = map['tanggal'] as Timestamp?;

    final documentationList = (map['documentation'] as List<dynamic>? ?? [])
        .map(
          (docMap) =>
              DocumentationModel.fromMap(docMap as Map<String, dynamic>),
        )
        .toList();

    return ReportModel(
      id: id, 
      judul: map["judul"] as String,
      deskripsi: map["deskripsi"] as String,
      kategori: map["kategori"] as String,
      lokasi: map["lokasi"] as String,
      buktiFotoURL: map["buktiFotoURL"] as String,
      tanggal: timestamp?.toDate() ?? DateTime.now(),
      userID: map["userID"] as String,
      status: map["status"] as String,
      documentation: documentationList,
    );
  }

  // ------------------------------------------------------------------
  // 2. TO MAP (Mengirim data ke Firestore)
  // ------------------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      "judul": judul,
      "deskripsi": deskripsi,
      "kategori": kategori,
      "lokasi": lokasi,
      "buktiFotoURL": buktiFotoURL,
      "tanggal": tanggal,
      "userID": userID,
      "status": status,
      "documentation": documentation
          .map((doc) => (doc as DocumentationModel).toMap())
          .toList(),
    };
  }

  ReportModel copyWith({
    String? id,
    String? judul,
    String? deskripsi,
    String? kategori,
    String? lokasi,
    String? buktiFotoURL,
    DateTime? tanggal,
    String? userId,
    String? status,
    List<Documentation>? documentation,
  }) {
    return ReportModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      kategori: kategori ?? this.kategori,
      lokasi: lokasi ?? this.lokasi,
      buktiFotoURL: buktiFotoURL ?? this.buktiFotoURL,
      tanggal: tanggal ?? this.tanggal,
      userID: userId ?? this.userID,
      status: status ?? this.status,
      documentation: documentation ?? this.documentation,
    );
  }
}
