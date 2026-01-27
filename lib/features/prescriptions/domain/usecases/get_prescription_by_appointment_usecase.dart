import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription_entity.dart';
import '../repositories/prescriptions_repository.dart';

class GetPrescriptionByAppointmentUseCase {
  final PrescriptionsRepository repository;
  const GetPrescriptionByAppointmentUseCase(this.repository);

  Future<Either<Failure, PrescriptionEntity?>> call(String appointmentId) =>
      repository.getPrescriptionByAppointment(appointmentId);
}
