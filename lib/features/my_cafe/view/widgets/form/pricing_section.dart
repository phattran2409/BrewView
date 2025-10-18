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
            label: 'Giá nhỏ nhất',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bắt buộc';
              }

              final price = int.tryParse(value);
              if (price == null) {
                return 'Định dạng số không hợp lệ';
              }

              // Backend rule: PriceMin >= 0
              if (price < 0) {
                return 'Phải lớn hơn 0';
              }

              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField(
            controller: priceMaxController,
            label: 'Giá lớn nhất',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bắt buộc';
              }

              final maxPrice = int.tryParse(value);
              if (maxPrice == null) {
                return 'Định dạng số không hợp lệ';
              }

              // Backend rule: PriceMax >= 0
              if (maxPrice < 0) {
                return 'Phải lớn hơn 0';
              }

              // Backend rule: PriceMax >= PriceMin
              final minPriceText = priceMinController.text;
              if (minPriceText.isNotEmpty) {
                final minPrice = int.tryParse(minPriceText);
                if (minPrice != null && maxPrice < minPrice) {
                  return 'Phải lớn hơn giá nhỏ nhất';
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
