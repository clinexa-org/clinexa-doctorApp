import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Show toast only on active login
        if (state.status == AuthStatus.authenticatedFromLogin) {
          ToastHelper.showSuccess(
            context: context,
            message: 'Welcome back, ${state.userName ?? "Doctor"}!',
          );
          context.go(RouteNames.dashboard);
        }
        // Silent navigation on cached auth (no toast)
        else if (state.status == AuthStatus.authenticatedFromCache) {
          context.go(RouteNames.dashboard);
        } else if (state.status == AuthStatus.errorLogin) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'Login failed. Please try again.',
          );
        }
      },
      builder: (context, state) {
        _isLoading = state.status == AuthStatus.loadingLogin;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    const AuthLogo(),
                    SizedBox(height: 24.h),
                    Text(
                      'Clinexa Doctor',
                      style: AppTextStyles.interSemiBoldw600F24.copyWith(
                        color: AppColors.accentLight,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sign in to manage your clinic',
                      style: AppTextStyles.interRegularw400F14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Iconsax.sms),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      isPassword: true,
                      prefixIcon: const Icon(Iconsax.lock),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleLogin(),
                      validator: Validators.password,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                          ToastHelper.showInfo(
                            context: context,
                            message: 'Contact admin to reset your password',
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.interMediumw500F14.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    PrimaryButton(
                      text: 'Sign In',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),
                    SizedBox(height: 40.h),
                    // Footer info
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.info_circle,
                            size: 20.sp,
                            color: AppColors.info,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Use your clinic credentials provided by the admin',
                              style: AppTextStyles.interRegularw400F12.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
