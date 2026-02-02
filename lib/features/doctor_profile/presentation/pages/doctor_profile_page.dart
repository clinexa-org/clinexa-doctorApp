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
import '../widgets/profile_shimmer.dart';

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
            backgroundColor: AppColors.background,
            title: Text(
              'My Profile',
              style: AppTextStyles.interSemiBoldw600F18.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            actions: [
              IconButton(
                onPressed: () =>
                    context.read<DoctorProfileCubit>().getDoctorProfile(),
                icon: const Icon(Iconsax.refresh),
              ),
            ],
          ),
          body: isLoading
              ? const ProfileShimmer()
              : profile == null
                  ? _buildEmptyState()
                  : SafeArea(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24.h),

                            // Profile Header
                            Center(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 50.r,
                                    backgroundColor: AppColors.surfaceElevated,
                                    backgroundImage: profile.avatar != null
                                        ? NetworkImage(profile.avatar!)
                                        : null,
                                    child: profile.avatar == null
                                        ? Icon(Iconsax.user,
                                            size: 40.sp,
                                            color: AppColors.textMuted)
                                        : null,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    profile.name,
                                    style: AppTextStyles.interSemiBoldw600F20
                                        .copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    profile.specialization,
                                    style: AppTextStyles.interMediumw500F14
                                        .copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    profile.email,
                                    style: AppTextStyles.interRegularw400F14
                                        .copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32.h),

                            // Profile Info Cards
                            if (profile.bio != null &&
                                profile.bio!.isNotEmpty) ...[
                              _buildInfoCard(
                                icon: Iconsax.document_text,
                                title: 'Bio',
                                value: profile.bio!,
                              ),
                              SizedBox(height: 16.h),
                            ],

                            if (profile.yearsOfExperience != null) ...[
                              _buildInfoCard(
                                icon: Iconsax.award,
                                title: 'Experience',
                                value: '${profile.yearsOfExperience} years',
                              ),
                              SizedBox(height: 16.h),
                            ],

                            if (profile.phone != null &&
                                profile.phone!.isNotEmpty) ...[
                              _buildInfoCard(
                                icon: Iconsax.call,
                                title: 'Phone',
                                value: profile.phone!,
                              ),
                              SizedBox(height: 16.h),
                            ],

                            SizedBox(height: 16.h),

                            // Settings Section
                            Text(
                              'Settings',
                              style:
                                  AppTextStyles.interSemiBoldw600F16.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 16.h),

                            _SettingsTile(
                              icon: Iconsax.edit,
                              title: 'Edit Profile',
                              subtitle: 'Update your personal info',
                              onTap: () => context.push(RouteNames.editProfile),
                            ),
                            _SettingsTile(
                              icon: Iconsax.hospital,
                              title: 'My Clinic',
                              subtitle: 'Manage clinic details',
                              onTap: () =>
                                  context.push(RouteNames.clinicSettings),
                            ),
                            _SettingsTile(
                              icon: Iconsax.clock,
                              title: 'Working Hours',
                              subtitle: 'Set your availability',
                              onTap: () =>
                                  context.push(RouteNames.workingHours),
                            ),
                            SizedBox(height: 8.h),
                            _SettingsTile(
                              icon: Iconsax.logout,
                              title: 'Logout',
                              subtitle: 'Sign out of your account',
                              onTap: () => _handleLogout(context),
                              isDestructive: true,
                            ),

                            SizedBox(height: 40.h),
                          ],
                        ),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.interRegularw400F12.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: AppTextStyles.interMediumw500F14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDestructive
              ? AppColors.error.withOpacity(0.3)
              : AppColors.border.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.error.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.error : AppColors.primary,
            size: 22.sp,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.interMediumw500F14.copyWith(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.interRegularw400F12.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        trailing: Icon(
          Iconsax.arrow_right_3,
          color: AppColors.textMuted,
          size: 20.sp,
        ),
      ),
    );
  }
}
