import 'package:wadul_app/features/instansi/domain/entities/instansi_entity.dart';

abstract class InstansiRepository {
  Future<List<InstansiEntity>> fetchAllInstansi();
}
