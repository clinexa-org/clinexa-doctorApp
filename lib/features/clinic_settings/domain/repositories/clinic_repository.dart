import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_entity.dart';
import '../entities/working_hours_entity.dart';

abstract class ClinicRepository {
  Future<Either<Failure, ClinicEntity>> getClinic();
  Future<Either<Failure, ClinicEntity>> updateClinic({
    required String name,
    required String address,
    String? phone,
    String? city,
    String? locationLink,
    int? slotDuration,
  });
  Future<Either<Failure, WorkingHoursScheduleEntity>> getWorkingHours();
  Future<Either<Failure, WorkingHoursScheduleEntity>> updateWorkingHours({
    required List<WorkingHoursEntity> schedule,
    required int slotDuration,
  });
}
