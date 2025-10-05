import 'package:briewview/features/my_cafe/model/create_cafe_request.dart';
import 'package:briewview/features/my_cafe/model/update_cafe_request.dart';
import 'dart:io';

abstract class MyCafeEvent {}

// Load events
class LoadMyCafes extends MyCafeEvent {}

class LoadCafeById extends MyCafeEvent {
  final String cafeId;
  LoadCafeById(this.cafeId);
}

class LoadCategories extends MyCafeEvent {}

class LoadFeatureTags extends MyCafeEvent {}

// CRUD events
class CreateCafe extends MyCafeEvent {
  final CreateCafeRequest request;
  final List<File>? mediaFiles;
  CreateCafe(this.request, {this.mediaFiles});
}

class UpdateCafe extends MyCafeEvent {
  final UpdateCafeRequest request;
  final List<File>? mediaFiles;
  UpdateCafe(this.request, {this.mediaFiles});
}

class DeleteCafe extends MyCafeEvent {
  final String cafeId;
  DeleteCafe(this.cafeId);
}

// UI events
class RefreshCafes extends MyCafeEvent {}

class ClearError extends MyCafeEvent {}

class ResetState extends MyCafeEvent {}
