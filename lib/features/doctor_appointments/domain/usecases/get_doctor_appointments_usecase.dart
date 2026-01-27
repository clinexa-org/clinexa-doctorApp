import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor_appointment_entity.dart';
import '../repositories/doctor_appointments_repository.dart';

class GetDoctorAppointmentsUseCase {
  final DoctorAppointmentsRepository repository;

  const GetDoctorAppointmentsUseCase(this.repository);

  Future<Either<Failure, List<DoctorAppointmentEntity>>> call({String? date}) {
    return repository.getDoctorAppointments(date: date);
  }
}
