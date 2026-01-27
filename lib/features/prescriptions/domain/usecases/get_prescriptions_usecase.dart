import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription_entity.dart';
import '../repositories/prescriptions_repository.dart';

class GetPrescriptionsUseCase {
  final PrescriptionsRepository repository;
  const GetPrescriptionsUseCase(this.repository);

  Future<Either<Failure, List<PrescriptionEntity>>> call() =>
      repository.getPrescriptions();
}
