import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/doctor_profile_entity.dart';
import '../../domain/repositories/doctor_profile_repository.dart';
import '../datasources/doctor_profile_remote_data_source.dart';

class DoctorProfileRepositoryImpl implements DoctorProfileRepository {
  final DoctorProfileRemoteDataSource remoteDataSource;

  DoctorProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DoctorProfileEntity>> getDoctorProfile() async {
    try {
      final response = await remoteDataSource.getDoctorProfile();
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(Failure(message: response.message));
      }
    } on DioException catch (e) {
      return Left(DioErrorMapper.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorProfileEntity>> updateDoctorProfile({
    required String specialization,
    String? name,
    String? bio,
    int? yearsOfExperience,
    String? phone,
    dynamic avatarFile,
  }) async {
    try {
      final response = await remoteDataSource.updateDoctorProfile(
        specialization: specialization,
        name: name,
        bio: bio,
        yearsOfExperience: yearsOfExperience,
        phone: phone,
        avatarFile: avatarFile is File ? avatarFile : null,
      );
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(Failure(message: response.message));
      }
    } on DioException catch (e) {
      return Left(DioErrorMapper.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
