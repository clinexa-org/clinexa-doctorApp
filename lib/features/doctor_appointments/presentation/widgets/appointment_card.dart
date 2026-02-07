import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/time_helper.dart';
import '../../../patient_profile/presentation/pages/patient_profile_page.dart';
import '../../domain/entities/doctor_appointment_entity.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;
  final bool showConfirm;
  final bool showComplete;
  final bool showCancel;
  final bool isLoading;
  final VoidCallback? onConfirm;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;
  final VoidCallback? onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.showConfirm = false,
    this.showComplete = false,
    this.showCancel = false,
    this.isLoading = false,
    this.onConfirm,
    this.onComplete,
    this.onCancel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar - tappable
              GestureDetector(
                onTap: () {
                  context.push(
                    RouteNames.patientProfile,
                    extra: PatientProfileArgs(
                      patientId: appointment.patientId,
                      patientName: appointment.patientName,
                      patientPhone: appointment.patientPhone,
                      patientAvatar: appointment.patientAvatar,
                    ),
                  );
                },
                child: Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                  ),
                  child: ClipOval(
                    child: appointment.patientAvatar != null &&
                            appointment.patientAvatar!.isNotEmpty
                        ? Image.network(
                            appointment.patientAvatar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(Iconsax.user,
                                    size: 24.sp, color: AppColors.textPrimary),
                              );
                            },
                          )
                        : Center(
                            child: Icon(Iconsax.user,
                                size: 24.sp, color: AppColors.textPrimary),
                          ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Name and Reason
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: AppTextStyles.interSemiBoldw600F16.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      appointment.reason,
                      style: AppTextStyles.interRegularw400F12.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Time
              Text(
                TimeHelper.formatStringTime(appointment.time),
                style: AppTextStyles.interSemiBoldw600F14.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          SizedBox(height: 16.h),
          // Status and Action
          Row(
            children: [
              _buildStatusBadge(),
              const Spacer(),
              _buildActionData(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionData() {
    if (isLoading) {
      return SizedBox(
        height: 16.r,
        width: 16.r,
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          color: showConfirm
              ? AppColors.success
              : showComplete
                  ? AppColors.primary
                  : AppColors.textSecondary,
        ),
      );
    }

    List<Widget> actions = [];

    // Cancel Button (Secondary Action)
    if (showCancel && onCancel != null) {
      actions.add(
        GestureDetector(
          onTap: onCancel,
          child: Row(
            children: [
              Text(
                'Cancel',
                style: AppTextStyles.interMediumw500F12.copyWith(
                  color: AppColors.error,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Iconsax.close_circle, size: 14.sp, color: AppColors.error),
            ],
          ),
        ),
      );
    }

    // Primary Action
    Widget? primaryAction;
    if (showConfirm) {
      primaryAction = GestureDetector(
        onTap: onConfirm,
        child: Row(
          children: [
            Text(
              'Confirm',
              style: AppTextStyles.interMediumw500F12.copyWith(
                color: AppColors.success,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Iconsax.arrow_right_1, size: 14.sp, color: AppColors.success),
          ],
        ),
      );
    } else if (showComplete) {
      primaryAction = GestureDetector(
        onTap: onComplete,
        child: Row(
          children: [
            Text(
              'Complete',
              style: AppTextStyles.interMediumw500F12.copyWith(
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Iconsax.arrow_right_1, size: 14.sp, color: AppColors.primary),
          ],
        ),
      );
    } else {
      // Default "Details >"
      primaryAction = GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Text(
              'Details',
              style: AppTextStyles.interMediumw500F12.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Iconsax.arrow_right_3,
                size: 14.sp, color: AppColors.textSecondary),
          ],
        ),
      );
    }

    if (actions.isNotEmpty) {
      actions.add(SizedBox(width: 16.w)); // Spacing between Cancel and Primary
    }
    actions.add(primaryAction);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions,
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String text;
    IconData? icon;

    switch (appointment.status.toLowerCase()) {
      case 'pending':
        bgColor = const Color(0xFF2C221B); // Dark Orange/Brown
        textColor = const Color(0xFFF59E0B); // Orange
        text = 'Pending';
        break;
      case 'confirmed':
        bgColor = const Color(0xFF132822); // Dark Green
        textColor = const Color(0xFF10B981); // Green
        text = 'Confirmed';
        icon = Icons.circle; // Dot
        break;
      case 'completed':
        bgColor = const Color(0xFF1A2638); // Dark Blue
        textColor = const Color(0xFF3B82F6); // Blue
        text = 'Completed';
        icon = Icons.check;
        break;
      case 'cancelled':
        bgColor = const Color(0xFF2C1B1B); // Dark Red
        textColor = const Color(0xFFEF4444); // Red
        text = 'Cancelled';
        icon = Icons.close;
        break;
      default:
        bgColor = AppColors.surface;
        textColor = AppColors.textMuted;
        text = appointment.status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && text == 'Confirmed') ...[
            Icon(Icons.circle, size: 8.sp, color: textColor),
            SizedBox(width: 6.w),
          ],
          if (icon != null && text != 'Confirmed') ...[
            Icon(icon, size: 14.sp, color: textColor),
            SizedBox(width: 6.w),
          ],
          Text(
            text,
            style: AppTextStyles.interMediumw500F12.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
