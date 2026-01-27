import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/doctor_appointments_repository.dart';

class CancelAppointmentUseCase {
  final DoctorAppointmentsRepository repository;

  const CancelAppointmentUseCase(this.repository);

  Future<Either<Failure, bool>> call(String id, {String? reason}) {
    return repository.cancelAppointment(id, reason: reason);
  }
}
