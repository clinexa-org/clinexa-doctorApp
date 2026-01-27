import '../../domain/entities/doctor_profile_entity.dart';

class DoctorProfileModel extends DoctorProfileEntity {
  const DoctorProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    required super.specialization,
    super.bio,
    super.yearsOfExperience,
    super.phone,
    required super.isActive,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle nested user data from doctor object
    final userData = json['user_id'];
    String name = 'Unknown';
    String email = '';
    String? avatar;

    if (userData is Map<String, dynamic>) {
      name = userData['name'] ?? 'Unknown';
      email = userData['email'] ?? '';
      avatar = userData['avatar'];
    } else if (json['name'] != null) {
      name = json['name'];
      email = json['email'] ?? '';
      avatar = json['avatar'];
    }

    return DoctorProfileModel(
      id: json['_id'] ?? '',
      name: name,
      email: email,
      avatar: avatar,
      specialization: json['specialization'] ?? 'General',
      bio: json['bio'],
      yearsOfExperience: json['years_of_experience'],
      phone: json['phone'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialization': specialization,
      if (bio != null) 'bio': bio,
      if (yearsOfExperience != null) 'years_of_experience': yearsOfExperience,
      if (phone != null) 'phone': phone,
    };
  }
}
