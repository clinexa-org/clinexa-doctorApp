import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/dashboard_stats_entity.dart';

import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../../doctor_appointments/domain/entities/doctor_appointment_entity.dart';
import '../../../doctor_appointments/domain/usecases/get_doctor_appointments_usecase.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;
  final GetDoctorAppointmentsUseCase getDoctorAppointmentsUseCase;

  DashboardCubit({
    required this.getDashboardStatsUseCase,
    required this.getDoctorAppointmentsUseCase,
  }) : super(const DashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: DashboardStatus.loading));

    // Get current month
    final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Fetch monthly stats
    final statsResult = await getDashboardStatsUseCase(month: currentMonth);

    // Check for stats failure
    if (statsResult.isLeft()) {
      final failure = statsResult.fold((l) => l, (r) => null);
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure?.message ?? 'Failed to load stats',
      ));
      return;
    }

    // Fetch today's appointments (for the list)
    final appointmentsResult = await getDoctorAppointmentsUseCase(date: today);

    // Extract data
    DashboardStatsEntity? stats;
    statsResult.fold((l) => null, (r) => stats = r);

    List<DoctorAppointmentEntity> appointments = state.todayAppointments;
    appointmentsResult.fold(
      (l) => null,
      (r) => appointments = r,
    );

    // We no longer override stats with local calculations,
    // because we want THE MONTHLY values from the server.

    emit(state.copyWith(
      status: DashboardStatus.success,
      stats: stats,
      todayAppointments: appointments,
    ));
  }

  Future<void> refreshDashboard() async {
    await loadDashboard();
  }
}
