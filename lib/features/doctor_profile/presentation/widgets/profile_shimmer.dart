import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/widgets/app_shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Avatar Shimmer
          AppShimmer.circular(size: 100.r),
          SizedBox(height: 16.h),
          AppShimmer.rounded(height: 20.h, width: 150.w),
          SizedBox(height: 32.h),
          // Fields
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: AppShimmer.rounded(height: 60.h, borderRadius: 12.r),
            ),
          ),
        ],
      ),
    );
  }
}
