import 'package:flutter/material.dart';
import 'package:briewview/core/utils/validators.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final double height;
  final double borderRadius;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.height = 8.0,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final strengthScore = Validators.getPasswordStrengthScore(password);
    final strengthLevel = Validators.getPasswordStrengthLevel(password);
    final checks = Validators.checkPasswordStrength(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bar
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: strengthScore / 100,
            child: Container(
              decoration: BoxDecoration(
                color: _getStrengthColor(strengthScore),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Strength text
        Row(
          children: [
            Text(
              'Độ mạnh mật khẩu: ',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              strengthLevel,
              style: TextStyle(
                color: _getStrengthColor(strengthScore),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '$strengthScore%',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Requirements checklist
        _buildRequirementItem('Ít nhất 8 ký tự', checks['length']!),
        _buildRequirementItem('Chữ in hoa (A-Z)', checks['uppercase']!),
        _buildRequirementItem('Chữ thường (a-z)', checks['lowercase']!),
        _buildRequirementItem('Số (0-9)', checks['numbers']!),
        _buildRequirementItem('Ký tự đặc biệt (!@#\$%^&*)', checks['special']!),
      ],
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? Colors.green : Colors.white54,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.white70 : Colors.white54,
              fontSize: 12,
              decoration: isMet ? null : TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStrengthColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.deepOrange;
    if (score >= 20) return Colors.red;
    return Colors.red.shade900;
  }
}
