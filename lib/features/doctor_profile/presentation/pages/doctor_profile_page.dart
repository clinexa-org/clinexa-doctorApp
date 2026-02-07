import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/doctor_profile_cubit.dart';
import '../cubit/doctor_profile_state.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_shimmer.dart';
import '../widgets/settings_tile.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorProfileCubit>().getDoctorProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
      listener: (context, state) {
        if (state.status == DoctorProfileStatus.failure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'An error occurred',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == DoctorProfileStatus.loading;
        final profile = state.profile;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.background,
            scrolledUnderElevation: 0,
            title: Text(
              'My Profile',
              style: AppTextStyles.interSemiBoldw600F18.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            actions: [],
          ),
          body: isLoading
              ? const ProfileShimmer()
              : profile == null
                  ? _buildEmptyState()
                  : SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          // Fixed Profile Card
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: ProfileCard(
                              name: profile.name,
                              specialization: profile.specialization,
                              email: profile.email,
                              imageUrl: profile.avatar,
                              onTap: () => context.push(RouteNames.editProfile),
                            ),
                          ),
                          SizedBox(height: 32.h),

                          // Scrollable Settings Section
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Info Cards (Bio, Experience, Phone)
                                  if (profile.bio != null &&
                                      profile.bio!.isNotEmpty) ...[
                                    SettingsTile(
                                      icon: Iconsax.document_text,
                                      title: 'Bio',
                                      subtitle: profile.bio!,
                                    ),
                                    SizedBox(height: 16.h),
                                  ],
                                  if (profile.yearsOfExperience != null) ...[
                                    SettingsTile(
                                      icon: Iconsax.award,
                                      title: 'Experience',
                                      subtitle:
                                          '${profile.yearsOfExperience} years',
                                    ),
                                    SizedBox(height: 16.h),
                                  ],
                                  if (profile.phone != null &&
                                      profile.phone!.isNotEmpty) ...[
                                    SettingsTile(
                                      icon: Iconsax.call,
                                      title: 'Phone',
                                      subtitle: profile.phone!,
                                    ),
                                    SizedBox(height: 16.h),
                                  ],

                                  SizedBox(height: 16.h),

                                  // CLINIC INFO Section
                                  Text(
                                    'CLINIC INFO',
                                    style: AppTextStyles.interSemiBoldw600F12
                                        .copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),

                                  SettingsTile(
                                    icon: Iconsax.hospital,
                                    title: 'My Clinic',
                                    subtitle: 'Manage clinic details',
                                    onTap: () =>
                                        context.push(RouteNames.clinicSettings),
                                  ),
                                  SizedBox(height: 12.h),
                                  SettingsTile(
                                    icon: Iconsax.clock,
                                    title: 'Working Hours',
                                    subtitle: 'Set your availability',
                                    onTap: () =>
                                        context.push(RouteNames.workingHours),
                                  ),

                                  SizedBox(height: 32.h),

                                  // ACCOUNT Section
                                  Text(
                                    'ACCOUNT',
                                    style: AppTextStyles.interSemiBoldw600F12
                                        .copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),

                                  SettingsTile(
                                    icon: Iconsax.logout,
                                    title: 'Logout',
                                    subtitle: 'Sign out of your account',
                                    onTap: () => _handleLogout(context),
                                    titleColor: AppColors.error,
                                    iconColor: AppColors.error,
                                  ),

                                  SizedBox(height: 40.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.user, size: 64.sp, color: AppColors.textMuted),
          SizedBox(height: 16.h),
          Text(
            'Failed to load profile',
            style: AppTextStyles.interMediumw500F16.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: Text(
          'Logout',
          style: AppTextStyles.interSemiBoldw600F18.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.interRegularw400F14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.interMediumw500F14.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
