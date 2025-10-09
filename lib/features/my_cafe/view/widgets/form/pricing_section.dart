import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'required';
              }

              final price = int.tryParse(value);
              if (price == null) {
                return 'Invalid number format';
              }

              // Backend rule: PriceMin >= 0
              if (price < 0) {
                return 'greater than 0';
              }

              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField(
            controller: priceMaxController,
            label: 'Max Price',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'required';
              }

              final maxPrice = int.tryParse(value);
              if (maxPrice == null) {
                return 'Invalid number format';
              }

              // Backend rule: PriceMax >= 0
              if (maxPrice < 0) {
                return 'greater than 0';
              }

              // Backend rule: PriceMax >= PriceMin
              final minPriceText = priceMinController.text;
              if (minPriceText.isNotEmpty) {
                final minPrice = int.tryParse(minPriceText);
                if (minPrice != null && maxPrice < minPrice) {
                  return 'greater than min price';
                }
              }

              return null;
            },
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
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Only allow digits
        ],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixText: 'VND',
        ),
      ),
    );
  }
}
