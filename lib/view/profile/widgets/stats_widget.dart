import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  final String title;
  final String value;

  const StatsWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack)),
        const SizedBox(height: 2),
        Text(title,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
