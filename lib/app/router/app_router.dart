import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/clinic_settings/presentation/pages/clinic_settings_page.dart';
import '../../features/clinic_settings/presentation/pages/working_hours_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/doctor_profile/presentation/pages/edit_profile_page.dart';
import '../../features/doctor_appointments/domain/entities/doctor_appointment_entity.dart';
import '../../features/doctor_appointments/presentation/pages/appointment_details_page.dart';
import '../../features/prescriptions/domain/entities/prescription_entity.dart';
import '../../features/prescriptions/presentation/pages/create_prescription_page.dart';
import '../../features/prescriptions/presentation/pages/prescription_details_page.dart';
import '../../features/notifications/presentation/pages/inbox_page.dart';
import '../../features/patient_profile/presentation/pages/patient_profile_page.dart';
import 'route_names.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Converts a Cubit stream into a Listenable for GoRouter refresh
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash, // Start with splash, not login
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final isLoggedIn = authCubit.state.isLoggedIn;
      final isOnSplash = state.matchedLocation == RouteNames.splash;
      final isOnLogin = state.matchedLocation == RouteNames.login;

      // Allow splash to show while auth is initializing
      if (isOnSplash) {
        return null; // Let splash handle the navigation
      }

      // If not logged in and not on login page, redirect to login
      if (!isLoggedIn && !isOnLogin) {
        return RouteNames.login;
      }

      // If logged in and on login page, redirect to dashboard
      if (isLoggedIn && isOnLogin) {
        return RouteNames.dashboard;
      }

      return null;
    },
    routes: [
      // Splash Route (initial)
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),

      // Main Dashboard (contains bottom nav)
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),

      // Sub-routes (navigated via push)
      GoRoute(
        path: RouteNames.createPrescription,
        builder: (context, state) {
          final appointmentId = state.uri.queryParameters['appointmentId'];
          return CreatePrescriptionPage(appointmentId: appointmentId);
        },
      ),
      GoRoute(
        path: RouteNames.clinicSettings,
        builder: (context, state) => const ClinicSettingsPage(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteNames.workingHours,
        builder: (context, state) => const WorkingHoursPage(),
      ),
      GoRoute(
        path: RouteNames.prescriptionDetails,
        builder: (context, state) {
          final prescription = state.extra as PrescriptionEntity;
          return PrescriptionDetailsPage(prescription: prescription);
        },
      ),
      GoRoute(
        path: RouteNames.appointmentDetails,
        builder: (context, state) {
          final appointment = state.extra as DoctorAppointmentEntity;
          return AppointmentDetailsPage(appointment: appointment);
        },
      ),

      // Notifications
      GoRoute(
        path: RouteNames.inbox,
        builder: (context, state) => const InboxPage(),
      ),

      // Patient Profile
      GoRoute(
        path: RouteNames.patientProfile,
        builder: (context, state) {
          final args = state.extra as PatientProfileArgs;
          return PatientProfilePage(args: args);
        },
      ),
    ],
  );
}
