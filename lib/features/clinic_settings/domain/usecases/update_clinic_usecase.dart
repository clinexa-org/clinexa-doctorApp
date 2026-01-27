import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_entity.dart';
import '../repositories/clinic_repository.dart';

class UpdateClinicUseCase {
  final ClinicRepository repository;
  const UpdateClinicUseCase(this.repository);

  Future<Either<Failure, ClinicEntity>> call({
    required String name,
    required String address,
    String? phone,
    String? city,
    String? locationLink,
    int? slotDuration,
  }) =>
      repository.updateClinic(
        name: name,
        address: address,
        phone: phone,
        city: city,
        locationLink: locationLink,
        slotDuration: slotDuration,
      );
}
