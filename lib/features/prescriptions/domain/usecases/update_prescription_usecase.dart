import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription_entity.dart';
import '../repositories/prescriptions_repository.dart';

class UpdatePrescriptionUseCase {
  final PrescriptionsRepository repository;
  const UpdatePrescriptionUseCase(this.repository);

  Future<Either<Failure, PrescriptionEntity>> call({
    required String id,
    required String diagnosis,
    required List<MedicationEntity> medications,
    String? notes,
  }) =>
      repository.updatePrescription(
        id: id,
        diagnosis: diagnosis,
        medications: medications,
        notes: notes,
      );
}
