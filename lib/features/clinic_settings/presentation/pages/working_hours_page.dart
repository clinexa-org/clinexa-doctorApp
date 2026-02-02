import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../data/models/working_hours_model.dart';
import '../../domain/entities/working_hours_entity.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';
import '../widgets/day_schedule_tile.dart';
import '../widgets/settings_shimmer.dart';

class WorkingHoursPage extends StatefulWidget {
  const WorkingHoursPage({super.key});

  @override
  State<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends State<WorkingHoursPage> {
  static const List<String> _weekDays = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  late Map<String, _DaySchedule> _schedule;
  int _slotDuration = 30;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initDefaultSchedule();
    context.read<ClinicCubit>().getWorkingHours();
  }

  void _initDefaultSchedule() {
    _schedule = {
      for (final day in _weekDays)
        day: _DaySchedule(
          isEnabled: day != 'Friday',
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
        ),
    };
  }

  void _populateFromState(WorkingHoursScheduleEntity schedule) {
    if (_isInitialized) return;

    _slotDuration = schedule.slotDuration;

    for (final wh in schedule.schedule) {
      final dayName = _normalizeDayName(wh.dayOfWeek);
      if (_schedule.containsKey(dayName)) {
        _schedule[dayName] = _DaySchedule(
          isEnabled: wh.isOpen,
          startTime: _parseTime(wh.startTime),
          endTime: _parseTime(wh.endTime),
        );
      }
    }

    _isInitialized = true;
  }

  String _normalizeDayName(String day) {
    final normalized = day.toLowerCase();
    for (final weekDay in _weekDays) {
      if (weekDay.toLowerCase() == normalized ||
          weekDay.toLowerCase().startsWith(normalized)) {
        return weekDay;
      }
    }
    return day;
  }

  TimeOfDay? _parseTime(String? time) {
    if (time == null || time.isEmpty) return null;
    try {
      // Clean string
      time = time.trim();

      // Handle AM/PM if present (basic handling)
      // If backend sends "9:00 AM", split by space
      final parts = time.split(RegExp(r'[:\s]'));
      if (parts.length < 2) return null;

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      // Adjust for PM if detected
      if (time.toLowerCase().contains('pm') && hour < 12) {
        hour += 12;
      }
      // Adjust for AM if 12 AM
      if (time.toLowerCase().contains('am') && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      debugPrint('Error parsing time: $time - $e');
      return null;
    }
  }

  String _formatTimeForApi(TimeOfDay? time) {
    if (time == null) return '09:00';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _pickTime(String day, bool isStart) async {
    final schedule = _schedule[day]!;
    final initialTime = isStart
        ? (schedule.startTime ?? const TimeOfDay(hour: 9, minute: 0))
        : (schedule.endTime ?? const TimeOfDay(hour: 17, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surfaceElevated,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _schedule[day] = schedule.copyWith(startTime: picked);
        } else {
          _schedule[day] = schedule.copyWith(endTime: picked);
        }
      });
    }
  }

  void _handleSave() {
    final scheduleList = _weekDays.map((day) {
      final s = _schedule[day]!;
      return WorkingHoursModel(
        dayOfWeek: day.toLowerCase(),
        isOpen: s.isEnabled,
        startTime: s.isEnabled ? _formatTimeForApi(s.startTime) : null,
        endTime: s.isEnabled ? _formatTimeForApi(s.endTime) : null,
      );
    }).toList();

    context.read<ClinicCubit>().updateWorkingHours(
          schedule: scheduleList,
          slotDuration: _slotDuration,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicCubit, ClinicState>(
      listener: (context, state) {
        if (state.status == ClinicStatus.success &&
            state.workingHours != null) {
          setState(() {
            _populateFromState(state.workingHours!);
          });
        } else if (state.status == ClinicStatus.updateSuccess) {
          ToastHelper.showSuccess(
            context: context,
            message: 'Working hours updated successfully',
          );
          context.pop();
        } else if (state.status == ClinicStatus.failure ||
            state.status == ClinicStatus.updateFailure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'An error occurred',
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
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Working Hours',
              style: AppTextStyles.interSemiBoldw600F18.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
          ),
          body: isLoading
              ? const SettingsShimmer()
              : Column(
                  children: [
                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),

                            // Day Schedule Cards
                            ..._weekDays.map((day) {
                              final schedule = _schedule[day]!;
                              return DayScheduleTile(
                                dayName: day,
                                isEnabled: schedule.isEnabled,
                                startTime: schedule.startTime,
                                endTime: schedule.endTime,
                                onToggle: (value) {
                                  setState(() {
                                    _schedule[day] =
                                        schedule.copyWith(isEnabled: value);
                                  });
                                },
                                onStartTimeTap: () => _pickTime(day, true),
                                onEndTimeTap: () => _pickTime(day, false),
                              );
                            }),

                            SizedBox(height: 8.h),

                            // Slot Duration UI Removed (Moved to Clinic Settings)

                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Section: Note + Save Button
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        border: Border(
                          top: BorderSide(
                            color: AppColors.border.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Important Note
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Iconsax.info_circle,
                                  color: AppColors.info,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Important Note',
                                        style: AppTextStyles.interMediumw500F12
                                            .copyWith(
                                          color: AppColors.info,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Changing your working hours does not cancel existing appointments booked during these times.',
                                        style: AppTextStyles.interRegularw400F12
                                            .copyWith(
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Save Button
                          PrimaryButton(
                            text: 'Save Working Hours',
                            onPressed: _handleSave,
                            isLoading: isUpdating,
                            icon: Iconsax.save_2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _DaySchedule {
  final bool isEnabled;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  _DaySchedule({
    required this.isEnabled,
    this.startTime,
    this.endTime,
  });

  _DaySchedule copyWith({
    bool? isEnabled,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return _DaySchedule(
      isEnabled: isEnabled ?? this.isEnabled,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
