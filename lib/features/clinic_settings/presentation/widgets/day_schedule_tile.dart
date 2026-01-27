import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/time_helper.dart';

class DayScheduleTile extends StatelessWidget {
  final String dayName;
  final bool isEnabled;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final ValueChanged<bool> onToggle;
  final VoidCallback onStartTimeTap;
  final VoidCallback onEndTimeTap;

  const DayScheduleTile({
    super.key,
    required this.dayName,
    required this.isEnabled,
    required this.startTime,
    required this.endTime,
    required this.onToggle,
    required this.onStartTimeTap,
    required this.onEndTimeTap,
  });

  String _formatTime12Hour(TimeOfDay? time) {
    return TimeHelper.formatTimeOfDay(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Day Name + Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: AppTextStyles.interSemiBoldw600F16.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (isEnabled) ...[
                    SizedBox(height: 2.h),
                    Text(
                      'Regular hours',
                      style: AppTextStyles.interRegularw400F12.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
              Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeColor: AppColors.primary,
                activeTrackColor: AppColors.primary.withOpacity(0.5),
                inactiveThumbColor: AppColors.textMuted,
                inactiveTrackColor: AppColors.surface,
              ),
            ],
          ),

          // Time Pickers Row (only if enabled)
          if (isEnabled) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                // FROM Time
                Expanded(
                  child: _TimePickerBox(
                    label: 'FROM',
                    time: _formatTime12Hour(startTime),
                    onTap: onStartTimeTap,
                  ),
                ),
                // Arrow
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColors.textMuted,
                      size: 20.sp,
                    ),
                  ),
                ),
                // TO Time
                Expanded(
                  child: _TimePickerBox(
                    label: 'TO',
                    time: _formatTime12Hour(endTime),
                    onTap: onEndTimeTap,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TimePickerBox extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const _TimePickerBox({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.interRegularw400F10.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: AppTextStyles.interMediumw500F14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  Iconsax.clock,
                  size: 18.sp,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
