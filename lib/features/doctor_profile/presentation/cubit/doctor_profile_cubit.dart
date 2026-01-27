import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_doctor_profile_usecase.dart';
import '../../domain/usecases/update_doctor_profile_usecase.dart';
import 'doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final GetDoctorProfileUseCase getDoctorProfileUseCase;
  final UpdateDoctorProfileUseCase updateDoctorProfileUseCase;

  DoctorProfileCubit({
    required this.getDoctorProfileUseCase,
    required this.updateDoctorProfileUseCase,
  }) : super(const DoctorProfileState());

  Future<void> getDoctorProfile() async {
    emit(state.copyWith(status: DoctorProfileStatus.loading));

    final result = await getDoctorProfileUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: DoctorProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (profile) => emit(state.copyWith(
        status: DoctorProfileStatus.success,
        profile: profile,
      )),
    );
  }

  Future<void> updateDoctorProfile({
    required String specialization,
    String? name,
    String? bio,
    int? yearsOfExperience,
    String? phone,
    dynamic avatarFile,
  }) async {
    emit(state.copyWith(status: DoctorProfileStatus.updating));

    final result = await updateDoctorProfileUseCase(
      specialization: specialization,
      name: name,
      bio: bio,
      yearsOfExperience: yearsOfExperience,
      phone: phone,
      avatarFile: avatarFile,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: DoctorProfileStatus.updateFailure,
        errorMessage: failure.message,
      )),
      (profile) => emit(state.copyWith(
        status: DoctorProfileStatus.updateSuccess,
        profile: profile,
      )),
    );
  }
}
