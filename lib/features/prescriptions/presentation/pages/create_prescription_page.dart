import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/time_helper.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../domain/entities/prescription_entity.dart';
import '../cubit/prescriptions_cubit.dart';
import '../cubit/prescriptions_state.dart';

import '../../../../features/doctor_appointments/presentation/cubit/doctor_appointments_cubit.dart';
import '../../../../features/doctor_appointments/presentation/cubit/doctor_appointments_state.dart';

class CreatePrescriptionPage extends StatefulWidget {
  final String? appointmentId;

  const CreatePrescriptionPage({super.key, this.appointmentId});

  @override
  State<CreatePrescriptionPage> createState() => _CreatePrescriptionPageState();
}

class _CreatePrescriptionPageState extends State<CreatePrescriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  final _appointmentIdController = TextEditingController();

  final List<_MedicationFormData> _medications = [_MedicationFormData()];

  @override
  void initState() {
    super.initState();
    // Fetch appointments to populate the dropdown
    context.read<DoctorAppointmentsCubit>().getAppointments();

    if (widget.appointmentId != null) {
      _appointmentIdController.text = widget.appointmentId!;
    }
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    _appointmentIdController.dispose();
    for (var med in _medications) {
      med.dispose();
    }
    super.dispose();
  }

  void _addMedication() {
    setState(() {
      _medications.add(_MedicationFormData());
    });
  }

  void _removeMedication(int index) {
    if (_medications.length > 1) {
      setState(() {
        _medications[index].dispose();
        _medications.removeAt(index);
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final medications = _medications
          .map((m) => MedicationEntity(
                name: m.nameController.text.trim(),
                dosage: m.dosageController.text.trim(),
                frequency: m.frequencyController.text.trim(),
                duration: m.durationController.text.trim(),
                instructions: m.instructionsController.text.trim().isEmpty
                    ? null
                    : m.instructionsController.text.trim(),
              ))
          .toList();

      final appointmentsState = context.read<DoctorAppointmentsCubit>().state;
      final selectedAppointment = appointmentsState.appointments.firstWhere(
        (a) => a.id == _appointmentIdController.text.trim(),
        orElse: () => throw Exception('Selected appointment not found'),
      );

      context.read<PrescriptionsCubit>().createPrescription(
            appointmentId: _appointmentIdController.text.trim(),
            patientId: selectedAppointment.patientId,
            patientName: selectedAppointment.patientName,
            diagnosis: _diagnosisController.text.trim(),
            medications: medications,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrescriptionsCubit, PrescriptionsState>(
      listener: (context, state) {
        if (state.status == PrescriptionsStatus.createSuccess) {
          ToastHelper.showSuccess(
              context: context, message: 'Prescription created');
          Navigator.pop(context);
        } else if (state.status == PrescriptionsStatus.actionFailure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'Failed to create prescription',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == PrescriptionsStatus.creating;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              'New Prescription',
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

                    // Appointment Selection
                    BlocBuilder<DoctorAppointmentsCubit,
                        DoctorAppointmentsState>(
                      builder: (context, appointmentsState) {
                        // Filter appointments: Only show COMPLETED appointments as per user request
                        final appointments = appointmentsState.appointments
                            .where((a) => a.status.toLowerCase() == 'completed')
                            .toList();

                        // If ID was passed in (e.g. from details page), ensure it's in the list
                        // If it's not in the list (e.g. status isn't completed), we might still want to show it or handle gracefully
                        // For now, if passed ID exists in full list but not filtered list, we might have an issue.
                        // Ideally, the "Create Prescription" button shouldn't appear for non-completed appointments then.

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide:
                                      BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide:
                                      BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide:
                                      BorderSide(color: AppColors.primary),
                                ),
                                filled: true,
                                fillColor: AppColors.surfaceElevated,
                              ),
                              hint: Text(
                                'Select Completed Appointment',
                                style: AppTextStyles.interRegularw400F14
                                    .copyWith(color: AppColors.textMuted),
                              ),
                              selectedItemBuilder: (context) {
                                return appointments.map(
                                  (item) {
                                    final time =
                                        TimeHelper.formatStringTime(item.time);
                                    return Container(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        '${item.patientName} - ${item.date} ($time)',
                                        style: AppTextStyles.interRegularw400F14
                                            .copyWith(
                                          color: AppColors.textPrimary,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    );
                                  },
                                ).toList();
                              },
                              items: appointments
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.id,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.patientName,
                                              style: AppTextStyles
                                                  .interSemiBoldw600F14
                                                  .copyWith(
                                                color: AppColors.textPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${item.date} • ${TimeHelper.formatStringTime(item.time)}',
                                              style: AppTextStyles
                                                  .interRegularw400F12
                                                  .copyWith(
                                                color: AppColors.textMuted,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null &&
                                    _appointmentIdController.text.isEmpty) {
                                  return 'Please select an appointment.';
                                }
                                return null;
                              },
                              onChanged:
                                  isLoading || widget.appointmentId != null
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _appointmentIdController.text =
                                                value ?? '';
                                          });
                                        },
                              onSaved: (value) {
                                _appointmentIdController.text = value ?? '';
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Iconsax.arrow_down_1,
                                  color: AppColors.textMuted,
                                ),
                                iconSize: 24,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: AppColors.surfaceElevated,
                                ),
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                height: 60.h, // Taller items for 2 lines
                              ),
                              value: _appointmentIdController.text.isNotEmpty &&
                                      appointments.any((a) =>
                                          a.id == _appointmentIdController.text)
                                  ? _appointmentIdController.text
                                  : null,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20.h),

                    // Diagnosis
                    CustomTextField(
                      controller: _diagnosisController,
                      labelText: 'Diagnosis',
                      hintText: 'Enter diagnosis',
                      prefixIcon: const Icon(Iconsax.health),
                      maxLines: 2,
                      enabled: !isLoading,
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    SizedBox(height: 24.h),

                    // Medications Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Medications',
                          style: AppTextStyles.interSemiBoldw600F16.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: isLoading ? null : _addMedication,
                          icon: Icon(Iconsax.add_circle,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Medications List
                    ..._medications.asMap().entries.map((entry) {
                      final index = entry.key;
                      final med = entry.value;
                      return _buildMedicationCard(index, med, isLoading);
                    }),

                    SizedBox(height: 20.h),

                    // Notes
                    CustomTextField(
                      controller: _notesController,
                      labelText: 'Notes (Optional)',
                      hintText: 'Additional notes',
                      prefixIcon: const Icon(Iconsax.note),
                      maxLines: 3,
                      enabled: !isLoading,
                    ),
                    SizedBox(height: 32.h),

                    // Submit Button
                    PrimaryButton(
                      text: 'Create Prescription',
                      onPressed: _handleSubmit,
                      isLoading: isLoading,
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

  Widget _buildMedicationCard(
      int index, _MedicationFormData med, bool isLoading) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medication ${index + 1}',
                style: AppTextStyles.interMediumw500F14.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              if (_medications.length > 1)
                IconButton(
                  onPressed: isLoading ? null : () => _removeMedication(index),
                  icon:
                      Icon(Iconsax.trash, color: AppColors.error, size: 20.sp),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: med.nameController,
            labelText: 'Name',
            hintText: 'Medication name',
            enabled: !isLoading,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: med.dosageController,
                  labelText: 'Dosage',
                  hintText: 'e.g. 500mg',
                  enabled: !isLoading,
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextField(
                  controller: med.frequencyController,
                  labelText: 'Frequency',
                  hintText: 'e.g. 3x daily',
                  enabled: !isLoading,
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: med.durationController,
                  labelText: 'Duration',
                  hintText: 'e.g. 7 days',
                  enabled: !isLoading,
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextField(
                  controller: med.instructionsController,
                  labelText: 'Instructions',
                  hintText: 'Optional',
                  enabled: !isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MedicationFormData {
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final frequencyController = TextEditingController();
  final durationController = TextEditingController();
  final instructionsController = TextEditingController();

  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
    instructionsController.dispose();
  }
}
