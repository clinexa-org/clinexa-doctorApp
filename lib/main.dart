import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pretty_bloc_observer/pretty_bloc_observer.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_colors.dart';
import 'core/config/env.dart';
import 'core/di/injection.dart';
import 'core/storage/cache_helper.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/clinic_settings/presentation/cubit/clinic_cubit.dart';
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'features/doctor_appointments/presentation/cubit/doctor_appointments_cubit.dart';
import 'features/doctor_profile/presentation/cubit/doctor_profile_cubit.dart';
import 'features/prescriptions/presentation/cubit/prescriptions_cubit.dart';
import 'features/notifications/presentation/cubit/notifications_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Phase 1: Core Initialization
  Bloc.observer = PrettyBlocObserver();
  await CacheHelper.init();

  // Phase 2: Firebase Initialization
  await _initializeFirebase();

  // Phase 3: Environment & Dependency Injection
  final isInitialized = await _initializeDependencies();
  if (!isInitialized) {
    runApp(const _InitializationErrorApp());
    return;
  }

  // Phase 4: FCM Setup (AFTER DI is ready)
  await _setupFCM();

  // Phase 5: Run App
  runApp(const ToastificationWrapper(child: DoctorApp()));
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase Initialized');
  } catch (e, s) {
    debugPrint('Firebase Init Failed: $e\n$s');
  }
}

Future<bool> _initializeDependencies() async {
  const isProd = bool.fromEnvironment('dart.vm.product');
  try {
    await Env.load(isProd ? EnvFile.prod : EnvFile.dev);
    await configureDependencies(isProd: isProd);
    debugPrint('Dependencies Configured');
    return true;
  } catch (e, s) {
    debugPrint('DI Failed: $e\n$s');
    return false;
  }
}

Future<void> _setupFCM() async {
  try {
    NotificationService.initialize();
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await messaging.getToken();
    debugPrint('FCM Token: $token');

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    debugPrint('FCM Listener Attached');
  } catch (e, s) {
    debugPrint('FCM Setup Failed: $e\n$s');
  }
}

void _handleForegroundMessage(RemoteMessage message) {
  debugPrint('FCM: ${message.notification?.title}');
  NotificationService.show(message);

  _refreshCubit<NotificationsCubit>((c) => c.loadNotifications());
  _refreshCubit<DashboardCubit>((c) => c.loadDashboard());
  _refreshCubit<DoctorAppointmentsCubit>((c) => c.getAppointments());
}

void _refreshCubit<T extends Object>(void Function(T) action) {
  try {
    if (sl.isRegistered<T>()) action(sl<T>());
  } catch (e) {
    debugPrint('Refresh ${T.toString()} failed: $e');
  }
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
      builder: (_, __) {
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
            supportedLocales: const [Locale('en'), Locale('ar')],
          ),
        );
      },
    );
  }
}

class _InitializationErrorApp extends StatelessWidget {
  const _InitializationErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    color: Colors.redAccent, size: 64),
                const SizedBox(height: 24),
                const Text(
                  'Initialization Failed',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Could not start the app. Please check your connection.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
