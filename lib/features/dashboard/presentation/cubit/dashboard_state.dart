import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../../doctor_appointments/domain/entities/doctor_appointment_entity.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardStatsEntity? stats;
  final List<DoctorAppointmentEntity> todayAppointments;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.stats,
    this.todayAppointments = const [],
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardStatsEntity? stats,
    List<DoctorAppointmentEntity>? todayAppointments,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      todayAppointments: todayAppointments ?? this.todayAppointments,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, todayAppointments, errorMessage];
}
