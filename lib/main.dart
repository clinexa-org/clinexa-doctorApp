import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pretty_bloc_observer/pretty_bloc_observer.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_core/firebase_core.dart';

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
import 'features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = PrettyBlocObserver();
  await CacheHelper.init();

  // Initialize Firebase
  if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBfvFDI0N0l5Q8Yd5xwn23vWAqoLyxKqXU',
        appId: '1:809087966415:android:e2bddc81c3026ed124ebba',
        messagingSenderId: '809087966415',
        projectId: 'clinexa-patient',
        storageBucket: 'clinexa-patient.firebasestorage.app',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Initialize Notification Service
  NotificationService.initialize();

  // Request Notification Permissions
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Foreground Notification Listener
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('🔔🔔🔔 FCM FOREGROUND MESSAGE RECEIVED 🔔🔔🔔');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');

    NotificationService.show(message);

    // Refresh data if user is inside the app
    try {
      if (sl.isRegistered<NotificationsCubit>()) {
        debugPrint('✅ Refreshing NotificationsCubit...');
        sl<NotificationsCubit>().loadNotifications();
      }
      if (sl.isRegistered<DashboardCubit>()) {
        debugPrint('✅ Refreshing DashboardCubit...');
        sl<DashboardCubit>().loadDashboard();
      }
      if (sl.isRegistered<DoctorAppointmentsCubit>()) {
        debugPrint('✅ Refreshing DoctorAppointmentsCubit...');
        sl<DoctorAppointmentsCubit>().getAppointments();
      }
    } catch (e) {
      debugPrint('❌ Error refreshing cubits: $e');
    }
  });

  const isProd = bool.fromEnvironment('dart.vm.product');
  try {
    await Env.load(isProd ? EnvFile.prod : EnvFile.dev);
    await configureDependencies(isProd: isProd);

    // Get FCM Token for debugging
    final token = await messaging.getToken();
    debugPrint('FCM Token: $token');
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
            BlocProvider(create: (_) => sl<NotificationsCubit>()),
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
