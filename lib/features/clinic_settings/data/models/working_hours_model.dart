import '../../domain/entities/working_hours_entity.dart';

class WorkingHoursModel extends WorkingHoursEntity {
  const WorkingHoursModel({
    required super.dayOfWeek,
    required super.isOpen,
    super.startTime,
    super.endTime,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      dayOfWeek: json['day_of_week'] ?? json['day'] ?? '',
      isOpen: json['is_open'] ?? json['enabled'] ?? false,
      startTime: json['start_time'] ?? json['from'],
      endTime: json['end_time'] ?? json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'is_open': isOpen,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
    };
  }
}

class WorkingHoursScheduleModel extends WorkingHoursScheduleEntity {
  const WorkingHoursScheduleModel({
    required List<WorkingHoursModel> schedule,
    required super.slotDuration,
  }) : super(schedule: schedule);

  factory WorkingHoursScheduleModel.fromJson(Map<String, dynamic> json) {
    final scheduleList = (json['working_hours'] ??
        json['schedule'] ??
        json['weekly'] ??
        []) as List;
    return WorkingHoursScheduleModel(
      schedule: scheduleList
          .map((e) => WorkingHoursModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      slotDuration: json['slot_duration'] ?? json['slotDurationMinutes'] ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'working_hours':
          (schedule as List<WorkingHoursModel>).map((e) => e.toJson()).toList(),
      'slot_duration': slotDuration,
    };
  }
}
