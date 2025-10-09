import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          child: _buildTimeField(
            context: context,
            controller: openingHoursController,
            label: 'Opening Hours',
            isOpeningTime: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }

              if (!_isValidTimeFormat(value)) {
                return 'Invalid time format (HH:MM)';
              }

              // Cross validation: OpeningTime must be less than ClosingTime
              final closingTime = closingHoursController.text;
              if (closingTime.isNotEmpty && _isValidTimeFormat(closingTime)) {
                if (!_isOpeningBeforeClosing(value, closingTime)) {
                  return 'before closing time';
                }
              }

              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTimeField(
            context: context,
            controller: closingHoursController,
            label: 'Closing Hours',
            isOpeningTime: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }

              if (!_isValidTimeFormat(value)) {
                return 'Invalid time format (HH:MM)';
              }

              // Cross validation: OpeningTime must be less than ClosingTime
              final openingTime = openingHoursController.text;
              if (openingTime.isNotEmpty && _isValidTimeFormat(openingTime)) {
                if (!_isOpeningBeforeClosing(openingTime, value)) {
                  return 'after opening time';
                }
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required bool isOpeningTime,
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
        keyboardType: TextInputType.datetime,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
          LengthLimitingTextInputFormatter(5), // HH:MM
          _TimeInputFormatter(),
        ],
        decoration: InputDecoration(
          labelText: label,
          hintText: 'HH:MM',
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.access_time),
            onPressed:
                () => _showTimePicker(context, controller, isOpeningTime),
          ),
        ),
      ),
    );
  }

  void _showTimePicker(
    BuildContext context,
    TextEditingController controller,
    bool isOpeningTime,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          _parseTimeString(controller.text) ??
          (isOpeningTime
              ? const TimeOfDay(hour: 8, minute: 0)
              : const TimeOfDay(hour: 22, minute: 0)),
    );

    if (picked != null) {
      controller.text = _formatTimeOfDay(picked);
    }
  }

  bool _isValidTimeFormat(String time) {
    final regex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$');
    return regex.hasMatch(time);
  }

  bool _isOpeningBeforeClosing(String openingTime, String closingTime) {
    final opening = _parseTimeString(openingTime);
    final closing = _parseTimeString(closingTime);

    if (opening == null || closing == null) return false;

    final openingMinutes = opening.hour * 60 + opening.minute;
    final closingMinutes = closing.hour * 60 + closing.minute;

    return openingMinutes < closingMinutes;
  }

  TimeOfDay? _parseTimeString(String time) {
    if (!_isValidTimeFormat(time)) return null;

    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// Custom input formatter for time
class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length == 2 && !text.contains(':')) {
      return TextEditingValue(
        text: '$text:',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    return newValue;
  }
}
