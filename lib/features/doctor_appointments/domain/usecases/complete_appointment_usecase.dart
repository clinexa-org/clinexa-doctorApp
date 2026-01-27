import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor_appointment_entity.dart';
import '../repositories/doctor_appointments_repository.dart';

class CompleteAppointmentUseCase {
  final DoctorAppointmentsRepository repository;

  const CompleteAppointmentUseCase(this.repository);

  Future<Either<Failure, DoctorAppointmentEntity>> call(String id) {
    return repository.completeAppointment(id);
  }
}
