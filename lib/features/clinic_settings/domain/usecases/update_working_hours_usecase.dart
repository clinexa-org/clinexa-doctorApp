import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/working_hours_entity.dart';
import '../repositories/clinic_repository.dart';

class UpdateWorkingHoursUseCase {
  final ClinicRepository repository;
  const UpdateWorkingHoursUseCase(this.repository);

  Future<Either<Failure, WorkingHoursScheduleEntity>> call({
    required List<WorkingHoursEntity> schedule,
    required int slotDuration,
  }) =>
      repository.updateWorkingHours(
          schedule: schedule, slotDuration: slotDuration);
}
