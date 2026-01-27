import 'package:equatable/equatable.dart';

class MedicationEntity extends Equatable {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String? instructions;

  const MedicationEntity({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
  });

  MedicationEntity copyWith({
    String? name,
    String? dosage,
    String? frequency,
    String? duration,
    String? instructions,
  }) {
    return MedicationEntity(
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
    );
  }


  @override
  List<Object?> get props => [name, dosage, frequency, duration, instructions];
}

class PrescriptionEntity extends Equatable {
  final String id;
  final String appointmentId;
  final String patientId;
  final String patientName;
  final String diagnosis;
  final List<MedicationEntity> medications;
  final String? notes;
  final DateTime createdAt;

  const PrescriptionEntity({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.diagnosis,
    required this.medications,
    this.notes,
    required this.createdAt,
  });

  PrescriptionEntity copyWith({
    String? id,
    String? appointmentId,
    String? patientId,
    String? patientName,
    String? diagnosis,
    List<MedicationEntity>? medications,
    String? notes,
    DateTime? createdAt,
  }) {
    return PrescriptionEntity(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      diagnosis: diagnosis ?? this.diagnosis,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }


  @override
  List<Object?> get props => [
        id,
        appointmentId,
        patientId,
        patientName,
        diagnosis,
        medications,
        notes,
        createdAt
      ];
}
