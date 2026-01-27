import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/doctor_profile_entity.dart';
import '../repositories/doctor_profile_repository.dart';

class GetDoctorProfileUseCase {
  final DoctorProfileRepository repository;

  const GetDoctorProfileUseCase(this.repository);

  Future<Either<Failure, DoctorProfileEntity>> call() {
    return repository.getDoctorProfile();
  }
}
