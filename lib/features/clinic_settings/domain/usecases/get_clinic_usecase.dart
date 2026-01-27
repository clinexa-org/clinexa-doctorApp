import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_entity.dart';
import '../repositories/clinic_repository.dart';

class GetClinicUseCase {
  final ClinicRepository repository;
  const GetClinicUseCase(this.repository);

  Future<Either<Failure, ClinicEntity>> call() => repository.getClinic();
}
