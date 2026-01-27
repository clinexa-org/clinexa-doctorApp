import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/doctor_appointment_model.dart';

abstract class DoctorAppointmentsRemoteDataSource {
  Future<ResponseModel<List<DoctorAppointmentModel>>> getDoctorAppointments({
    String? date,
  });
  Future<ResponseModel<DoctorAppointmentModel>> confirmAppointment(String id);
  Future<ResponseModel<DoctorAppointmentModel>> completeAppointment(String id);
  Future<ResponseModel<bool>> cancelAppointment(String id, {String? reason});
}

class DoctorAppointmentsRemoteDataSourceImpl
    implements DoctorAppointmentsRemoteDataSource {
  final ApiClient apiClient;

  DoctorAppointmentsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<List<DoctorAppointmentModel>>> getDoctorAppointments({
    String? date,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.appointmentsDoctor,
      queryParameters: date != null ? {'date': date} : null,
    );
    return ResponseModel.fromMap(
      response.data,
      (data) {
        if (data['appointments'] == null) return [];
        return (data['appointments'] as List)
            .map((json) => DoctorAppointmentModel.fromJson(json))
            .toList();
      },
    );
  }

  @override
  Future<ResponseModel<DoctorAppointmentModel>> confirmAppointment(
      String id) async {
    final response = await apiClient.patch(ApiEndpoints.appointmentConfirm(id));
    return ResponseModel.fromMap(
      response.data,
      (data) => DoctorAppointmentModel.fromJson(data['appointment'] ?? data),
    );
  }

  @override
  Future<ResponseModel<DoctorAppointmentModel>> completeAppointment(
      String id) async {
    final response =
        await apiClient.patch(ApiEndpoints.appointmentComplete(id));
    return ResponseModel.fromMap(
      response.data,
      (data) => DoctorAppointmentModel.fromJson(data['appointment'] ?? data),
    );
  }

  @override
  Future<ResponseModel<bool>> cancelAppointment(String id,
      {String? reason}) async {
    final response = await apiClient.patch(
      ApiEndpoints.appointmentCancel(id),
      data: reason != null ? {'reason': reason} : null,
    );
    return ResponseModel.fromMap(
      response.data,
      (data) => true,
    );
  }
}
