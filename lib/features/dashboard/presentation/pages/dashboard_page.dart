import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../doctor_appointments/domain/entities/doctor_appointment_entity.dart';
import '../../../doctor_appointments/presentation/pages/doctor_appointments_page.dart';
import '../../../doctor_profile/presentation/pages/doctor_profile_page.dart';
import '../../../prescriptions/presentation/pages/prescriptions_page.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/stat_card.dart';
import '../widgets/today_appointment_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _DashboardContent(),
    const DoctorAppointmentsPage(),
    const PrescriptionsPage(),
    const DoctorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent();

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state.status == DashboardStatus.failure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'Failed to load dashboard',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == DashboardStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              'Dashboard',
              style: AppTextStyles.interSemiBoldw600F20.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () =>
                    context.read<DashboardCubit>().refreshDashboard(),
                icon: const Icon(Iconsax.refresh, color: AppColors.textPrimary),
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () =>
                      context.read<DashboardCubit>().refreshDashboard(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // Stats Grid
                        if (state.stats != null) ...[
                          _buildStatsGrid(state),
                          SizedBox(height: 32.h),
                        ],

                        // Today's Appointments Section
                        Text(
                          "Today's Appointments",
                          style: AppTextStyles.interSemiBoldw600F18.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildTodayAppointments(state.todayAppointments),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildStatsGrid(DashboardState state) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 1.3,
      children: [
        StatCard(
          title: 'Today',
          value: state.stats!.todayAppointments.toString(),
          icon: Iconsax.calendar_1,
          color: AppColors.primary,
        ),
        StatCard(
          title: 'Pending',
          value: state.stats!.pendingAppointments.toString(),
          icon: Iconsax.clock,
          color: AppColors.warning,
        ),
        StatCard(
          title: 'Completed',
          value: state.stats!.completedAppointments.toString(),
          icon: Iconsax.tick_circle,
          color: AppColors.success,
        ),
        StatCard(
          title: 'Patients',
          value: state.stats!.totalPatients.toString(),
          icon: Iconsax.people,
          color: AppColors.info,
        ),
      ],
    );
  }

  Widget _buildTodayAppointments(List<DoctorAppointmentEntity> appointments) {
    if (appointments.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Iconsax.calendar_remove,
                  size: 48.sp, color: AppColors.textMuted),
              SizedBox(height: 12.h),
              Text(
                'No appointments today',
                style: AppTextStyles.interRegularw400F14.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return TodayAppointmentCard(appointment: appointments[index]);
      },
    );
  }
}
