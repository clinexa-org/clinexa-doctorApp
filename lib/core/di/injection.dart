import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

// Core
import '../network/api_client.dart';
import '../network/dio_factory.dart';
import '../storage/cache_helper.dart';

// Auth Feature
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Doctor Profile Feature
import '../../features/doctor_profile/data/datasources/doctor_profile_remote_data_source.dart';
import '../../features/doctor_profile/data/repositories/doctor_profile_repository_impl.dart';
import '../../features/doctor_profile/domain/repositories/doctor_profile_repository.dart';
import '../../features/doctor_profile/domain/usecases/get_doctor_profile_usecase.dart';
import '../../features/doctor_profile/domain/usecases/update_doctor_profile_usecase.dart';
import '../../features/doctor_profile/presentation/cubit/doctor_profile_cubit.dart';

// Clinic Settings Feature
import '../../features/clinic_settings/data/datasources/clinic_remote_data_source.dart';
import '../../features/clinic_settings/data/repositories/clinic_repository_impl.dart';
import '../../features/clinic_settings/domain/repositories/clinic_repository.dart';
import '../../features/clinic_settings/domain/usecases/get_clinic_usecase.dart';
import '../../features/clinic_settings/domain/usecases/get_working_hours_usecase.dart';
import '../../features/clinic_settings/domain/usecases/update_clinic_usecase.dart';
import '../../features/clinic_settings/domain/usecases/update_working_hours_usecase.dart';
import '../../features/clinic_settings/presentation/cubit/clinic_cubit.dart';

// Doctor Appointments Feature
import '../../features/doctor_appointments/data/datasources/doctor_appointments_remote_data_source.dart';
import '../../features/doctor_appointments/data/repositories/doctor_appointments_repository_impl.dart';
import '../../features/doctor_appointments/domain/repositories/doctor_appointments_repository.dart';
import '../../features/doctor_appointments/domain/usecases/cancel_appointment_usecase.dart';
import '../../features/doctor_appointments/domain/usecases/complete_appointment_usecase.dart';
import '../../features/doctor_appointments/domain/usecases/confirm_appointment_usecase.dart';
import '../../features/doctor_appointments/domain/usecases/get_doctor_appointments_usecase.dart';
import '../../features/doctor_appointments/presentation/cubit/doctor_appointments_cubit.dart';

// Prescriptions Feature
import '../../features/prescriptions/data/datasources/prescriptions_remote_data_source.dart';
import '../../features/prescriptions/data/repositories/prescriptions_repository_impl.dart';
import '../../features/prescriptions/domain/repositories/prescriptions_repository.dart';
import '../../features/prescriptions/domain/usecases/create_prescription_usecase.dart';
import '../../features/prescriptions/domain/usecases/get_prescriptions_usecase.dart';
import '../../features/prescriptions/domain/usecases/update_prescription_usecase.dart';
import '../../features/prescriptions/presentation/cubit/prescriptions_cubit.dart';

// Dashboard Feature
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';

// Notifications Feature
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import '../../features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';

// Core Services
import '../services/socket_service.dart';

final sl = GetIt.instance;

Future<void> configureDependencies({required bool isProd}) async {
  // ===== CORE =====
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper());

  sl.registerLazySingleton<Dio>(() {
    final factory = DioFactory(
      cacheHelper: sl(),
      isProd: isProd,
      onUnauthorized: () {
        // Handle unauthorized (e.g. logout)
      },
    );
    return factory.create();
  });

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // ===== AUTH FEATURE =====
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remote: sl(),
        local: sl(),
      ));

  sl.registerLazySingleton(() => LoginUseCase(sl()));

  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      repository: sl(),
      loginUseCase: sl(),
    ),
  );

  // ===== DOCTOR PROFILE FEATURE =====
  sl.registerLazySingleton<DoctorProfileRemoteDataSource>(
    () => DoctorProfileRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<DoctorProfileRepository>(
    () => DoctorProfileRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetDoctorProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDoctorProfileUseCase(sl()));

  sl.registerFactory<DoctorProfileCubit>(
    () => DoctorProfileCubit(
      getDoctorProfileUseCase: sl(),
      updateDoctorProfileUseCase: sl(),
    ),
  );

  // ===== CLINIC SETTINGS FEATURE =====
  sl.registerLazySingleton<ClinicRemoteDataSource>(
    () => ClinicRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ClinicRepository>(
    () => ClinicRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetClinicUseCase(sl()));
  sl.registerLazySingleton(() => UpdateClinicUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkingHoursUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWorkingHoursUseCase(sl()));

  sl.registerFactory<ClinicCubit>(
    () => ClinicCubit(
      getClinicUseCase: sl(),
      updateClinicUseCase: sl(),
      getWorkingHoursUseCase: sl(),
      updateWorkingHoursUseCase: sl(),
    ),
  );

  // ===== DOCTOR APPOINTMENTS FEATURE =====
  sl.registerLazySingleton<DoctorAppointmentsRemoteDataSource>(
    () => DoctorAppointmentsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<DoctorAppointmentsRepository>(
    () => DoctorAppointmentsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetDoctorAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => CompleteAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => CancelAppointmentUseCase(sl()));

  sl.registerLazySingleton<DoctorAppointmentsCubit>(
    () => DoctorAppointmentsCubit(
      getDoctorAppointmentsUseCase: sl(),
      confirmAppointmentUseCase: sl(),
      completeAppointmentUseCase: sl(),
      cancelAppointmentUseCase: sl(),
    ),
  );

  // ===== PRESCRIPTIONS FEATURE =====
  sl.registerLazySingleton<PrescriptionsRemoteDataSource>(
    () => PrescriptionsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PrescriptionsRepository>(
    () => PrescriptionsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetPrescriptionsUseCase(sl()));
  sl.registerLazySingleton(() => CreatePrescriptionUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePrescriptionUseCase(sl()));

  sl.registerLazySingleton<PrescriptionsCubit>(
    () => PrescriptionsCubit(
      getPrescriptionsUseCase: sl(),
      createPrescriptionUseCase: sl(),
      updatePrescriptionUseCase: sl(),
    ),
  );

  // ===== DASHBOARD FEATURE =====
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));

  sl.registerLazySingleton<DashboardCubit>(
    () => DashboardCubit(
      getDashboardStatsUseCase: sl(),
      getDoctorAppointmentsUseCase: sl(),
    ),
  );

  // ===== CORE SERVICES =====
  sl.registerLazySingleton<SocketService>(() => SocketService());

  // ===== NOTIFICATIONS FEATURE =====
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsReadUseCase(sl()));

  sl.registerLazySingleton<NotificationsCubit>(
    () => NotificationsCubit(
      getNotificationsUseCase: sl(),
      markNotificationReadUseCase: sl(),
      markAllNotificationsReadUseCase: sl(),
    ),
  );
}
