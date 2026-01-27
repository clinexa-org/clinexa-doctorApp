import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../domain/entities/prescription_entity.dart';
import '../cubit/prescriptions_cubit.dart';
import '../cubit/prescriptions_state.dart';

class PrescriptionDetailsPage extends StatelessWidget {
  final PrescriptionEntity prescription;

  const PrescriptionDetailsPage({
    super.key,
    required this.prescription,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrescriptionsCubit, PrescriptionsState>(
      listener: (context, state) {
        if (state.status == PrescriptionsStatus.failure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'An error occurred',
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            'Prescription Details',
            style: AppTextStyles.interSemiBoldw600F18.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // Patient Info Card
                _buildInfoCard(
                  icon: Iconsax.user,
                  title: 'Patient',
                  value: prescription.patientName,
                ),
                SizedBox(height: 16.h),

                // Date Card
                _buildInfoCard(
                  icon: Iconsax.calendar,
                  title: 'Date',
                  value: _formatDate(prescription.createdAt),
                ),
                SizedBox(height: 24.h),

                // Diagnosis Section
                Text(
                  'Diagnosis',
                  style: AppTextStyles.interSemiBoldw600F16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    prescription.diagnosis,
                    style: AppTextStyles.interRegularw400F14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Medications Section
                Text(
                  'Medications',
                  style: AppTextStyles.interSemiBoldw600F16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                ...prescription.medications.map(
                  (med) => _buildMedicationCard(med),
                ),

                // Notes Section
                if (prescription.notes != null &&
                    prescription.notes!.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  Text(
                    'Notes',
                    style: AppTextStyles.interSemiBoldw600F16.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.border.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      prescription.notes!,
                      style: AppTextStyles.interRegularw400F14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
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
          Column(
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
        ],
      ),
    );
  }

  Widget _buildMedicationCard(MedicationEntity medication) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Iconsax.health,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  medication.name,
                  style: AppTextStyles.interSemiBoldw600F14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.border.withOpacity(0.3)),
          SizedBox(height: 12.h),
          _buildMedicationDetail(
            icon: Iconsax.weight,
            label: 'Dosage',
            value: medication.dosage,
          ),
          SizedBox(height: 8.h),
          _buildMedicationDetail(
            icon: Iconsax.repeat,
            label: 'Frequency',
            value: medication.frequency,
          ),
          if (medication.duration.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _buildMedicationDetail(
              icon: Iconsax.calendar,
              label: 'Duration',
              value: medication.duration,
            ),
          ],
          if (medication.instructions != null) ...[
            SizedBox(height: 8.h),
            _buildMedicationDetail(
              icon: Iconsax.note,
              label: 'Instructions',
              value: medication.instructions!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicationDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.textMuted),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: AppTextStyles.interRegularw400F12.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.interMediumw500F12.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
