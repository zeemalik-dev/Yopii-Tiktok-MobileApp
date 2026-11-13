import 'dart:io';

import 'package:flutter/material.dart';

class FileCircleAvatar extends StatelessWidget {
  final File imageFile;
  final double radius;
  const FileCircleAvatar(
      {super.key, required this.imageFile, this.radius = 45});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.orangeAccent,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: ClipOval(
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
            errorBuilder: (context, error, stack) => const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
