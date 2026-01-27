import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pretty_bloc_observer/pretty_bloc_observer.dart';
import 'package:toastification/toastification.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_colors.dart';
import 'core/config/env.dart';
import 'core/di/injection.dart';
import 'core/storage/cache_helper.dart';
import 'core/localization/app_localizations.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/clinic_settings/presentation/cubit/clinic_cubit.dart';
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'features/doctor_appointments/presentation/cubit/doctor_appointments_cubit.dart';
import 'features/doctor_profile/presentation/cubit/doctor_profile_cubit.dart';
import 'features/prescriptions/presentation/cubit/prescriptions_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = PrettyBlocObserver();
  await CacheHelper.init();

  const isProd = bool.fromEnvironment('dart.vm.product');
  try {
    await Env.load(isProd ? EnvFile.prod : EnvFile.dev);
    await configureDependencies(isProd: isProd);
  } catch (e) {   
    debugPrint('Init Failed: $e');
  }

  runApp(const ToastificationWrapper(child: DoctorApp()));
}

class DoctorApp extends StatefulWidget {
  const DoctorApp({super.key});

  @override
  State<DoctorApp> createState() => _DoctorAppState();
}

class _DoctorAppState extends State<DoctorApp> {
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>()..init();
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: _authCubit),
            BlocProvider(create: (_) => sl<DashboardCubit>()),
            BlocProvider(create: (_) => sl<DoctorAppointmentsCubit>()),
            BlocProvider(create: (_) => sl<PrescriptionsCubit>()),
            BlocProvider(create: (_) => sl<DoctorProfileCubit>()),
            BlocProvider(create: (_) => sl<ClinicCubit>()),
          ],
          child: MaterialApp.router(
            title: 'Clinexa Doctor',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Inter',
              scaffoldBackgroundColor: AppColors.background,
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primary,
                surface: AppColors.surface,
                error: AppColors.error,
              ),
            ),
            routerConfig: createRouter(_authCubit),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
          ),
        );
      },
    );
  }
}
