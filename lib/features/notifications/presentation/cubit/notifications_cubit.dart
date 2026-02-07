import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/notification_model.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;

  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllNotificationsReadUseCase,
  }) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    debugPrint('NotificationsCubit: loadNotifications() called');
    emit(state.copyWith(status: NotificationsStatus.loading));

    final result = await getNotificationsUseCase();

    result.fold(
      (failure) {
        debugPrint('NotificationsCubit: Failed to load - ${failure.message}');
        emit(state.copyWith(
          status: NotificationsStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;
        debugPrint(
            'NotificationsCubit: Loaded ${notifications.length} notifications');
        debugPrint('NotificationsCubit: Unread count = $unreadCount');
        emit(state.copyWith(
          status: NotificationsStatus.success,
          notifications: notifications,
        ));
      },
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await markNotificationReadUseCase(id);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: NotificationsStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (_) {
        // Update local state to mark as read
        final updatedList = state.notifications.map((n) {
          if (n.id == id) {
            return NotificationModel(
              id: n.id,
              title: n.title,
              body: n.body,
              isRead: true,
              createdAt: n.createdAt,
              type: n.type,
              referenceId: n.referenceId,
            );
          }
          return n;
        }).toList();

        emit(state.copyWith(notifications: updatedList));
      },
    );
  }

  Future<void> markAllAsRead() async {
    final result = await markAllNotificationsReadUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: NotificationsStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (_) {
        final updatedList = state.notifications.map((n) {
          return NotificationModel(
            id: n.id,
            title: n.title,
            body: n.body,
            isRead: true,
            createdAt: n.createdAt,
            type: n.type,
            referenceId: n.referenceId,
          );
        }).toList();

        emit(state.copyWith(notifications: updatedList));
      },
    );
  }

  Future<void> refresh() async {
    await loadNotifications();
  }
}
