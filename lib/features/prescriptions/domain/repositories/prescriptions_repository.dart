import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription_entity.dart';

abstract class PrescriptionsRepository {
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions();
  Future<Either<Failure, PrescriptionEntity>> getPrescriptionById(String id);
  Future<Either<Failure, PrescriptionEntity?>> getPrescriptionByAppointment(
      String appointmentId);
  Future<Either<Failure, PrescriptionEntity>> createPrescription({
    required String appointmentId,
    required String patientId,
    required String diagnosis,
    required List<MedicationEntity> medications,
    String? notes,
  });
  Future<Either<Failure, PrescriptionEntity>> updatePrescription({
    required String id,
    required String diagnosis,
    required List<MedicationEntity> medications,
    String? notes,
  });
}
