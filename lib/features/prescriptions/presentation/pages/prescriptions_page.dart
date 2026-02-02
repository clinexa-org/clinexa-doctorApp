import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../domain/entities/prescription_entity.dart';
import '../cubit/prescriptions_cubit.dart';
import '../cubit/prescriptions_state.dart';
import '../widgets/prescription_shimmer.dart';
import 'create_prescription_page.dart';
import 'prescription_details_page.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PrescriptionsCubit>().getPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrescriptionsCubit, PrescriptionsState>(
      listener: (context, state) {
        if (state.status == PrescriptionsStatus.failure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'An error occurred',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == PrescriptionsStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              'Prescriptions',
              style: AppTextStyles.interSemiBoldw600F18.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<PrescriptionsCubit>(),
                  child: const CreatePrescriptionPage(),
                ),
              ),
            ),
            child: const Icon(Iconsax.add, color: Colors.white),
          ),
          body: isLoading
              ? ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: 5,
                  itemBuilder: (context, index) => const PrescriptionShimmer(),
                )
              : state.prescriptions.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<PrescriptionsCubit>().getPrescriptions(),
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: state.prescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = state.prescriptions[index];
                          return _buildPrescriptionCard(prescription);
                        },
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
          Icon(Iconsax.document_text, size: 64.sp, color: AppColors.textMuted),
          SizedBox(height: 16.h),
          Text(
            'No prescriptions yet',
            style: AppTextStyles.interRegularw400F16.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap + to create a new prescription',
            style: AppTextStyles.interRegularw400F14.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(PrescriptionEntity prescription) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PrescriptionDetailsPage(prescription: prescription),
          ),
        ),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      prescription.patientName,
                      style: AppTextStyles.interSemiBoldw600F16.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    dateFormat.format(prescription.createdAt),
                    style: AppTextStyles.interRegularw400F12.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Diagnosis
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Iconsax.health, size: 16.sp, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Diagnosis: ${prescription.diagnosis}',
                      style: AppTextStyles.interRegularw400F14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Medications count
              Row(
                children: [
                  Icon(Iconsax.hospital,
                      size: 16.sp, color: AppColors.textMuted),
                  SizedBox(width: 8.w),
                  Text(
                    '${prescription.medications.length} medication(s)',
                    style: AppTextStyles.interRegularw400F14.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),

              // Notes if present
              if (prescription.notes != null &&
                  prescription.notes!.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.note, size: 16.sp, color: AppColors.textMuted),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        prescription.notes!,
                        style: AppTextStyles.interRegularw400F12.copyWith(
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
