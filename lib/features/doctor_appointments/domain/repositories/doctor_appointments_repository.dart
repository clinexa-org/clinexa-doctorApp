import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor_appointment_entity.dart';

abstract class DoctorAppointmentsRepository {
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getDoctorAppointments({
    String? date,
    String? search,
  });
  Future<Either<Failure, DoctorAppointmentEntity>> confirmAppointment(
      String id);
  Future<Either<Failure, DoctorAppointmentEntity>> completeAppointment(
      String id);
  Future<Either<Failure, bool>> cancelAppointment(String id, {String? reason});
}
