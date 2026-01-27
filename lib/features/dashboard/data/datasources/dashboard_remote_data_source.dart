import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<ResponseModel<DashboardStatsModel>> getDashboardStats();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<DashboardStatsModel>> getDashboardStats() async {
    final response = await apiClient.get(ApiEndpoints.doctorStats);
    return ResponseModel.fromMap(
      response.data,
      (data) => DashboardStatsModel.fromJson(data['stats'] ?? data),
    );
  }
}
