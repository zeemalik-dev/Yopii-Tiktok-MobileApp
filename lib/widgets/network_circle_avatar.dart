import 'package:flutter/material.dart';

class NetworkCircleAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  const NetworkCircleAvatar({super.key, this.imageUrl, this.radius = 45});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.orangeAccent,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: ClipOval(
          child: Image.network(
            imageUrl ??
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStltpfa69E9JTQOf5ZcyLGR8meBbxMFJxM0w&s",
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : const CircularProgressIndicator(),
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
