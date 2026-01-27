import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription_entity.dart';
import '../repositories/prescriptions_repository.dart';

class CreatePrescriptionUseCase {
  final PrescriptionsRepository repository;
  const CreatePrescriptionUseCase(this.repository);

  Future<Either<Failure, PrescriptionEntity>> call({
    required String appointmentId,
    required String patientId,
    required String diagnosis,
    required List<MedicationEntity> medications,
    String? notes,
  }) =>
      repository.createPrescription(
        appointmentId: appointmentId,
        patientId: patientId,
        diagnosis: diagnosis,
        medications: medications,
        notes: notes,
      );
}
