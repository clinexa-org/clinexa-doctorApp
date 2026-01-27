import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/doctor_profile_model.dart';

abstract class DoctorProfileRemoteDataSource {
  Future<ResponseModel<DoctorProfileModel>> getDoctorProfile();
  Future<ResponseModel<DoctorProfileModel>> updateDoctorProfile({
    required String specialization,
    String? name,
    String? bio,
    int? yearsOfExperience,
    String? phone,
    File? avatarFile,
  });
}

class DoctorProfileRemoteDataSourceImpl
    implements DoctorProfileRemoteDataSource {
  final ApiClient apiClient;

  DoctorProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<DoctorProfileModel>> getDoctorProfile() async {
    final response = await apiClient.get(ApiEndpoints.doctorMe);
    return ResponseModel.fromMap(
      response.data,
      (data) => DoctorProfileModel.fromJson(data['doctor'] ?? data),
    );
  }

  @override
  Future<ResponseModel<DoctorProfileModel>> updateDoctorProfile({
    required String specialization,
    String? name,
    String? bio,
    int? yearsOfExperience,
    String? phone,
    File? avatarFile,
  }) async {
    // Use FormData if we have an image, otherwise use regular JSON
    if (avatarFile != null) {
      final formData = FormData.fromMap({
        'specialization': specialization,
        if (name != null) 'name': name,
        if (bio != null) 'bio': bio,
        if (yearsOfExperience != null) 'years_of_experience': yearsOfExperience,
        if (phone != null) 'phone': phone,
        'avatar': await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split('/').last,
        ),
      });

      final response = await apiClient.put(
        ApiEndpoints.doctors,
        data: formData,
      );
      return ResponseModel.fromMap(
        response.data,
        (data) => DoctorProfileModel.fromJson(data['doctor'] ?? data),
      );
    } else {
      final response = await apiClient.put(
        ApiEndpoints.doctors,
        data: {
          'specialization': specialization,
          if (name != null) 'name': name,
          if (bio != null) 'bio': bio,
          if (yearsOfExperience != null)
            'years_of_experience': yearsOfExperience,
          if (phone != null) 'phone': phone,
        },
      );
      return ResponseModel.fromMap(
        response.data,
        (data) => DoctorProfileModel.fromJson(data['doctor'] ?? data),
      );
    }
  }
}
