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
          label: 'Hotline',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: linkPageController,
          label: 'Link Page',
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
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
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}