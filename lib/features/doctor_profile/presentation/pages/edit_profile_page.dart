import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/toast_helper.dart';
import '../cubit/doctor_profile_cubit.dart';
import '../cubit/doctor_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _bioController = TextEditingController();
  final _yearsController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _populateFieldsFromState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _bioController.dispose();
    _yearsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFieldsFromState() {
    final state = context.read<DoctorProfileCubit>().state;
    if (state.profile != null && !_isInitialized) {
      _nameController.text = state.profile!.name;
      _specializationController.text = state.profile!.specialization;
      _bioController.text = state.profile!.bio ?? '';
      _yearsController.text =
          state.profile!.yearsOfExperience?.toString() ?? '';
      _phoneController.text = state.profile!.phone ?? '';
      _isInitialized = true;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      context.read<DoctorProfileCubit>().updateDoctorProfile(
            specialization: _specializationController.text.trim(),
            name: _nameController.text.trim().isEmpty
                ? null
                : _nameController.text.trim(),
            bio: _bioController.text.trim().isEmpty
                ? null
                : _bioController.text.trim(),
            yearsOfExperience: int.tryParse(_yearsController.text.trim()),
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            avatarFile: _selectedImage,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
      listener: (context, state) {
        if (state.status == DoctorProfileStatus.updateSuccess) {
          ToastHelper.showSuccess(
            context: context,
            message: 'Profile updated successfully',
          );
          context.pop(); // Go back to profile page
        } else if (state.status == DoctorProfileStatus.updateFailure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'An error occurred',
          );
        }
      },
      builder: (context, state) {
        final isUpdating = state.status == DoctorProfileStatus.updating;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              'Edit Profile',
              style: AppTextStyles.interSemiBoldw600F18.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Avatar Section
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: isUpdating ? null : _pickImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50.r,
                                  backgroundColor: AppColors.surfaceElevated,
                                  backgroundImage: _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                      : (state.profile?.avatar != null
                                          ? NetworkImage(state.profile!.avatar!)
                                          : null) as ImageProvider?,
                                  child: (_selectedImage == null &&
                                          state.profile?.avatar == null)
                                      ? Icon(Iconsax.user,
                                          size: 40.sp,
                                          color: AppColors.textMuted)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.background,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Iconsax.camera,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Tap to change photo',
                            style: AppTextStyles.interRegularw400F12.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Name
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your name',
                      prefixIcon: const Icon(Iconsax.user),
                      enabled: !isUpdating,
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    SizedBox(height: 20.h),

                    // Specialization
                    CustomTextField(
                      controller: _specializationController,
                      labelText: 'Specialization',
                      hintText: 'e.g. Cardiologist',
                      prefixIcon: const Icon(Iconsax.briefcase),
                      enabled: !isUpdating,
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    SizedBox(height: 20.h),

                    // Bio
                    CustomTextField(
                      controller: _bioController,
                      labelText: 'Bio',
                      hintText: 'Tell us about yourself',
                      prefixIcon: const Icon(Iconsax.document_text),
                      maxLines: 3,
                      enabled: !isUpdating,
                    ),
                    SizedBox(height: 20.h),

                    // Years of Experience
                    CustomTextField(
                      controller: _yearsController,
                      labelText: 'Years of Experience',
                      hintText: 'e.g. 10',
                      prefixIcon: const Icon(Iconsax.calendar),
                      keyboardType: TextInputType.number,
                      enabled: !isUpdating,
                    ),
                    SizedBox(height: 20.h),

                    // Phone
                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Phone',
                      hintText: '+20 xxx xxx xxxx',
                      prefixIcon: const Icon(Iconsax.call),
                      keyboardType: TextInputType.phone,
                      enabled: !isUpdating,
                    ),
                    SizedBox(height: 32.h),

                    // Update Button
                    PrimaryButton(
                      text: 'Update Profile',
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
}
