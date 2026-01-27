import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/clinic_model.dart';
import '../models/working_hours_model.dart';

abstract class ClinicRemoteDataSource {
  Future<ResponseModel<ClinicModel>> getClinic();
  Future<ResponseModel<ClinicModel>> updateClinic({
    required String name,
    required String address,
    String? phone,
    String? city,
    String? locationLink,
    int? slotDuration,
  });
  Future<ResponseModel<WorkingHoursScheduleModel>> getWorkingHours();
  Future<ResponseModel<WorkingHoursScheduleModel>> updateWorkingHours({
    required List<WorkingHoursModel> schedule,
    required int slotDuration,
  });
}

class ClinicRemoteDataSourceImpl implements ClinicRemoteDataSource {
  final ApiClient apiClient;

  ClinicRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<ClinicModel>> getClinic() async {
    final response = await apiClient.get(ApiEndpoints.clinicMe);
    return ResponseModel.fromMap(
      response.data,
      (data) => ClinicModel.fromJson(data['clinic'] ?? data),
    );
  }

  @override
  Future<ResponseModel<ClinicModel>> updateClinic({
    required String name,
    required String address,
    String? phone,
    String? city,
    String? locationLink,
    int? slotDuration,
  }) async {
    final response = await apiClient.put(
      ApiEndpoints.clinics,
      data: {
        'name': name,
        'address': address,
        if (phone != null) 'phone': phone,
        if (city != null) 'city': city,
        if (locationLink != null) 'location_link': locationLink,
        if (slotDuration != null) 'slot_duration': slotDuration,
      },
    );
    return ResponseModel.fromMap(
      response.data,
      (data) => ClinicModel.fromJson(data['clinic'] ?? data),
    );
  }

  @override
  Future<ResponseModel<WorkingHoursScheduleModel>> getWorkingHours() async {
    final response = await apiClient.get(ApiEndpoints.workingHoursMe);
    return ResponseModel.fromMap(
      response.data,
      (data) => WorkingHoursScheduleModel.fromJson(data),
    );
  }

  @override
  Future<ResponseModel<WorkingHoursScheduleModel>> updateWorkingHours({
    required List<WorkingHoursModel> schedule,
    required int slotDuration,
  }) async {
    final response = await apiClient.put(
      ApiEndpoints.workingHoursMe,
      data: {
        'working_hours': schedule.map((e) => e.toJson()).toList(),
        'slot_duration': slotDuration,
      },
    );
    return ResponseModel.fromMap(
      response.data,
      (data) => WorkingHoursScheduleModel.fromJson(data),
    );
  }
}
