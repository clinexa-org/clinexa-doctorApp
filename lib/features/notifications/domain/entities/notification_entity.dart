import 'package:equatable/equatable.dart';

/// Notification entity representing a notification from the inbox.
class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? type;
  final String? referenceId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.type,
    this.referenceId,
  });

  @override
  List<Object?> get props =>
      [id, title, body, isRead, createdAt, type, referenceId];
}
