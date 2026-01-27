import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor_profile_entity.dart';

abstract class DoctorProfileRepository {
  Future<Either<Failure, DoctorProfileEntity>> getDoctorProfile();
  Future<Either<Failure, DoctorProfileEntity>> updateDoctorProfile({
    required String specialization,
    String? name,
    String? bio,
    int? yearsOfExperience,
    String? phone,
    dynamic avatarFile,
  });
}
