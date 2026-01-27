import 'package:equatable/equatable.dart';
import '../../domain/entities/prescription_entity.dart';

enum PrescriptionsStatus {
  initial,
  loading,
  success,
  failure,
  creating,
  createSuccess,
  updating,
  updateSuccess,
  actionFailure,
}

class PrescriptionsState extends Equatable {
  final PrescriptionsStatus status;
  final List<PrescriptionEntity> prescriptions;
  final PrescriptionEntity? selectedPrescription;
  final String? errorMessage;

  const PrescriptionsState({
    this.status = PrescriptionsStatus.initial,
    this.prescriptions = const [],
    this.selectedPrescription,
    this.errorMessage,
  });

  PrescriptionsState copyWith({
    PrescriptionsStatus? status,
    List<PrescriptionEntity>? prescriptions,
    PrescriptionEntity? selectedPrescription,
    String? errorMessage,
  }) {
    return PrescriptionsState(
      status: status ?? this.status,
      prescriptions: prescriptions ?? this.prescriptions,
      selectedPrescription: selectedPrescription ?? this.selectedPrescription,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, prescriptions, selectedPrescription, errorMessage];
}
