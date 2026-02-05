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
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthState(context.read<AuthCubit>().state);
    });
  }

  void _checkAuthState(AuthState state) {
    if (state.status == AuthStatus.authenticatedFromCache ||
        state.status == AuthStatus.authenticatedFromLogin) {
      context.go(RouteNames.dashboard);
    } else if (state.status == AuthStatus.unauthenticated) {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        _checkAuthState(state);
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
