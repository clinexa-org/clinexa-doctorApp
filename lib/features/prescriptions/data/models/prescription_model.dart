import '../../domain/entities/prescription_entity.dart';

class MedicationModel extends MedicationEntity {
  const MedicationModel({
    required super.name,
    required super.dosage,
    required super.frequency,
    required super.duration,
    super.instructions,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? '',
      instructions: json['instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    String finalDosage = dosage;
    if (frequency.isNotEmpty) {
      finalDosage = '$dosage ($frequency)';
    }

    return {
      'name': name,
      'dosage': finalDosage,
      'duration': duration,
      if (instructions != null) 'instructions': instructions,
    };
  }

  @override
  MedicationModel copyWith({
    String? name,
    String? dosage,
    String? frequency,
    String? duration,
    String? instructions,
  }) {
    return MedicationModel(
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
    );
  }
}

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.appointmentId,
    required super.patientId,
    required super.patientName,
    required super.diagnosis,
    required List<MedicationModel> super.medications,
    super.notes,
    required super.createdAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    // Handle nested patient data
    String patientId = '';
    String patientName = 'Unknown';

    final patientData = json['patient_id'];
    if (patientData is Map<String, dynamic>) {
      patientId = patientData['_id'] ?? '';
      final userData = patientData['user_id'];
      if (userData is Map<String, dynamic>) {
        patientName = userData['name'] ?? 'Unknown';
      }
    } else if (patientData is String) {
      patientId = patientData;
    }

    // Handle appointment ID
    String appointmentId = '';
    final appointmentData = json['appointment_id'];
    if (appointmentData is Map<String, dynamic>) {
      appointmentId = appointmentData['_id'] ?? '';
    } else if (appointmentData is String) {
      appointmentId = appointmentData;
    }

    // Parse medications
    final medicationsList =
        (json['items'] ?? json['medications'] ?? []) as List;
    final medications = medicationsList
        .map((m) => MedicationModel.fromJson(m as Map<String, dynamic>))
        .toList();

    return PrescriptionModel(
      id: json['_id'] ?? '',
      appointmentId: appointmentId,
      patientId: patientId,
      patientName: patientName,
      diagnosis: json['diagnosis'] ?? '',
      medications: medications,
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'appointment_id': appointmentId,
      'diagnosis': diagnosis,
      'items': (medications as List<MedicationModel>)
          .map((m) => m.toJson())
          .toList(),
      if (notes != null) 'notes': notes,
    };
  }

  @override
  PrescriptionModel copyWith({
    String? id,
    String? appointmentId,
    String? patientId,
    String? patientName,
    String? diagnosis,
    List<MedicationEntity>? medications,
    String? notes,
    DateTime? createdAt,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      diagnosis: diagnosis ?? this.diagnosis,
      medications: (medications ?? this.medications).cast<MedicationModel>(),
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
