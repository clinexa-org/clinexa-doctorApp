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
          json['today_appointments'] ?? json['todayAppointments'] ?? 0,
      pendingAppointments:
          json['pending_appointments'] ?? json['pendingAppointments'] ?? 0,
      completedAppointments:
          json['completed_appointments'] ?? json['completedAppointments'] ?? 0,
      totalPatients: json['total_patients'] ??
          json['totalPatients'] ??
          json['patients'] ??
          0,
    );
  }
}
