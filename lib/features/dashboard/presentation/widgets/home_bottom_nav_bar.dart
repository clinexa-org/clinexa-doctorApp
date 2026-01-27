import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .09.sh,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surfaceElevated,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTextStyles.interSemiBoldw600F12,
        unselectedLabelStyle: AppTextStyles.interMediumw500F12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            activeIcon: Icon(Iconsax.home_15),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar),
            activeIcon: Icon(Iconsax.calendar_1),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.document_text),
            activeIcon: Icon(Iconsax.document_text_1),
            label: 'Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            activeIcon: Icon(Iconsax.user5),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
