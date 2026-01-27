import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/toast_helper.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';

class ClinicSettingsPage extends StatefulWidget {
  const ClinicSettingsPage({super.key});

  @override
  State<ClinicSettingsPage> createState() => _ClinicSettingsPageState();
}

class _ClinicSettingsPageState extends State<ClinicSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController =
      TextEditingController(); // UI only for now, or map to city logic if needed
  final _phoneController = TextEditingController();
  final _locationLinkController = TextEditingController();
  final _slotController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ClinicCubit>().getClinic();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _locationLinkController.dispose();
    _slotController.dispose();
    super.dispose();
  }

  void _populateFields(ClinicState state) {
    if (state.clinic != null) {
      _nameController.text = state.clinic!.name;
      _nameController.text = state.clinic!.name;
      _addressController.text = state.clinic!.address;
      _cityController.text = state.clinic!.city ?? '';
      _zipController.text = '10001'; // Default or empty as it's not in API yet
      _phoneController.text = state.clinic!.phone ?? '';
      _locationLinkController.text = state.clinic!.locationLink ?? '';
      _slotController.text = state.clinic!.slotDuration.toString();
    }
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      context.read<ClinicCubit>().updateClinic(
            name: _nameController.text.trim(),
            address: _addressController.text.trim(),
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            city: _cityController.text.trim().isEmpty
                ? null
                : _cityController.text.trim(),
            locationLink: _locationLinkController.text.trim().isEmpty
                ? null
                : _locationLinkController.text.trim(),
            slotDuration: int.tryParse(_slotController.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicCubit, ClinicState>(
      listener: (context, state) {
        if (state.status == ClinicStatus.success && state.clinic != null) {
          _populateFields(state);
        } else if (state.status == ClinicStatus.updateSuccess) {
          ToastHelper.showSuccess(context: context, message: 'Clinic updated');
          context.pop();
        } else if (state.status == ClinicStatus.failure ||
            state.status == ClinicStatus.updateFailure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'Error',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ClinicStatus.loading;
        final isUpdating = state.status == ClinicStatus.updating;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              'Clinic Settings',
              style: AppTextStyles.interSemiBoldw600F18.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),

                          // Section Header
                          Padding(
                            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                            child: Text(
                              'GENERAL INFO',
                              style: AppTextStyles.interMediumw500F12.copyWith(
                                color: AppColors.textMuted,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),

                          // Main Card
                          Container(
                            padding: EdgeInsets.all(20.w),
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
                                _buildLabeledField(
                                  label: 'Clinic Name',
                                  controller: _nameController,
                                  hint: 'Downtown Health Hub',
                                  enabled: !isUpdating,
                                ),
                                SizedBox(height: 16.h),
                                _buildLabeledField(
                                  label: 'Phone',
                                  controller: _phoneController,
                                  hint: '+1 (555) 019-2834',
                                  enabled: !isUpdating,
                                  keyboardType: TextInputType.phone,
                                  isRequired: false,
                                ),
                                SizedBox(height: 16.h),
                                _buildLabeledField(
                                  label: 'Address',
                                  controller: _addressController,
                                  hint: '123 Medical Plaza, Suite 400',
                                  enabled: !isUpdating,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildLabeledField(
                                        label: 'City',
                                        controller: _cityController,
                                        hint: 'New York',
                                        enabled: !isUpdating,
                                        isRequired: false,
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: _buildLabeledField(
                                        label: 'Zip',
                                        controller: _zipController,
                                        hint: '10001',
                                        enabled:
                                            !isUpdating, // Or disabled if purely visual
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                _buildLabeledField(
                                  label: 'Location Link',
                                  controller: _locationLinkController,
                                  hint: 'https://maps.google.com/?q=...',
                                  enabled: !isUpdating,
                                  maxLines: 1,
                                  isRequired: false,
                                  suffix: Icon(
                                    Iconsax.link,
                                    size: 18.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // Configuration Header
                          Padding(
                            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                            child: Text(
                              'CONFIGURATION',
                              style: AppTextStyles.interMediumw500F12.copyWith(
                                color: AppColors.textMuted,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),

                          // Configuration Card
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.border.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Timezone (Visual only)
                                _buildConfigTile(
                                  icon: Iconsax.global,
                                  title: 'Timezone',
                                  trailing: Text(
                                    'Africa/Cairo (EET)',
                                    style: AppTextStyles.interMediumw500F14
                                        .copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColors.border.withOpacity(0.1),
                                ),

                                // Slot Duration
                                _buildConfigTile(
                                  icon: Iconsax.clock,
                                  title: 'Slot Duration',
                                  trailing: SizedBox(
                                    width: 80.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _slotController,
                                            enabled: !isUpdating,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.end,
                                            style: AppTextStyles
                                                .interMediumw500F14
                                                .copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          ' mins',
                                          style: AppTextStyles
                                              .interRegularw400F14
                                              .copyWith(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColors.border.withOpacity(0.1),
                                ),

                                // Edit Hours Link
                                _buildConfigTile(
                                  icon: Iconsax.calendar_edit,
                                  title: 'Edit Hours & Availability',
                                  onTap: () =>
                                      context.push(RouteNames.workingHours),
                                  trailing: Icon(
                                    Iconsax.arrow_right_3,
                                    size: 18.sp,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // Save Button
                          PrimaryButton(
                            text: 'Save Changes',
                            onPressed: _handleUpdate,
                            isLoading: isUpdating,
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffix,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.interMediumw500F14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTextStyles.interRegularw400F14.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.interRegularw400F14.copyWith(
              color: AppColors.textMuted,
            ),
            filled: true,
            fillColor: AppColors.surface, // Darker inner fill
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            suffixIcon:
                suffix, // Use suffixIcon instead of suffix for better alignment
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.border.withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
          ),
          validator:
              isRequired ? (v) => v?.isEmpty ?? true ? 'Required' : null : null,
        ),
      ],
    );
  }

  Widget _buildConfigTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.interMediumw500F14.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
