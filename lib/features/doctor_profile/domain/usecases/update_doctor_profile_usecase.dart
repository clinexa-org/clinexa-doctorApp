import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/doctor_profile_entity.dart';
import '../repositories/doctor_profile_repository.dart';

class UpdateDoctorProfileUseCase {
  final DoctorProfileRepository repository;

  const UpdateDoctorProfileUseCase(this.repository);

  Future<Either<Failure, DoctorProfileEntity>> call({
    required String specialization,
    String? name,
    String? bio,
    int? yearsOfExperience,
    String? phone,
    dynamic avatarFile,
  }) {
    return repository.updateDoctorProfile(
      specialization: specialization,
      name: name,
      bio: bio,
      yearsOfExperience: yearsOfExperience,
      phone: phone,
      avatarFile: avatarFile,
    );
  }
}
