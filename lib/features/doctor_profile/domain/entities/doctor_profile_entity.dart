import 'package:equatable/equatable.dart';

class DoctorProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String specialization;
  final String? bio;
  final int? yearsOfExperience;
  final String? phone;
  final bool isActive;

  const DoctorProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.specialization,
    this.bio,
    this.yearsOfExperience,
    this.phone,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatar,
        specialization,
        bio,
        yearsOfExperience,
        phone,
        isActive,
      ];
}
