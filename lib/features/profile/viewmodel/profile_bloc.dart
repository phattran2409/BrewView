import 'package:briewview/features/auth/repository/auth_repository.dart';
import 'package:briewview/features/profile/model/profile_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

  ProfileBloc(this._profileRepository, this._authRepository)
    : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ToggleLanguage>(_onToggleLanguage);
    on<Logout>(_onLogout);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateProfilePicture>(_onUpdateProfilePicture);
    on<LoadFullProfile>(_onLoadFullProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepository.getCurrentProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLoadFullProfile(
    LoadFullProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepository.loadFullProfile();
      print('Full profile loaded: $profile');
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(currentState.profile));
      try {
        final result = await _profileRepository.updateProfile(
          event.profileDTO,
        );
        print('Result after update: $result');
        final updatedProfile = ProfileDTO.fromJson(result);
        emit(ProfileUpdated(updatedProfile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onToggleLanguage(
    ToggleLanguage event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileRepository.updateLanguagePreference(event.isVietnamese);
      emit(LanguageToggled(event.isVietnamese));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<ProfileState> emit) async {
    emit(LoggingOut());
    try {
      await _authRepository.logout();
      emit(LoggedOut());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    emit(DeletingAccount());
    try {
      await _profileRepository.deleteAccount();
      emit(AccountDeleted());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfilePicture(
    UpdateProfilePicture event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(currentState.profile));
      try {
        // final updatedProfile = currentState.profile.copyWith(
        //   profilePicture: event.imagePath,
        // );
        final result = await _profileRepository.updateProfilePicture(
          event.imagePath,
        );
        if (result) {
          emit(ProfilePictureUpdatedSuccess());
        } else {
          emit(ProfileError('Failed to update profile picture'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }
}
