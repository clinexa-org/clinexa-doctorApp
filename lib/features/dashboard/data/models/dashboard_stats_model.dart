import '../../domain/entities/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.todayAppointments,
    required super.pendingAppointments,
    required super.completedAppointments,
    required super.totalPatients,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      todayAppointments:
          json['appointments'] ?? json['today_appointments'] ?? 0,
      pendingAppointments:
          json['pending'] ?? json['pending_appointments'] ?? 0,
      completedAppointments:
          json['completed'] ?? json['completed_appointments'] ?? 0,
      totalPatients: json['patients'] ??
          json['total_patients'] ??
          0,
    );
  }
}
