import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/working_hours_entity.dart';
import '../repositories/clinic_repository.dart';

class GetWorkingHoursUseCase {
  final ClinicRepository repository;
  const GetWorkingHoursUseCase(this.repository);

  Future<Either<Failure, WorkingHoursScheduleEntity>> call() =>
      repository.getWorkingHours();
}
