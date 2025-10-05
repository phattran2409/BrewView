import 'dart:io';
import 'package:briewview/features/my_cafe/view/widgets/form/basic_info_section.dart';
import 'package:briewview/features/my_cafe/view/widgets/form/contact_info_section.dart';
import 'package:briewview/features/my_cafe/view/widgets/form/form_section_wrapper.dart';
import 'package:briewview/features/my_cafe/view/widgets/form/pricing_section.dart';
import 'package:briewview/features/my_cafe/view/widgets/form/schedule_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/my_cafe/model/cafe_model.dart';
import 'package:briewview/features/my_cafe/model/category_model.dart';
import 'package:briewview/features/my_cafe/model/feature_tag_model.dart';
import 'package:briewview/features/my_cafe/model/create_cafe_request.dart';
import 'package:briewview/features/my_cafe/model/update_cafe_request.dart';
import 'package:briewview/features/my_cafe/viewmodel/my_cafe_bloc.dart';
import 'package:briewview/features/my_cafe/viewmodel/my_cafe_event.dart';
import 'package:briewview/features/my_cafe/viewmodel/my_cafe_state.dart';

class MyCafeFormPage extends StatefulWidget {
  final String? cafeId; // null for create, non-null for edit

  const MyCafeFormPage({
    super.key,
    this.cafeId,
  });

  @override
  State<MyCafeFormPage> createState() => _MyCafeFormPageState();
}

class _MyCafeFormPageState extends State<MyCafeFormPage> {
  late MyCafeBloc _myCafeBloc;
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
  CafeModel? _editingCafe;

  bool get _isEditing => widget.cafeId != null;

  @override
  void initState() {
    super.initState();
    _myCafeBloc = getIt<MyCafeBloc>();
    _loadData();
  }

  void _loadData() async {
    _myCafeBloc.add(LoadCategories());
    _myCafeBloc.add(LoadFeatureTags());
    
    if (_isEditing) {
      _myCafeBloc.add(LoadCafeById(widget.cafeId!));
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
    _myCafeBloc.close();
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
        create: (context) => _myCafeBloc,
        child: BlocListener<MyCafeBloc, MyCafeState>(
          listener: (context, state) {
            if (state is MyCafeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CategoriesLoaded) {
              _categories = state.categories;
            } else if (state is FeatureTagsLoaded) {
              _featureTags = state.featureTags;
            } else if (state is CafeLoaded) {
              _editingCafe = state.cafe;
              _populateForm(state.cafe);
            } else if (state is CafeCreated || state is CafeUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isEditing ? 'Update cafe success!' : 'Create cafe success!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop();
            }
          },
          child: BlocBuilder<MyCafeBloc, MyCafeState>(
            builder: (context, state) {
              if (state is MyCafeLoading && !_isEditing) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF5F1EB),
                  ),
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
            title: 'Cafe Images',
            icon: Icons.photo_camera,
            child: _buildImagePicker(),
          ),

          FormSectionWrapper(
            title: 'Basic Information',
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
            title: 'Pricing Information',
            icon: Icons.attach_money,
            child: PricingSection(
              priceMinController: _priceMinController,
              priceMaxController: _priceMaxController,
            ),
          ),

          FormSectionWrapper(
            title: 'Operating Hours',
            icon: Icons.access_time,
            child: ScheduleSection(
              openingHoursController: _openingTimeController,
              closingHoursController: _closingTimeController,
            ),
          ),

          FormSectionWrapper(
            title: 'Contact Information',
            icon: Icons.contact_phone,
            child: ContactInfoSection(
              hotlineController: _hotlineController,
              linkPageController: _linkPageController,
            ),
          ),

          FormSectionWrapper(
            title: 'Feature Tags',
            icon: Icons.local_offer,
            child: _buildFeatureTagSelector(),
          ),

          const SizedBox(height: 30),
          _buildSubmitButton(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }


  Widget _buildSubmitButton() {
  return BlocBuilder<MyCafeBloc, MyCafeState>(
    builder: (context, state) {
      final isLoading = state is MyCafeCreating || state is MyCafeUpdating;
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
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF8B4513),
                ),
              )
               : Text(
                    _isEditing ? 'Cập nhật cafe' : 'Tạo cafe',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Images of cafe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B4513),
              ),
            ),
          ),
          if (_selectedImages.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImages[index],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add images'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFeatureTagSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Feature tags',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B4513),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _featureTags.map((tag) {
                final isSelected = _selectedFeatureTagIds.contains(tag.id);
                return FilterChip(
                  label: Text(tag.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFeatureTagIds.add(tag.id);
                      } else {
                        _selectedFeatureTagIds.remove(tag.id);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF8B4513),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _populateForm(CafeModel cafe) {
    _nameController.text = cafe.name;
    _addressController.text = cafe.address;
    _descriptionController.text = cafe.description;
    _priceMinController.text = cafe.priceMin.toString();
    _priceMaxController.text = cafe.priceMax.toString();
    _openingTimeController.text = cafe.openingTime;
    _closingTimeController.text = cafe.closingTime;
    _linkPageController.text = cafe.linkPage ?? '';
    _hotlineController.text = cafe.hotline ?? '';
    
    // Set selected category
    _selectedCategory = _categories.firstWhere(
      (cat) => cat.id == cafe.categoryId,
      orElse: () => _categories.first,
    );
    
    // Set selected feature tags
    _selectedFeatureTagIds = cafe.selectedFeatureTagIds ?? [];
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    setState(() {
      _selectedImages.addAll(images.map((image) => File(image.path)));
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) return;

    if (_isEditing && _editingCafe != null) {
      final request = UpdateCafeRequest(
        cafeId: _editingCafe!.id!,
        categoryId: _selectedCategory!.id,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim(),
        priceMin: int.parse(_priceMinController.text.trim()),
        priceMax: int.parse(_priceMaxController.text.trim()),
        openingTime: _openingTimeController.text.trim(),
        closingTime: _closingTimeController.text.trim(),
        linkPage: _linkPageController.text.trim().isEmpty ? null : _linkPageController.text.trim(),
        hotline: _hotlineController.text.trim().isEmpty ? null : _hotlineController.text.trim(),
        cafeFeatureTags: _selectedFeatureTagIds,
      );
      _myCafeBloc.add(UpdateCafe(request, mediaFiles: _selectedImages.isNotEmpty ? _selectedImages : null));
    } else {
      final request = CreateCafeRequest(
        categoryId: _selectedCategory!.id,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim(),
        priceMin: int.parse(_priceMinController.text.trim()),
        priceMax: int.parse(_priceMaxController.text.trim()),
        openingTime: _openingTimeController.text.trim(),
        closingTime: _closingTimeController.text.trim(),
        linkPage: _linkPageController.text.trim().isEmpty ? null : _linkPageController.text.trim(),
        hotline: _hotlineController.text.trim().isEmpty ? null : _hotlineController.text.trim(),
        selectedFeatureTagIds: _selectedFeatureTagIds,
      );
      _myCafeBloc.add(CreateCafe(request, mediaFiles: _selectedImages.isNotEmpty ? _selectedImages : null));
    }
  }
}
