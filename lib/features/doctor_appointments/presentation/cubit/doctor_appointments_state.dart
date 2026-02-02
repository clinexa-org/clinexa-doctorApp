import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_appointment_entity.dart';

enum DoctorAppointmentsStatus {
  initial,
  loading,
  success,
  failure,
  confirming,
  confirmSuccess,
  completing,
  completeSuccess,
  cancelling,
  cancelSuccess,
  actionFailure,
}

class DoctorAppointmentsState extends Equatable {
  final DoctorAppointmentsStatus status;
  final List<DoctorAppointmentEntity> appointments;
  final String? errorMessage;
  final String? actionAppointmentId;
  final String? filterDate;
  final String? filterSearch;

  const DoctorAppointmentsState({
    this.status = DoctorAppointmentsStatus.initial,
    this.appointments = const [],
    this.errorMessage,
    this.actionAppointmentId,
    this.filterDate,
    this.filterSearch,
  });

  DoctorAppointmentsState copyWith({
    DoctorAppointmentsStatus? status,
    List<DoctorAppointmentEntity>? appointments,
    String? errorMessage,
    String? actionAppointmentId,
    String? filterDate,
    String? filterSearch,
    bool clearDate = false,
    bool clearSearch = false,
  }) {
    return DoctorAppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage,
      actionAppointmentId: actionAppointmentId,
      filterDate: clearDate ? null : (filterDate ?? this.filterDate),
      filterSearch: clearSearch ? null : (filterSearch ?? this.filterSearch),
    );
  }

  List<DoctorAppointmentEntity> get pendingAppointments =>
      appointments.where((a) => a.status == 'pending').toList();

  List<DoctorAppointmentEntity> get confirmedAppointments =>
      appointments.where((a) => a.status == 'confirmed').toList();

  List<DoctorAppointmentEntity> get completedAppointments =>
      appointments.where((a) => a.status == 'completed').toList();

  List<DoctorAppointmentEntity> get cancelledAppointments =>
      appointments.where((a) => a.status == 'cancelled').toList();

  @override
  List<Object?> get props => [
        status,
        appointments,
        errorMessage,
        actionAppointmentId,
        filterDate,
        filterSearch,
      ];
}
