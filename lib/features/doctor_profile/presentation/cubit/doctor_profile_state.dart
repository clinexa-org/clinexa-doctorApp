import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_profile_entity.dart';

enum DoctorProfileStatus {
  initial,
  loading,
  success,
  failure,
  updating,
  updateSuccess,
  updateFailure,
}

class DoctorProfileState extends Equatable {
  final DoctorProfileStatus status;
  final DoctorProfileEntity? profile;
  final String? errorMessage;

  const DoctorProfileState({
    this.status = DoctorProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  DoctorProfileState copyWith({
    DoctorProfileStatus? status,
    DoctorProfileEntity? profile,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: clearError ? null : errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
