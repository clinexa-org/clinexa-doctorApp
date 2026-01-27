import 'package:equatable/equatable.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/entities/working_hours_entity.dart';

enum ClinicStatus {
  initial,
  loading,
  success,
  failure,
  updating,
  updateSuccess,
  updateFailure,
}

class ClinicState extends Equatable {
  final ClinicStatus status;
  final ClinicEntity? clinic;
  final WorkingHoursScheduleEntity? workingHours;
  final String? errorMessage;

  const ClinicState({
    this.status = ClinicStatus.initial,
    this.clinic,
    this.workingHours,
    this.errorMessage,
  });

  ClinicState copyWith({
    ClinicStatus? status,
    ClinicEntity? clinic,
    WorkingHoursScheduleEntity? workingHours,
    String? errorMessage,
  }) {
    return ClinicState(
      status: status ?? this.status,
      clinic: clinic ?? this.clinic,
      workingHours: workingHours ?? this.workingHours,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, clinic, workingHours, errorMessage];
}
