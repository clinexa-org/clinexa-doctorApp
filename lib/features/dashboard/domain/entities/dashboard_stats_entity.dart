import 'package:equatable/equatable.dart';

class DashboardStatsEntity extends Equatable {
  final int todayAppointments;
  final int pendingAppointments;
  final int completedAppointments;
  final int totalPatients;

  const DashboardStatsEntity({
    required this.todayAppointments,
    required this.pendingAppointments,
    required this.completedAppointments,
    required this.totalPatients,
  });

  @override
  List<Object?> get props => [
        todayAppointments,
        pendingAppointments,
        completedAppointments,
        totalPatients
      ];
}
