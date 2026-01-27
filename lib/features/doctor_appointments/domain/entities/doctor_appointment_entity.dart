import 'package:equatable/equatable.dart';

class DoctorAppointmentEntity extends Equatable {
  final String id;
  final String date;
  final String time;
  final String reason;
  final String status;
  final String patientId;
  final String patientName;
  final String? patientPhone;
  final String? patientAvatar;
  final String? notes;

  const DoctorAppointmentEntity({
    required this.id,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
    required this.patientId,
    required this.patientName,
    this.patientPhone,
    this.patientAvatar,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        time,
        reason,
        status,
        patientId,
        patientName,
        patientPhone,
        patientAvatar,
        notes
      ];
}
