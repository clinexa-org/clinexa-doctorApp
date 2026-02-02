import '../models/notification_model.dart';
import '../../../../core/network/api_client.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final ApiClient _apiClient;

  NotificationsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get<dynamic>('/notifications/me');
    final data = response.data;

    if (data == null) return [];

    // Handle both array and paginated responses
    List<dynamic> notificationsList;
    if (data is List) {
      notificationsList = data;
    } else if (data is Map<String, dynamic>) {
      if (data.containsKey('data') &&
          data['data'] is Map<String, dynamic> &&
          data['data']['notifications'] is List) {
        notificationsList = data['data']['notifications'] as List<dynamic>;
      } else if (data['notifications'] is List) {
        notificationsList = data['notifications'] as List<dynamic>;
      } else if (data['data'] is List) {
        notificationsList = data['data'] as List<dynamic>;
      } else {
        return [];
      }
    } else {
      return [];
    }

    return notificationsList
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await _apiClient.patch('/notifications/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await _apiClient.patch('/notifications/read-all');
  }
}
