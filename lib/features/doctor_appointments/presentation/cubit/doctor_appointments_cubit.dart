import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_appointment_entity.dart';
import '../../data/models/doctor_appointment_model.dart';
import '../../domain/usecases/cancel_appointment_usecase.dart';
import '../../domain/usecases/complete_appointment_usecase.dart';
import '../../domain/usecases/confirm_appointment_usecase.dart';
import '../../domain/usecases/get_doctor_appointments_usecase.dart';
import 'doctor_appointments_state.dart';

class DoctorAppointmentsCubit extends Cubit<DoctorAppointmentsState> {
  final GetDoctorAppointmentsUseCase getDoctorAppointmentsUseCase;
  final ConfirmAppointmentUseCase confirmAppointmentUseCase;
  final CompleteAppointmentUseCase completeAppointmentUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;

  DoctorAppointmentsCubit({
    required this.getDoctorAppointmentsUseCase,
    required this.confirmAppointmentUseCase,
    required this.completeAppointmentUseCase,
    required this.cancelAppointmentUseCase,
  }) : super(const DoctorAppointmentsState());

  Future<void> getAppointments({String? date}) async {
    emit(state.copyWith(status: DoctorAppointmentsStatus.loading));

    final result = await getDoctorAppointmentsUseCase(date: date);

    result.fold(
      (failure) => emit(state.copyWith(
        status: DoctorAppointmentsStatus.failure,
        errorMessage: failure.message,
      )),
      (appointments) {
        // Sort appointments by date and time ascending
        appointments.sort((a, b) {
          final dateCompare = a.date.compareTo(b.date);
          if (dateCompare != 0) return dateCompare;
          // If dates are equal, compare times (assuming HH:mm format)
          return a.time.compareTo(b.time);
        });

        emit(state.copyWith(
          status: DoctorAppointmentsStatus.success,
          appointments: appointments,
        ));
      },
    );
  }

  Future<void> confirmAppointment(String id) async {
    emit(state.copyWith(
      status: DoctorAppointmentsStatus.confirming,
      actionAppointmentId: id,
    ));

    final result = await confirmAppointmentUseCase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: DoctorAppointmentsStatus.actionFailure,
        errorMessage: failure.message,
      )),
      (updatedAppointment) {
        final updatedList = _updateAppointmentInList(updatedAppointment);
        emit(state.copyWith(
          status: DoctorAppointmentsStatus.confirmSuccess,
          appointments: updatedList,
        ));
      },
    );
  }

  Future<void> completeAppointment(String id) async {
    emit(state.copyWith(
      status: DoctorAppointmentsStatus.completing,
      actionAppointmentId: id,
    ));

    final result = await completeAppointmentUseCase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: DoctorAppointmentsStatus.actionFailure,
        errorMessage: failure.message,
      )),
      (updatedAppointment) {
        final updatedList = _updateAppointmentInList(updatedAppointment);
        emit(state.copyWith(
          status: DoctorAppointmentsStatus.completeSuccess,
          appointments: updatedList,
        ));
      },
    );
  }

  Future<void> cancelAppointment(String id, {String? reason}) async {
    emit(state.copyWith(
      status: DoctorAppointmentsStatus.cancelling,
      actionAppointmentId: id,
    ));

    final result = await cancelAppointmentUseCase(id, reason: reason);

    result.fold(
      (failure) => emit(state.copyWith(
        status: DoctorAppointmentsStatus.actionFailure,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedList =
            state.appointments.where((a) => a.id != id).toList();
        emit(state.copyWith(
          status: DoctorAppointmentsStatus.cancelSuccess,
          appointments: updatedList,
        ));
      },
    );
  }

  List<DoctorAppointmentEntity> _updateAppointmentInList(
      DoctorAppointmentEntity updated) {
    return state.appointments.map((a) {
      if (a.id == updated.id) {
        // If the updated appointment has "Unknown Patient" (likely due to unpopulated API response),
        // preserve the existing patient details from the original appointment.
        if (updated.patientName == 'Unknown Patient' &&
            a.patientName != 'Unknown Patient') {
          return DoctorAppointmentModel(
            id: updated.id,
            date: updated.date,
            time: updated.time,
            reason: updated.reason,
            status: updated.status,
            patientId: updated.patientId,
            patientName: a.patientName,
            patientPhone: a.patientPhone,
            patientAvatar: a.patientAvatar,
            notes: updated.notes,
          );
        }
        return updated;
      }
      return a;
    }).toList();
  }
}
