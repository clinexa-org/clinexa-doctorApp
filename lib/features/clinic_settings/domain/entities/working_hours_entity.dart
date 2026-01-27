import 'package:equatable/equatable.dart';

class WorkingHoursEntity extends Equatable {
  final String dayOfWeek;
  final bool isOpen;
  final String? startTime;
  final String? endTime;

  const WorkingHoursEntity({
    required this.dayOfWeek,
    required this.isOpen,
    this.startTime,
    this.endTime,
  });

  @override
  List<Object?> get props => [dayOfWeek, isOpen, startTime, endTime];
}

class WorkingHoursScheduleEntity extends Equatable {
  final List<WorkingHoursEntity> schedule;
  final int slotDuration;

  const WorkingHoursScheduleEntity({
    required this.schedule,
    required this.slotDuration,
  });

  @override
  List<Object?> get props => [schedule, slotDuration];
}
