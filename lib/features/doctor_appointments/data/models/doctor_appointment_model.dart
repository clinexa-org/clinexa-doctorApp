import '../../domain/entities/doctor_appointment_entity.dart';

class DoctorAppointmentModel extends DoctorAppointmentEntity {
  const DoctorAppointmentModel({
    required super.id,
    required super.date,
    required super.time,
    required super.reason,
    required super.status,
    required super.patientId,
    required super.patientName,
    super.patientPhone,
    super.patientAvatar,
    super.notes,
  });

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    final startTimeString = json['start_time'];
    final startTime = startTimeString != null
        ? DateTime.parse(startTimeString).toLocal()
        : DateTime.now();

    // Handle nested patient data
    // Handle nested patient data
    final patientData = json['patient_id'] ?? json['patient'];
    String patientId = '';
    String patientName = 'Unknown Patient';
    String? patientPhone;
    String? patientAvatar;

    if (json['patient_name'] != null) {
      patientName = json['patient_name'];
    }

    if (patientData is Map<String, dynamic>) {
      patientId = patientData['_id'] ?? '';

      // Try to get user data from user_id or direct fields
      final userData = patientData['user_id'];
      if (userData is Map<String, dynamic>) {
        patientName = userData['name'] ?? patientName;
        patientAvatar = userData['avatar'];
      } else if (patientData['name'] != null) {
        // Fallback if name is directly on patient document
        patientName = patientData['name'];
        patientAvatar = patientData['avatar'];
      }

      patientPhone = patientData['phone'];
    } else if (patientData is String) {
      patientId = patientData;
    }

    return DoctorAppointmentModel(
      id: json['_id'] ?? '',
      date:
          "${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')}",
      time:
          "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}",
      reason: json['reason'] ?? '',
      status: json['status'] ?? 'pending',
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      patientAvatar: patientAvatar,
      notes: json['notes'],
    );
  }
}
