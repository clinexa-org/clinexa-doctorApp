import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../doctor_appointments/domain/entities/doctor_appointment_entity.dart';
import '../../../doctor_appointments/presentation/cubit/doctor_appointments_cubit.dart';
import '../../../doctor_appointments/presentation/cubit/doctor_appointments_state.dart';

class PatientProfileArgs {
  final String patientId;
  final String patientName;
  final String? patientPhone;
  final String? patientAvatar;

  const PatientProfileArgs({
    required this.patientId,
    required this.patientName,
    this.patientPhone,
    this.patientAvatar,
  });
}

class PatientProfilePage extends StatelessWidget {
  final PatientProfileArgs args;

  const PatientProfilePage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Patient Profile',
          style: AppTextStyles.interSemiBoldw600F18.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24.h),
            // Patient Info Card (Fixed)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildPatientCard(),
            ),
            SizedBox(height: 32.h),

            // Appointment History Section (Scrollable)
            Expanded(
              child:
                  BlocBuilder<DoctorAppointmentsCubit, DoctorAppointmentsState>(
                builder: (context, state) {
                  final patientAppointments = state.appointments
                      .where((a) => a.patientId == args.patientId)
                      .toList();

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'APPOINTMENT HISTORY',
                          style: AppTextStyles.interSemiBoldw600F12.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (patientAppointments.isEmpty)
                          _buildEmptyHistory()
                        else
                          ...patientAppointments
                              .map((a) => _buildHistoryItem(a)),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40.r,
            backgroundColor: AppColors.surface,
            backgroundImage:
                args.patientAvatar != null && args.patientAvatar!.isNotEmpty
                    ? NetworkImage(args.patientAvatar!)
                    : null,
            child: args.patientAvatar == null || args.patientAvatar!.isEmpty
                ? Icon(Iconsax.user, size: 32.sp, color: AppColors.textMuted)
                : null,
          ),
          SizedBox(height: 16.h),
          // Name
          Text(
            args.patientName,
            style: AppTextStyles.interSemiBoldw600F20.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          // Patient ID
          Text(
            'ID: ${args.patientId.substring(0, 8)}...',
            style: AppTextStyles.interRegularw400F12.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 16.h),
          // Phone & Call Button
          if (args.patientPhone != null && args.patientPhone!.isNotEmpty)
            Builder(
              builder: (context) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.call,
                      size: 16.sp, color: AppColors.textSecondary),
                  SizedBox(width: 8.w),
                  Text(
                    args.patientPhone!,
                    style: AppTextStyles.interMediumw500F14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  GestureDetector(
                    onTap: () => _makePhoneCall(context, args.patientPhone!),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.call5,
                              size: 14.sp, color: AppColors.success),
                          SizedBox(width: 4.w),
                          Text(
                            'Call',
                            style: AppTextStyles.interMediumw500F12.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
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
              'No appointment history',
              style: AppTextStyles.interRegularw400F14.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(DoctorAppointmentEntity appointment) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Date Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                Text(
                  appointment.date.split('-').last, // Day
                  style: AppTextStyles.interSemiBoldw600F16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _getMonthAbbr(appointment.date),
                  style: AppTextStyles.interRegularw400F10.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.reason,
                  style: AppTextStyles.interMediumw500F14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  appointment.time,
                  style: AppTextStyles.interRegularw400F12.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Status Badge
          _buildStatusBadge(appointment.status),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = const Color(0xFF2C221B);
        textColor = const Color(0xFFF59E0B);
        break;
      case 'confirmed':
        bgColor = const Color(0xFF132822);
        textColor = const Color(0xFF10B981);
        break;
      case 'completed':
        bgColor = const Color(0xFF1A2638);
        textColor = const Color(0xFF3B82F6);
        break;
      case 'cancelled':
        bgColor = const Color(0xFF2C1B1B);
        textColor = const Color(0xFFEF4444);
        break;
      default:
        bgColor = AppColors.surface;
        textColor = AppColors.textMuted;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        status,
        style: AppTextStyles.interMediumw500F10.copyWith(color: textColor),
      ),
    );
  }

  String _getMonthAbbr(String date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final parts = date.split('-');
    if (parts.length >= 2) {
      final monthIndex = int.tryParse(parts[1]);
      if (monthIndex != null && monthIndex >= 1 && monthIndex <= 12) {
        return months[monthIndex - 1];
      }
    }
    return '';
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      final launched = await launchUrl(
        launchUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open phone app for $phoneNumber'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone app not available'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
