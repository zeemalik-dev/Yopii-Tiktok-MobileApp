import 'package:flutter/material.dart';

class ImageBox extends StatelessWidget {
  final double width;
  final double height;
  final String imagePath;
  ImageBox(
      {required this.width, required this.height, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
