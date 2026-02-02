import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/widgets/app_shimmer.dart';
import '../../../../app/theme/app_colors.dart';

class AppointmentCardShimmer extends StatelessWidget {
  const AppointmentCardShimmer({super.key});

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
              // Avatar Shimmer
              AppShimmer.circular(size: 48.r),
              SizedBox(width: 12.w),
              // Name and Reason Shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.rounded(height: 16.h, width: 120.w),
                    SizedBox(height: 8.h),
                    AppShimmer.rounded(height: 12.h, width: 180.w),
                  ],
                ),
              ),
              // Time Shimmer
              AppShimmer.rounded(height: 16.h, width: 50.w),
            ],
          ),
          SizedBox(height: 20.h),
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          SizedBox(height: 16.h),
          // Status and Action Shimmer
          Row(
            children: [
              AppShimmer.rounded(height: 32.h, width: 80.w, borderRadius: 20.r),
              const Spacer(),
              AppShimmer.rounded(height: 16.h, width: 60.w),
            ],
          ),
        ],
      ),
    );
  }
}
