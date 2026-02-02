import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_names.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../domain/entities/doctor_appointment_entity.dart';
import '../cubit/doctor_appointments_cubit.dart';
import '../cubit/doctor_appointments_state.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_card_shimmer.dart';
import '../../../../core/utils/debouncer.dart';

class DoctorAppointmentsPage extends StatefulWidget {
  const DoctorAppointmentsPage({super.key});

  @override
  State<DoctorAppointmentsPage> createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<DoctorAppointmentsCubit>().getAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorAppointmentsCubit, DoctorAppointmentsState>(
      listener: (context, state) {
        if (state.status == DoctorAppointmentsStatus.confirmSuccess) {
          ToastHelper.showSuccess(
              context: context, message: 'Appointment confirmed');
        } else if (state.status == DoctorAppointmentsStatus.completeSuccess) {
          ToastHelper.showSuccess(
              context: context, message: 'Appointment completed');
        } else if (state.status == DoctorAppointmentsStatus.cancelSuccess) {
          ToastHelper.showSuccess(
              context: context, message: 'Appointment cancelled');
        } else if (state.status == DoctorAppointmentsStatus.failure ||
            state.status == DoctorAppointmentsStatus.actionFailure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'An error occurred',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == DoctorAppointmentsStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildTabBar(state),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildSearchBar(),
                ),
                SizedBox(height: 24.h),
                // Date header is now handled inside the list grouping
                Expanded(
                  child: isLoading
                      ? ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.h),
                          itemCount: 5,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: const AppointmentCardShimmer(),
                          ),
                        )
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildAppointmentsList(
                              state.pendingAppointments,
                              showConfirm: true,
                              showCancel: true,
                              state: state,
                            ),
                            _buildAppointmentsList(
                              state.confirmedAppointments,
                              showComplete: true,
                              showCancel: true,
                              state: state,
                            ),
                            _buildAppointmentsList(
                              state.completedAppointments,
                              state: state,
                            ),
                            _buildAppointmentsList(
                              state.cancelledAppointments,
                              state: state,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.surfaceElevated,
            child:
                Icon(Iconsax.user, size: 20.sp, color: AppColors.textPrimary),
          ),
          SizedBox(width: 12.w),
          Text(
            'Appointments',
            style: AppTextStyles.interSemiBoldw600F20.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Iconsax.notification,
                size: 24.sp, color: AppColors.textPrimary),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Iconsax.setting,
                size: 24.sp, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(DoctorAppointmentsState state) {
    return SizedBox(
      height: 40.h,
      width: double.infinity,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        padding: EdgeInsets.zero,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(width: 2.0, color: AppColors.primary),
          insets: EdgeInsets.symmetric(horizontal: 0.w),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: AppTextStyles.interMediumw500F14,
        unselectedLabelStyle: AppTextStyles.interMediumw500F14,
        tabs: const [
          Tab(text: 'Pending'),
          Tab(text: 'Confirmed'),
          Tab(text: 'Completed'),
          Tab(text: 'Cancelled'),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.textPrimary),
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          _debouncer.run(() {
            context
                .read<DoctorAppointmentsCubit>()
                .getAppointments(search: value);
          });
          setState(() {}); // specific to update clear button visibility
        },
        onSubmitted: (value) {
          _debouncer.dispose(); // Cancel any pending debounce
          context
              .read<DoctorAppointmentsCubit>()
              .getAppointments(search: value);
        },
        decoration: InputDecoration(
          hintText: 'Search patient name...',
          hintStyle: const TextStyle(color: AppColors.textMuted),
          prefixIcon: Icon(Iconsax.search_normal,
              size: 20.sp, color: AppColors.textMuted),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty ||
                  context.read<DoctorAppointmentsCubit>().state.filterDate !=
                      null)
                IconButton(
                  icon: Icon(Icons.close,
                      size: 20.sp, color: AppColors.textMuted),
                  onPressed: () {
                    _searchController.clear();
                    context.read<DoctorAppointmentsCubit>().clearFilters();
                    setState(() {});
                  },
                ),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                            surface: AppColors.surfaceElevated,
                            onSurface: AppColors.textPrimary,
                          ),
                          dialogBackgroundColor: AppColors.surface,
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    // Format date as YYYY-MM-DD
                    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                    if (context.mounted) {
                      context
                          .read<DoctorAppointmentsCubit>()
                          .getAppointments(date: formattedDate);
                    }
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Icon(Iconsax.calendar_1,
                      size: 20.sp, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    String text;
    if (checkDate == today) {
      text = 'TODAY, ${DateFormat('MMM dd').format(date).toUpperCase()}';
    } else if (checkDate == tomorrow) {
      text = 'TOMORROW, ${DateFormat('MMM dd').format(date).toUpperCase()}';
    } else {
      text = DateFormat('EEE, MMM dd').format(date).toUpperCase();
    }

    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 24.h, bottom: 8.h),
      child: Text(
        text,
        style: AppTextStyles.interSemiBoldw600F12.copyWith(
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(
    List<DoctorAppointmentEntity> appointments, {
    bool showConfirm = false,
    bool showComplete = false,
    bool showCancel = false,
    required DoctorAppointmentsState state,
  }) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.calendar_remove,
                size: 64.sp, color: AppColors.textMuted),
            SizedBox(height: 16.h),
            Text(
              'No appointments',
              style: AppTextStyles.interRegularw400F16.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    // Processing grouping
    final items = <dynamic>[];
    String? lastDate;

    for (var appointment in appointments) {
      if (appointment.date != lastDate) {
        lastDate = appointment.date;
        items.add(lastDate);
      }
      items.add(appointment);
    }

    return RefreshIndicator(
      onRefresh: () =>
          context.read<DoctorAppointmentsCubit>().getAppointments(),
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 20.h),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item is String) {
            return _buildGroupHeader(item);
          } else if (item is DoctorAppointmentEntity) {
            final appointment = item;
            final isActionInProgress =
                state.actionAppointmentId == appointment.id &&
                    (state.status == DoctorAppointmentsStatus.confirming ||
                        state.status == DoctorAppointmentsStatus.completing ||
                        state.status == DoctorAppointmentsStatus.cancelling);

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: AppointmentCard(
                appointment: appointment,
                showConfirm: showConfirm,
                showComplete: showComplete,
                showCancel: showCancel,
                isLoading: isActionInProgress,
                onTap: () => context.push(
                  RouteNames.appointmentDetails,
                  extra: appointment,
                ),
                onConfirm: showConfirm
                    ? () => context
                        .read<DoctorAppointmentsCubit>()
                        .confirmAppointment(appointment.id)
                    : null,
                onComplete: showComplete
                    ? () => context
                        .read<DoctorAppointmentsCubit>()
                        .completeAppointment(appointment.id)
                    : null,
                onCancel:
                    showCancel ? () => _showCancelDialog(appointment.id) : null,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showCancelDialog(String id) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: Text(
          'Cancel Appointment',
          style: AppTextStyles.interSemiBoldw600F18.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: reasonController,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Reason (optional)',
            hintStyle: TextStyle(color: AppColors.textMuted),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textMuted),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<DoctorAppointmentsCubit>().cancelAppointment(
                    id,
                    reason: reasonController.text.trim().isEmpty
                        ? null
                        : reasonController.text.trim(),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Appointment'),
          ),
        ],
      ),
    );
  }
}
