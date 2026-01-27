import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/doctor_appointment_entity.dart';
import '../../domain/repositories/doctor_appointments_repository.dart';
import '../datasources/doctor_appointments_remote_data_source.dart';

class DoctorAppointmentsRepositoryImpl implements DoctorAppointmentsRepository {
  final DoctorAppointmentsRemoteDataSource remoteDataSource;

  DoctorAppointmentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getDoctorAppointments({
    String? date,
  }) async {
    try {
      final response = await remoteDataSource.getDoctorAppointments(date: date);
      if (response.success) {
        return Right(response.data ?? []);
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
  Future<Either<Failure, DoctorAppointmentEntity>> confirmAppointment(
      String id) async {
    try {
      final response = await remoteDataSource.confirmAppointment(id);
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
  Future<Either<Failure, DoctorAppointmentEntity>> completeAppointment(
      String id) async {
    try {
      final response = await remoteDataSource.completeAppointment(id);
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
  Future<Either<Failure, bool>> cancelAppointment(String id,
      {String? reason}) async {
    try {
      final response =
          await remoteDataSource.cancelAppointment(id, reason: reason);
      if (response.success) {
        return const Right(true);
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
