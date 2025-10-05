import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/my_cafe/repository/my_cafe_repository.dart';
import 'package:briewview/features/my_cafe/viewmodel/my_cafe_event.dart';
import 'package:briewview/features/my_cafe/viewmodel/my_cafe_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyCafeBloc extends Bloc<MyCafeEvent, MyCafeState> {
  final MyCafeRepository _repository;

  MyCafeBloc(this._repository) : super(MyCafeInitial()) {
    on<LoadMyCafes>(_onLoadMyCafes);
    on<LoadCafeById>(_onLoadCafeById);
    on<LoadCategories>(_onLoadCategories);
    on<LoadFeatureTags>(_onLoadFeatureTags);
    on<CreateCafe>(_onCreateCafe);
    on<UpdateCafe>(_onUpdateCafe);
    on<DeleteCafe>(_onDeleteCafe);
    on<RefreshCafes>(_onRefreshCafes);
    on<ClearError>(_onClearError);
    on<ResetState>(_onResetState);
  }

  Future<void> _onLoadMyCafes(LoadMyCafes event, Emitter<MyCafeState> emit) async {
    try {
      emit(MyCafeLoading());
      final cafes = await _repository.getMyCafes();
      emit(MyCafesLoaded(cafes));
    } catch (e) {
      emit(MyCafeError('Failed to load cafes: ${e.toString()}'));
    }
  }

  Future<void> _onLoadCafeById(LoadCafeById event, Emitter<MyCafeState> emit) async {
    try {
      emit(MyCafeLoading());
      final cafe = await _repository.getCafeById(event.cafeId);
      emit(CafeLoaded(cafe));
    } catch (e) {
      emit(MyCafeError('Failed to load cafe: ${e.toString()}'));
    }
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<MyCafeState> emit) async {
    try {
      emit(MyCafeLoading());
      final categories = await _repository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(MyCafeError('Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> _onLoadFeatureTags(LoadFeatureTags event, Emitter<MyCafeState> emit) async {
    try {
      emit(MyCafeLoading());
      final featureTags = await _repository.getFeatureTags();
      emit(FeatureTagsLoaded(featureTags));
    } catch (e) {
      emit(MyCafeError('Failed to load feature tags: ${e.toString()}'));
    }
  }

  Future<void> _onCreateCafe(CreateCafe event, Emitter<MyCafeState> emit) async {
    try {
      emit(MyCafeCreating());
      final cafe = await _repository.createCafe(event.request, event.mediaFiles);
      emit(CafeCreated(cafe));
    } catch (e) {
      emit(MyCafeError('Failed to create cafe: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCafe(UpdateCafe event, Emitter<MyCafeState> emit) async {
    try {
      emit(MyCafeUpdating());
      final cafe = await _repository.updateCafe(event.request, event.mediaFiles);
      emit(CafeUpdated(cafe));
    } catch (e) {
      emit(MyCafeError('Failed to update cafe: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCafe(DeleteCafe event, Emitter<MyCafeState> emit) async {
    try {
      emit(MyCafeDeleting());
      await _repository.deleteCafe(event.cafeId);
      emit(CafeDeleted(event.cafeId));
    } catch (e) {
      emit(MyCafeError('Failed to delete cafe: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshCafes(RefreshCafes event, Emitter<MyCafeState> emit) async {
    try {
      final cafes = await _repository.getMyCafes();
      emit(MyCafesLoaded(cafes));
    } catch (e) {
      emit(MyCafeError('Failed to refresh cafes: ${e.toString()}'));
    }
  }

  void _onClearError(ClearError event, Emitter<MyCafeState> emit) {
    emit(MyCafeInitial());
  }

  void _onResetState(ResetState event, Emitter<MyCafeState> emit) {
    emit(MyCafeInitial());
  }
}
