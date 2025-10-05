import 'package:flutter/material.dart';

class ScheduleSection extends StatelessWidget {
  final TextEditingController openingHoursController;
  final TextEditingController closingHoursController;

  const ScheduleSection({
    super.key,
    required this.openingHoursController,
    required this.closingHoursController,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: openingHoursController,
            label: 'Opening Hours (HH:MM)',
            validator: (value) => value?.isEmpty == true ? 'Enter opening hours' : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField(
            controller: closingHoursController,
            label: 'Closing Hours (HH:MM)',
            validator: (value) => value?.isEmpty == true ? 'Enter closing hours' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
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