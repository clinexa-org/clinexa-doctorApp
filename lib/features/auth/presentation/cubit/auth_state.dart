import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  authenticatedFromCache,
  loadingLogin,
  authenticatedFromLogin,
  errorLogin,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;
  final String? userName;
  final String? userId;
  final String? role;
  final String? avatar;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.userName,
    this.userId,
    this.role,
    this.avatar,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? userName,
    String? userId,
    String? role,
    String? avatar,
    String? errorMessage,
    bool clearError = false,
    bool clearToken = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: clearToken ? null : (token ?? this.token),
      userName: clearToken ? null : (userName ?? this.userName),
      userId: clearToken ? null : (userId ?? this.userId),
      role: clearToken ? null : (role ?? this.role),
      avatar: clearToken ? null : (avatar ?? this.avatar),
      errorMessage: clearError ? null : errorMessage,
    );
  }

  bool get isLoggedIn =>
      status == AuthStatus.authenticatedFromCache ||
      status == AuthStatus.authenticatedFromLogin;

  @override
  List<Object?> get props =>
      [status, token, userName, userId, role, avatar, errorMessage];
}
