import 'package:flutter/material.dart';

class ContactInfoSection extends StatelessWidget {
  final TextEditingController hotlineController;
  final TextEditingController linkPageController;

  const ContactInfoSection({
    super.key,
    required this.hotlineController,
    required this.linkPageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: hotlineController,
            validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            if (value != null && value.isNotEmpty) {
              final phoneRegex = RegExp(r'^\+?\d{7,15}$');
              if (!phoneRegex.hasMatch(value)) {
                return 'Hotline must be 7-15 digits, may have + at first';
              }
            }
            return null;
          },
         
          label: 'Hotline',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: linkPageController,
         validator: (value) {
            if (value != null && value.isNotEmpty) {
              final uri = Uri.tryParse(value);
              if (uri == null || !uri.hasAbsolutePath) {
                return 'LinkPage must be a valid URL';
              }
            }
            return null;
          },
          label: 'Link Page',
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}