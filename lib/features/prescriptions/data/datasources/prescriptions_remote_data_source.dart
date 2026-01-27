import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/prescription_model.dart';

abstract class PrescriptionsRemoteDataSource {
  Future<ResponseModel<List<PrescriptionModel>>> getPrescriptions();
  Future<ResponseModel<PrescriptionModel>> getPrescriptionById(String id);
  Future<ResponseModel<PrescriptionModel?>> getPrescriptionByAppointment(
      String appointmentId);
  Future<ResponseModel<PrescriptionModel>> createPrescription({
    required String appointmentId,
    required String patientId,
    required String diagnosis,
    required List<MedicationModel> medications,
    String? notes,
  });
  Future<ResponseModel<PrescriptionModel>> updatePrescription({
    required String id,
    required String diagnosis,
    required List<MedicationModel> medications,
    String? notes,
  });
}

class PrescriptionsRemoteDataSourceImpl
    implements PrescriptionsRemoteDataSource {
  final ApiClient apiClient;

  PrescriptionsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<List<PrescriptionModel>>> getPrescriptions() async {
    final response = await apiClient.get(ApiEndpoints.prescriptions);
    return ResponseModel.fromMap(
      response.data,
      (data) {
        final list = (data['prescriptions'] ?? []) as List;
        return list.map((json) => PrescriptionModel.fromJson(json)).toList();
      },
    );
  }

  @override
  Future<ResponseModel<PrescriptionModel>> getPrescriptionById(
      String id) async {
    final response = await apiClient.get(ApiEndpoints.prescriptionById(id));
    return ResponseModel.fromMap(
      response.data,
      (data) => PrescriptionModel.fromJson(data['prescription'] ?? data),
    );
  }

  @override
  Future<ResponseModel<PrescriptionModel?>> getPrescriptionByAppointment(
      String appointmentId) async {
    final response = await apiClient.get(
      ApiEndpoints.prescriptionsByAppointment(appointmentId),
    );
    return ResponseModel.fromMap(
      response.data,
      (data) {
        final prescription = data['prescription'];
        if (prescription == null) return null;
        return PrescriptionModel.fromJson(prescription);
      },
    );
  }

  @override
  Future<ResponseModel<PrescriptionModel>> createPrescription({
    required String appointmentId,
    required String patientId,
    required String diagnosis,
    required List<MedicationModel> medications,
    String? notes,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.prescriptions,
      data: {
        'appointment_id': appointmentId,
        'patient_id': patientId,
        'diagnosis': diagnosis,
        'items': medications.map((m) => m.toJson()).toList(),
        if (notes != null) 'notes': notes,
      },
    );
    return ResponseModel.fromMap(
      response.data,
      (data) => PrescriptionModel.fromJson(data['prescription'] ?? data),
    );
  }

  @override
  Future<ResponseModel<PrescriptionModel>> updatePrescription({
    required String id,
    required String diagnosis,
    required List<MedicationModel> medications,
    String? notes,
  }) async {
    final response = await apiClient.put(
      ApiEndpoints.prescriptionById(id),
      data: {
        'diagnosis': diagnosis,
        'items': medications.map((m) => m.toJson()).toList(),
        if (notes != null) 'notes': notes,
      },
    );
    return ResponseModel.fromMap(
      response.data,
      (data) => PrescriptionModel.fromJson(data['prescription'] ?? data),
    );
  }
}
