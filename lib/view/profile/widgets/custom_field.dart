// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../cors/theme/app_colors.dart';

class CustomField extends StatelessWidget {
  final String label;
  final String hint;
  final Color iconColor;
  final TextEditingController controller;
  bool grow;
  final String? Function(String?)? validator;
  CustomField(
      {super.key,
      required this.label,
      required this.hint,
      this.iconColor = const Color(0xFFFF7043),
      required this.grow,
      required this.validator,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: grow ? 5 : 1,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: grow ? TextInputType.multiline : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.darkOrage, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
