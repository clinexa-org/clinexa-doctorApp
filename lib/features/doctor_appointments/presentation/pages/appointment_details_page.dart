import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/time_helper.dart';
import '../../domain/entities/doctor_appointment_entity.dart';
import '../../../prescriptions/presentation/pages/create_prescription_page.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final DoctorAppointmentEntity appointment;

  const AppointmentDetailsPage({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Appointment Details',
          style: AppTextStyles.interSemiBoldw600F18.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientInfo(),
            SizedBox(height: 24.h),
            _buildAppointmentInfo(),
            SizedBox(height: 24.h),
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              SizedBox(height: 24.h),
              _buildNotes(),
            ],
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CreatePrescriptionPage(appointmentId: appointment.id),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Create Prescription',
                  style: AppTextStyles.interSemiBoldw600F16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
            child: ClipOval(
              child: appointment.patientAvatar != null &&
                      appointment.patientAvatar!.isNotEmpty
                  ? Image.network(
                      appointment.patientAvatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Iconsax.user,
                              size: 30.sp, color: AppColors.textPrimary),
                        );
                      },
                    )
                  : Center(
                      child: Icon(Iconsax.user,
                          size: 30.sp, color: AppColors.textPrimary),
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: AppTextStyles.interSemiBoldw600F18.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (appointment.patientPhone != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    appointment.patientPhone!,
                    style: AppTextStyles.interRegularw400F14.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Iconsax.calendar, 'Date', appointment.date),
          SizedBox(height: 16.h),
          _buildInfoRow(Iconsax.clock, 'Time',
              TimeHelper.formatStringTime(appointment.time)),
          SizedBox(height: 16.h),
          _buildInfoRow(Iconsax.message_text, 'Reason', appointment.reason),
          SizedBox(height: 16.h),
          _buildInfoRow(Iconsax.info_circle, 'Status', appointment.status),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.textMuted),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.interRegularw400F12.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.interMediumw500F14.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotes() {
    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: AppTextStyles.interSemiBoldw600F16.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            appointment.notes!,
            style: AppTextStyles.interRegularw400F14.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
