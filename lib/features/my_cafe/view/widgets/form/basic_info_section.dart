import 'package:briewview/features/survey/model/category_model.dart';
import 'package:flutter/material.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController descriptionController;
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel?> onCategoryChanged;

  const BasicInfoSection({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.descriptionController,
    required this.categories,
    this.selectedCategory,
    required this.onCategoryChanged,
});

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategorySelector(),
        const SizedBox(height: 20),
        _buildTextField(
          controller: nameController,
          label: 'Cafe Name',
          validator: (value) => value?.isEmpty == true ? 'Please enter cafe name' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: addressController,
          label: 'Address',
          maxLines: 2,
          validator: (value) => value?.isEmpty == true ? 'Please enter address' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: descriptionController,
          label: 'Description',
          maxLines: 4,
          validator: (value) => value?.isEmpty == true ? 'Please enter description' : null,
        ),
      ],
    );
  }
  
  Widget _buildCategorySelector(){
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<CategoryModel>(
        value: selectedCategory,
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: categories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category.name),
          );
        }).toList(),
        onChanged: onCategoryChanged,
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

