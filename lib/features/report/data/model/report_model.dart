import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart'; // Import ReportEntity

class DocumentationModel extends Documentation {
  const DocumentationModel({
    required super.fotoUrl,
    required super.deskripsi,
    required super.createdAt,
  });

  factory DocumentationModel.fromMap(Map<String, dynamic> map) {
    final timestamp = map['createdAt'] as Timestamp?;
    return DocumentationModel(
      fotoUrl: map['fotoUrl'] as String,
      deskripsi: map['deskripsi'] as String,
      createdAt: timestamp?.toDate() ?? DateTime.now(),
    );
  }
  @override
  Map<String, dynamic> toMap() {
    return {'fotoUrl': fotoUrl, 'deskripsi': deskripsi, 'createdAt': createdAt};
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
    required super.userId,
    required super.status,
    required super.instansiId,
    super.documentation,
  });

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
      userId: map["userId"] as String,
      status: map["status"] as String,
      instansiId: map['instansiId'] as String,
      documentation: documentationList,
    );
  }

  factory ReportModel.fromEntity(ReportEntity entity) {
    return ReportModel(
      id: entity.id,
      judul: entity.judul,
      deskripsi: entity.deskripsi,
      kategori: entity.kategori,
      lokasi: entity.lokasi,
      buktiFotoURL: entity.buktiFotoURL,
      tanggal: entity.tanggal,
      userId: entity.userId,
      status: entity.status,
      instansiId: entity.instansiId,
      documentation: entity.documentation,
    );
  }

  // ------------------------------------------------------------------
  // 2. TO MAP (Mengirim data ke Firestore)
  // ------------------------------------------------------------------
  @override
  Map<String, dynamic> toMap() {
    return {
      // "judul": judul,
      // "deskripsi": deskripsi,
      // "kategori": kategori,
      // "lokasi": lokasi,
      // "buktiFotoURL": buktiFotoURL,
      // "tanggal": tanggal,
      // "userId": userId,
      // "status": status,
      ...super.toMap(),
      "instansiId": instansiId,
      "documentation": documentation.map((doc) {
        if (doc is DocumentationModel) {
          return doc.toMap();
        } else {
          // convert Documentation (entity) ke DocumentationModel
          return DocumentationModel(
            fotoUrl: doc.fotoUrl,
            deskripsi: doc.deskripsi,
            createdAt: doc.createdAt,
          ).toMap();
        }
      }).toList(),
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
    String? instansiId,
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
      userId: userId ?? this.userId,
      status: status ?? this.status,
      instansiId: instansiId?? this.instansiId,
      documentation: documentation ?? this.documentation,
    );
  }
}
