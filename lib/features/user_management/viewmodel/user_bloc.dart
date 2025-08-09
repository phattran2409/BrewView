import 'package:briewview/features/user_management/repository/user_repository.dart';
import 'package:briewview/features/user_management/viewmodel/user_event.dart';
import 'package:briewview/features/user_management/viewmodel/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repo;
  UserBloc(this.repo) : super(const UserState()) {
    on<LoadUsers>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final list = await repo.getAll();
        emit(state.copyWith(isLoading: false, users: list));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    }); 
  }
}
