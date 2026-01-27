import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/usecases/create_prescription_usecase.dart';
import '../../domain/usecases/get_prescriptions_usecase.dart';
import '../../domain/usecases/update_prescription_usecase.dart';
import 'prescriptions_state.dart';

class PrescriptionsCubit extends Cubit<PrescriptionsState> {
  final GetPrescriptionsUseCase getPrescriptionsUseCase;
  final CreatePrescriptionUseCase createPrescriptionUseCase;
  final UpdatePrescriptionUseCase updatePrescriptionUseCase;

  PrescriptionsCubit({
    required this.getPrescriptionsUseCase,
    required this.createPrescriptionUseCase,
    required this.updatePrescriptionUseCase,
  }) : super(const PrescriptionsState());

  Future<void> getPrescriptions() async {
    emit(state.copyWith(status: PrescriptionsStatus.loading));

    final result = await getPrescriptionsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: PrescriptionsStatus.failure,
        errorMessage: failure.message,
      )),
      (prescriptions) => emit(state.copyWith(
        status: PrescriptionsStatus.success,
        prescriptions: prescriptions,
      )),
    );
  }

  Future<void> createPrescription({
    required String appointmentId,
    required String patientId,
    required String diagnosis,
    required List<MedicationEntity> medications,
    String? notes,
    String? patientName,
  }) async {
    emit(state.copyWith(status: PrescriptionsStatus.creating));

    final result = await createPrescriptionUseCase(
      appointmentId: appointmentId,
      patientId: patientId,
      diagnosis: diagnosis,
      medications: medications,
      notes: notes,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PrescriptionsStatus.actionFailure,
        errorMessage: failure.message,
      )),
      (prescription) {
        // Patch patient name if returned as Unknown and we have a better name
        PrescriptionEntity finalPrescription = prescription;
        if ((finalPrescription.patientName == 'Unknown' ||
                finalPrescription.patientName.isEmpty) &&
            patientName != null) {
          finalPrescription =
              finalPrescription.copyWith(patientName: patientName);
        }

        final updatedList = [finalPrescription, ...state.prescriptions];
        emit(state.copyWith(
          status: PrescriptionsStatus.createSuccess,
          prescriptions: updatedList,
          selectedPrescription: finalPrescription,
        ));

        // Trigger refresh to ensure backend sync
        getPrescriptions();
      },
    );
  }

  Future<void> updatePrescription({
    required String id,
    required String diagnosis,
    required List<MedicationEntity> medications,
    String? notes,
  }) async {
    emit(state.copyWith(status: PrescriptionsStatus.updating));

    final result = await updatePrescriptionUseCase(
      id: id,
      diagnosis: diagnosis,
      medications: medications,
      notes: notes,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PrescriptionsStatus.actionFailure,
        errorMessage: failure.message,
      )),
      (prescription) {
        final updatedList = state.prescriptions
            .map((p) => p.id == prescription.id ? prescription : p)
            .toList();
        emit(state.copyWith(
          status: PrescriptionsStatus.updateSuccess,
          prescriptions: updatedList,
          selectedPrescription: prescription,
        ));
      },
    );
  }

  void selectPrescription(PrescriptionEntity? prescription) {
    emit(state.copyWith(selectedPrescription: prescription));
  }
}
