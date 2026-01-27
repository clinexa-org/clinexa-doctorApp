import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/working_hours_entity.dart';
import '../../domain/usecases/get_clinic_usecase.dart';
import '../../domain/usecases/get_working_hours_usecase.dart';
import '../../domain/usecases/update_clinic_usecase.dart';
import '../../domain/usecases/update_working_hours_usecase.dart';
import 'clinic_state.dart';

class ClinicCubit extends Cubit<ClinicState> {
  final GetClinicUseCase getClinicUseCase;
  final UpdateClinicUseCase updateClinicUseCase;
  final GetWorkingHoursUseCase getWorkingHoursUseCase;
  final UpdateWorkingHoursUseCase updateWorkingHoursUseCase;

  ClinicCubit({
    required this.getClinicUseCase,
    required this.updateClinicUseCase,
    required this.getWorkingHoursUseCase,
    required this.updateWorkingHoursUseCase,
  }) : super(const ClinicState());

  Future<void> getClinic() async {
    emit(state.copyWith(status: ClinicStatus.loading));

    final result = await getClinicUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ClinicStatus.failure,
        errorMessage: failure.message,
      )),
      (clinic) => emit(state.copyWith(
        status: ClinicStatus.success,
        clinic: clinic,
      )),
    );
  }

  Future<void> updateClinic({
    required String name,
    required String address,
    String? phone,
    String? city,
    String? locationLink,
    int? slotDuration,
  }) async {
    emit(state.copyWith(status: ClinicStatus.updating));

    final result = await updateClinicUseCase(
      name: name,
      address: address,
      phone: phone,
      city: city,
      locationLink: locationLink,
      slotDuration: slotDuration,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ClinicStatus.updateFailure,
        errorMessage: failure.message,
      )),
      (clinic) => emit(state.copyWith(
        status: ClinicStatus.updateSuccess,
        clinic: clinic,
      )),
    );
  }

  Future<void> getWorkingHours() async {
    emit(state.copyWith(status: ClinicStatus.loading));

    final result = await getWorkingHoursUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ClinicStatus.failure,
        errorMessage: failure.message,
      )),
      (workingHours) => emit(state.copyWith(
        status: ClinicStatus.success,
        workingHours: workingHours,
      )),
    );
  }

  Future<void> updateWorkingHours({
    required List<WorkingHoursEntity> schedule,
    required int slotDuration,
  }) async {
    emit(state.copyWith(status: ClinicStatus.updating));

    final result = await updateWorkingHoursUseCase(
      schedule: schedule,
      slotDuration: slotDuration,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ClinicStatus.updateFailure,
        errorMessage: failure.message,
      )),
      (workingHours) => emit(state.copyWith(
        status: ClinicStatus.updateSuccess,
        workingHours: workingHours,
      )),
    );
  }

  void toggleDay(String dayOfWeek, bool isEnabled) {
    if (state.workingHours == null) return;

    final updatedSchedule = state.workingHours!.schedule.map((wh) {
      if (wh.dayOfWeek.toLowerCase() == dayOfWeek.toLowerCase()) {
        return WorkingHoursEntity(
          dayOfWeek: wh.dayOfWeek,
          isOpen: isEnabled,
          startTime: wh.startTime,
          endTime: wh.endTime,
        );
      }
      return wh;
    }).toList();

    emit(state.copyWith(
      workingHours: WorkingHoursScheduleEntity(
        schedule: updatedSchedule,
        slotDuration: state.workingHours!.slotDuration,
      ),
    ));
  }

  void updateStartTime(String dayOfWeek, String time) {
    if (state.workingHours == null) return;

    final updatedSchedule = state.workingHours!.schedule.map((wh) {
      if (wh.dayOfWeek.toLowerCase() == dayOfWeek.toLowerCase()) {
        return WorkingHoursEntity(
          dayOfWeek: wh.dayOfWeek,
          isOpen: wh.isOpen,
          startTime: time,
          endTime: wh.endTime,
        );
      }
      return wh;
    }).toList();

    emit(state.copyWith(
      workingHours: WorkingHoursScheduleEntity(
        schedule: updatedSchedule,
        slotDuration: state.workingHours!.slotDuration,
      ),
    ));
  }

  void updateEndTime(String dayOfWeek, String time) {
    if (state.workingHours == null) return;

    final updatedSchedule = state.workingHours!.schedule.map((wh) {
      if (wh.dayOfWeek.toLowerCase() == dayOfWeek.toLowerCase()) {
        return WorkingHoursEntity(
          dayOfWeek: wh.dayOfWeek,
          isOpen: wh.isOpen,
          startTime: wh.startTime,
          endTime: time,
        );
      }
      return wh;
    }).toList();

    emit(state.copyWith(
      workingHours: WorkingHoursScheduleEntity(
        schedule: updatedSchedule,
        slotDuration: state.workingHours!.slotDuration,
      ),
    ));
  }
}
