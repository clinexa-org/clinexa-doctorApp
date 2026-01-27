import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/time_helper.dart';
import '../../../doctor_appointments/domain/entities/doctor_appointment_entity.dart';

class TodayAppointmentCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;

  const TodayAppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
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
          // Time Column
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              TimeHelper.formatStringTime(appointment.time),
              style: AppTextStyles.interSemiBoldw600F14.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 16.w),

          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: AppTextStyles.interMediumw500F14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  appointment.reason,
                  style: AppTextStyles.interRegularw400F12.copyWith(
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Status Badge
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color iconColor;
    IconData icon;

    switch (appointment.status) {
      case 'pending':
        bgColor = AppColors.warning.withOpacity(0.1);
        iconColor = AppColors.warning;
        icon = Iconsax.clock;
        break;
      case 'confirmed':
        bgColor = AppColors.info.withOpacity(0.1);
        iconColor = AppColors.info;
        icon = Iconsax.tick_circle;
        break;
      case 'completed':
        bgColor = AppColors.success.withOpacity(0.1);
        iconColor = AppColors.success;
        icon = Iconsax.tick_square;
        break;
      default:
        bgColor = AppColors.textMuted.withOpacity(0.1);
        iconColor = AppColors.textMuted;
        icon = Iconsax.info_circle;
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, color: iconColor, size: 18.sp),
    );
  }
}
