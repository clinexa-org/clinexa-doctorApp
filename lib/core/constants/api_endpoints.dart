class ApiEndpoints {
  ApiEndpoints._();

  // ============ Auth Endpoints ============
  static const String login = '/auth/login';
  static const String authMe = '/auth/me';

  // ============ Doctor Profile Endpoints ============
  static const String doctorMe = '/doctors/me';
  static const String doctors = '/doctors';

  // ============ Clinic Endpoints ============
  static const String clinics = '/clinics';
  static const String clinicMe = '/clinics/me';
  static const String workingHoursMe = '/clinics/working-hours/me';

  // ============ Appointments Endpoints ============
  static const String appointments = '/appointments';
  static const String appointmentsDoctor = '/appointments/doctor';
  static String appointmentConfirm(String id) => '/appointments/confirm/$id';
  static String appointmentComplete(String id) => '/appointments/complete/$id';
  static String appointmentCancel(String id) => '/appointments/cancel/$id';

  // ============ Prescriptions Endpoints ============
  static const String prescriptions = '/prescriptions';
  static String prescriptionById(String id) => '/prescriptions/$id';
  static String prescriptionsByPatient(String patientId) =>
      '/prescriptions/patient/$patientId';
  static String prescriptionsByAppointment(String appointmentId) =>
      '/prescriptions/appointment/$appointmentId';

  // ============ Dashboard Endpoints ============
  static const String doctorStats = '/doctors/stats';
}
