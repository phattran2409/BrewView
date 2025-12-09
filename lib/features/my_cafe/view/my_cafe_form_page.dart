import 'dart:ffi';
import 'dart:io';
import 'package:briewview/features/cafe/model/cafeMutation.dart';
import 'package:briewview/features/my_cafe/view/widgets/feature_tag_widget.dart';
import 'package:briewview/features/my_cafe/view/widgets/form/basic_info_section.dart';
import 'package:briewview/features/my_cafe/view/widgets/form/contact_info_section.dart';
import 'package:briewview/features/my_cafe/view/widgets/form/form_section_wrapper.dart';
import 'package:briewview/features/my_cafe/view/widgets/form/pricing_section.dart';
import 'package:briewview/features/my_cafe/view/widgets/form/schedule_section.dart';
import 'package:briewview/features/survey/model/category_model.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';
import 'package:briewview/features/survey/repository/survey_repository.dart';
import 'package:briewview/core/widgets/ImageUploadWIdget.dart';
import 'package:briewview/core/widgets/VideoUploadWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_bloc.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_event.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_sate.dart';

class MyCafeFormPage extends StatefulWidget {
  final String? cafeId; // null for create, non-null for edit
  final bool isEditing;

  const MyCafeFormPage({super.key, this.cafeId})
      : isEditing = cafeId != null;

  @override
  State<MyCafeFormPage> createState() => _MyCafeFormPageState();
}

class _MyCafeFormPageState extends State<MyCafeFormPage> {
  late CafeBloc _cafeBloc;
  late SurveyRepository _surveyRepository;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceMinController = TextEditingController();
  final _priceMaxController = TextEditingController();
  final _linkPageController = TextEditingController();
  final _hotlineController = TextEditingController();
  final _openingTimeController = TextEditingController();
  final _closingTimeController = TextEditingController();

  List<CategoryModel> _categories = [];
  List<FeatureTagModel> _featureTags = [];
  CategoryModel? _selectedCategory;
  List<int> _selectedFeatureTagIds = [];
  List<File> _selectedImages = [];
  List<File> _selectedVideos = [];
  CafeModel? _editingCafe;

  bool get _isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _cafeBloc = getIt<CafeBloc>();
    _surveyRepository = getIt<SurveyRepository>();
    _loadData();
  }

  void _loadData() async {
    try {
     
      // Load categories and feature tags
      final categories = await _surveyRepository.getCategories();
      final featureTags = await _surveyRepository.getFeatureTags();

      setState(() {
        _categories = categories;
        _featureTags = featureTags;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (_isEditing) {
      _cafeBloc.add(LoadCafeById(widget.cafeId!));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    _linkPageController.dispose();
    _hotlineController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    _cafeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B4513),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        title: Text(
          _isEditing ? 'Update cafe' : 'Create new cafe',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocProvider(
        create: (context) => _cafeBloc,
        child: BlocListener<CafeBloc, CafeState>(
          listener: (context, state) {
            if (state is CafeOperationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CafeDetailsLoaded) {
              _editingCafe = state.cafe;
              _populateForm(state.cafe);
            } else if (state is CafeCreated || state is CafeUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isEditing
                        ? 'Update cafe success!'
                        : 'Create cafe success!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop(true);
            }
          },
          child: BlocBuilder<CafeBloc, CafeState>(
            builder: (context, state) {
              if (state is MyCafesLoading && !_isEditing) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF5F1EB)),
                );
              }
              return _buildForm();
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FormSectionWrapper(
            title: 'Hình ảnh Cafe',
            icon: Icons.photo_camera,
            child: ImageUploadWidget(
              onImagesChanged: (images) {
                setState(() {
                  _selectedImages = images;
                });
              },
              maxImages: 5,
              isPremium: false,
            ),
          ),

          FormSectionWrapper(
            title: 'Video Cafe',
            icon: Icons.videocam,
            child: VideoUploadWidget(
              onVideosChanged: (videos) {
                setState(() {
                  _selectedVideos = videos;
                });
              },
              maxVideos: 1,
              maxVideoDurationSeconds: 60,
              isPremium: false,
            ),
          ),

          FormSectionWrapper(
            title: 'Thông tin cơ bản',
            icon: Icons.info_outline,
            child: BasicInfoSection(
              nameController: _nameController,
              addressController: _addressController,
              descriptionController: _descriptionController,
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategoryChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ),

          FormSectionWrapper(
            title: 'Thông tin giá cả',
            icon: Icons.attach_money,
            child: PricingSection(
              priceMinController: _priceMinController,
              priceMaxController: _priceMaxController,
            ),
          ),

          FormSectionWrapper(
            title: 'Giờ Hoạt Động',
            icon: Icons.access_time,
            child: ScheduleSection(
              openingHoursController: _openingTimeController,
              closingHoursController: _closingTimeController,
            ),
          ),

          FormSectionWrapper(
            title: 'Thông tin Liên hệ',
            icon: Icons.contact_phone,
            child: ContactInfoSection(
              hotlineController: _hotlineController,
              linkPageController: _linkPageController,
            ),
          ),

          FormSectionWrapper(
            title: 'Tính năng Cafe',
            icon: Icons.local_offer,
            child: FeatureTagSelector(
              featureTags: _featureTags,
              selectedTagIds: _selectedFeatureTagIds,
              onSelectionChanged: (tagIds) {
                setState(() {
                  _selectedFeatureTagIds = tagIds;
                });
              },
              maxSelection: 10, // Optional: limit selection
            ),
          ),

          const SizedBox(height: 30),
          _buildSubmitButton(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<CafeBloc, CafeState>(
      builder: (context, state) {
        final isLoading = state is CafeCreating || state is CafeUpdating;
        return ElevatedButton(
          onPressed: isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5F1EB),
            foregroundColor: const Color(0xFF8B4513),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:
              isLoading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF8B4513),
                    ),
                  )
                  : Text(
                    _isEditing ? 'Cập nhật Cafe' : 'Tạo Cafe',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        );
      },
    );
  }

  void _populateForm(CafeModel cafe) {
    _nameController.text = cafe.name ?? '';
    _addressController.text = cafe.address ?? '';
    _descriptionController.text = cafe.description ?? '';
    _priceMinController.text = cafe.priceMin?.toString() ?? '';
    _priceMaxController.text = cafe.priceMax?.toString() ?? '';
    _openingTimeController.text = cafe.openingTime ?? '';
    _closingTimeController.text = cafe.closingTime ?? '';
    _linkPageController.text = cafe.linkPage ?? '';
    _hotlineController.text = cafe.hotline ?? '';

    // Set selected category
    if (_categories.isNotEmpty) {
      _selectedCategory = _categories.firstWhere(
        (cat) => cat.categoryId == cafe.categoryId,
        orElse: () => _categories.first,
      );
    }

    // Set selected feature tags
    if (cafe.cafeFeatureTags != null) {
      _selectedFeatureTagIds =
          cafe.cafeFeatureTags!.map((featureTag) => featureTag.tagId).toList();
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) return;

    if (_isEditing && _editingCafe != null) {
      final request = UpdateCafeRequest(
        cafeId: _editingCafe!.cafeId!,
        categoryId: _selectedCategory!.categoryId,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim(),
        priceMin: int.parse(_priceMinController.text.trim()),
        priceMax: int.parse(_priceMaxController.text.trim()),
        openingTime: _openingTimeController.text.trim(),
        closingTime: _closingTimeController.text.trim(),
        linkPage:
            _linkPageController.text.trim().isEmpty
                ? null
                : _linkPageController.text.trim(),
        hotline:
            _hotlineController.text.trim().isEmpty
                ? null
                : _hotlineController.text.trim(),
        cafeFeatureTags: _selectedFeatureTagIds,
      );
      final allMediaFiles = [..._selectedImages, ..._selectedVideos];
      _cafeBloc.add(
        UpdateCafe(
          request,
          mediaFiles: allMediaFiles.isNotEmpty ? allMediaFiles : null,
        ),
      );
    } else {
      final request = CreateCafeRequest(
        categoryId: _selectedCategory!.categoryId,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim(),
        priceMin: int.parse(_priceMinController.text.trim()),
        priceMax: int.parse(_priceMaxController.text.trim()),
        openingTime: _openingTimeController.text.trim(),
        closingTime: _closingTimeController.text.trim(),
        linkPage:
            _linkPageController.text.trim().isEmpty
                ? null
                : _linkPageController.text.trim(),
        hotline:
            _hotlineController.text.trim().isEmpty
                ? null
                : _hotlineController.text.trim(),
        selectedFeatureTagIds: _selectedFeatureTagIds,
      );
      final allMediaFiles = [..._selectedImages, ..._selectedVideos];
      _cafeBloc.add(
        CreateCafe(
          request,
          mediaFiles: allMediaFiles.isNotEmpty ? allMediaFiles : null,
        ),
      );
    }
  }
}
