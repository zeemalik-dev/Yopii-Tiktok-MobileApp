// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // optional for icons

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isGreyTransparent;
  Function()? onAddTap;

  // ignore: use_super_parameters
  CustomBottomNavBar(
      {Key? key,
      this.selectedIndex = 0,
      required this.onItemTapped,
      this.isGreyTransparent = false,
      this.onAddTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isGreyTransparent
            ? AppColors.backgroundTranparent.withOpacity(.6)
            : AppColors.primaryWhite,
        borderRadius: isGreyTransparent
            ? BorderRadius.all(Radius.circular(0))
            : BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
        boxShadow: isGreyTransparent
            ? []
            : [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Bottom Nav Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Iconsax.home_2, "Home", 0),
              _buildNavItem(Iconsax.message, "Chat", 1),
              const SizedBox(width: 60), // space for floating center button
              _buildNavItem(Iconsax.notification, "Notification", 2),
              _buildNavItem(Iconsax.user, "Profile", 3),
            ],
          ),

          // Floating Add Button
          Positioned(
            top: -30,
            child: GestureDetector(
              onTap: onAddTap,
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Color(0xfaFF5C2C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add,
                    color: AppColors.primaryWhite, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isSelected
                  ? AppColors.primaryOrange
                  : isGreyTransparent
                      ? AppColors.primaryWhite
                      : AppColors.primaryGrey,
              size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primaryOrange
                  : isGreyTransparent
                      ? AppColors.primaryWhite
                      : AppColors.primaryGrey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
