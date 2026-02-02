import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/widgets/app_shimmer.dart';
import '../../../../app/theme/app_colors.dart';

class TodayAppointmentCardShimmer extends StatelessWidget {
  const TodayAppointmentCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          AppShimmer.circular(size: 40.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer.rounded(height: 14.h, width: 100.w),
                SizedBox(height: 4.h),
                AppShimmer.rounded(height: 10.h, width: 140.w),
              ],
            ),
          ),
          AppShimmer.rounded(height: 14.h, width: 40.w),
        ],
      ),
    );
  }
}
