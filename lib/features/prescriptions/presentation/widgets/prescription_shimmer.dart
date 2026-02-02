import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/widgets/app_shimmer.dart';
import '../../../../app/theme/app_colors.dart';

class PrescriptionShimmer extends StatelessWidget {
  const PrescriptionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppShimmer.circular(size: 40.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.rounded(height: 14.h, width: 120.w),
                    SizedBox(height: 4.h),
                    AppShimmer.rounded(height: 12.h, width: 80.w),
                  ],
                ),
              ),
              AppShimmer.rounded(height: 24.h, width: 70.w, borderRadius: 12.r),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: AppColors.border.withOpacity(0.1)),
          SizedBox(height: 16.h),
          AppShimmer.rounded(height: 12.h, width: double.infinity),
          SizedBox(height: 8.h),
          AppShimmer.rounded(height: 12.h, width: 200.w),
        ],
      ),
    );
  }
}
