import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/entities/working_hours_entity.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../datasources/clinic_remote_data_source.dart';
import '../models/working_hours_model.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  final ClinicRemoteDataSource remoteDataSource;

  ClinicRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ClinicEntity>> getClinic() async {
    try {
      final response = await remoteDataSource.getClinic();
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
  Future<Either<Failure, ClinicEntity>> updateClinic({
    required String name,
    required String address,
    String? phone,
    String? city,
    String? locationLink,
    int? slotDuration,
  }) async {
    try {
      final response = await remoteDataSource.updateClinic(
        name: name,
        address: address,
        phone: phone,
        city: city,
        locationLink: locationLink,
        slotDuration: slotDuration,
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

  @override
  Future<Either<Failure, WorkingHoursScheduleEntity>> getWorkingHours() async {
    try {
      final response = await remoteDataSource.getWorkingHours();
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
  Future<Either<Failure, WorkingHoursScheduleEntity>> updateWorkingHours({
    required List<WorkingHoursEntity> schedule,
    required int slotDuration,
  }) async {
    try {
      final models = schedule
          .map((e) => WorkingHoursModel(
                dayOfWeek: e.dayOfWeek,
                isOpen: e.isOpen,
                startTime: e.startTime,
                endTime: e.endTime,
              ))
          .toList();

      final response = await remoteDataSource.updateWorkingHours(
        schedule: models,
        slotDuration: slotDuration,
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
