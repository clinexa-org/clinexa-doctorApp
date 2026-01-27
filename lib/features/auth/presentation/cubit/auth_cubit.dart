import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository; // Added for cache check
  final LoginUseCase loginUseCase;

  AuthCubit({
    required this.repository,
    required this.loginUseCase,
  }) : super(const AuthState());

  static AuthCubit get(BuildContext context, {bool listen = false}) =>
      BlocProvider.of<AuthCubit>(context, listen: listen);

  Future<void> init() async {
    // 1. Check local cache first
    final result = await repository.getCachedSession();

    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      },
      (cachedSession) async {
        if (cachedSession != null) {
          // 2. If we have a token, verify it with the server
          // We can temporarily show a loading status, but 'initial' is fine if usually unchecked.
          // However, if we want to block the screen, we might need a status.
          // Since the user is on a Splash or Login screen, we will just proceed.

          // Optional: Emit state from cache first for offline support?
          // The user wants "if token is valid then take to dashboard". implying online validation.

          final verifyResult = await repository.verifySession();

          verifyResult.fold((fail) async {
            // Verification failed.
            // Check if it was a fatal error (401) which clears the cache,
            // or a transient error (Network) which leaves the cache intact.
            final currentSessionResult = await repository.getCachedSession();

            currentSessionResult.fold(
                (f) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
                (session) {
              if (session != null) {
                // Cache still exists, so error was likely network-related.
                // Allow user to proceed with cached data.
                emit(state.copyWith(
                  status: AuthStatus.authenticatedFromCache,
                  token: session.token,
                  userName: session.user?.name,
                  userId: session.user?.id,
                  role: session.user?.role,
                  avatar: session.user?.avatar,
                ));
              } else {
                // Cache was cleared (likely 401), so require login.
                emit(state.copyWith(status: AuthStatus.unauthenticated));
              }
            });
          }, (verifiedSession) {
            emit(state.copyWith(
              status: AuthStatus.authenticatedFromCache,
              token: verifiedSession.token.isNotEmpty
                  ? verifiedSession.token
                  : cachedSession.token,
              userName: verifiedSession.user?.name ?? cachedSession.user?.name,
              userId: verifiedSession.user?.id ?? cachedSession.user?.id,
              role: verifiedSession.user?.role ?? cachedSession.user?.role,
              avatar:
                  verifiedSession.user?.avatar ?? cachedSession.user?.avatar,
            ));
          });
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(
      status: AuthStatus.loadingLogin,
      clearError: true,
    ));

    final either = await loginUseCase(email: email, password: password);

    either.fold(
      (failure) {
        emit(state.copyWith(
          status: AuthStatus.errorLogin,
          errorMessage: failure.message,
        ));
      },
      (session) {
        emit(state.copyWith(
          status: AuthStatus.authenticatedFromLogin,
          token: session.token,
          userName: session.user?.name,
          userId: session.user?.id,
          role: session.user?.role,
          avatar: session.user?.avatar,
          clearError: true,
        ));
      },
    );
  }

  Future<void> logout() async {
    await repository.logout();
    emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearToken: true,
        clearError: true));
  }
}
