import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/repositories/prescriptions_repository.dart';
import '../datasources/prescriptions_remote_data_source.dart';
import '../models/prescription_model.dart';

class PrescriptionsRepositoryImpl implements PrescriptionsRepository {
  final PrescriptionsRemoteDataSource remoteDataSource;

  PrescriptionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions() async {
    try {
      final response = await remoteDataSource.getPrescriptions();
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
  Future<Either<Failure, PrescriptionEntity>> getPrescriptionById(
      String id) async {
    try {
      final response = await remoteDataSource.getPrescriptionById(id);
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
  Future<Either<Failure, PrescriptionEntity?>> getPrescriptionByAppointment(
      String appointmentId) async {
    try {
      final response =
          await remoteDataSource.getPrescriptionByAppointment(appointmentId);
      if (response.success) {
        return Right(response.data);
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
  Future<Either<Failure, PrescriptionEntity>> createPrescription({
    required String appointmentId,
    required String patientId,
    required String diagnosis,
    required List<MedicationEntity> medications,
    String? notes,
  }) async {
    try {
      final medicationModels = medications
          .map((m) => MedicationModel(
                name: m.name,
                dosage: m.dosage,
                frequency: m.frequency,
                duration: m.duration,
                instructions: m.instructions,
              ))
          .toList();

      final response = await remoteDataSource.createPrescription(
        appointmentId: appointmentId,
        patientId: patientId,
        diagnosis: diagnosis,
        medications: medicationModels,
        notes: notes,
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
  Future<Either<Failure, PrescriptionEntity>> updatePrescription({
    required String id,
    required String diagnosis,
    required List<MedicationEntity> medications,
    String? notes,
  }) async {
    try {
      final medicationModels = medications
          .map((m) => MedicationModel(
                name: m.name,
                dosage: m.dosage,
                frequency: m.frequency,
                duration: m.duration,
                instructions: m.instructions,
              ))
          .toList();

      final response = await remoteDataSource.updatePrescription(
        id: id,
        diagnosis: diagnosis,
        medications: medicationModels,
        notes: notes,
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
