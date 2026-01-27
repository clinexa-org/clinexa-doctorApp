import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_data_model.dart';

abstract class AuthRemoteDataSource {
  Future<ResponseModel<AuthDataModel>> login({
    required String email,
    required String password,
  });

  Future<ResponseModel<AuthDataModel>> getCurrentUser();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<AuthDataModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
        'role':
            'doctor', // Assuming doctor role might be auto-detected or enforced
      },
    );
    return ResponseModel.fromMap(
      response.data,
      (data) => AuthDataModel.fromMap(data),
    );
  }

  @override
  Future<ResponseModel<AuthDataModel>> getCurrentUser() async {
    final response = await apiClient.get(ApiEndpoints.authMe);
    return ResponseModel.fromMap(
      response.data,
      (data) => AuthDataModel.fromMap(data),
    );
  }
}
