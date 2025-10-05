import 'package:flutter/material.dart';

class PricingSection extends StatelessWidget {
  final TextEditingController priceMinController;
  final TextEditingController priceMaxController;

  const PricingSection({
    super.key,
    required this.priceMinController,
    required this.priceMaxController,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: priceMinController,
            label: 'Min Price',
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty == true ? 'Enter min price' : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField(
            controller: priceMaxController,
            label: 'Max Price',
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty == true ? 'Enter max price' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }){
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