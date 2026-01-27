import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_logo.dart';

/// Splash screen that waits for auth initialization before navigating.
/// This prevents the login screen "flash" when user has cached auth.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Wait for auth check to complete, then navigate
        if (state.status == AuthStatus.authenticatedFromCache ||
            state.status == AuthStatus.authenticatedFromLogin) {
          // User is authenticated, go to dashboard
          context.go(RouteNames.dashboard);
        } else if (state.status == AuthStatus.unauthenticated) {
          // User needs to login
          context.go(RouteNames.login);
        }
        // If status is 'initial', we're still checking - keep showing splash
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Logo centered in the screen
            const Center(
              child: AuthLogo(
                size: 250,
              ),
            ),
            // Text at the bottom with padding
            Positioned(
              left: 0,
              right: 0,
              bottom: 60.h,
              child: Center(
                child: Text(
                  'Clinexa Doctor',
                  style: AppTextStyles.interSemiBoldw600F24.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
