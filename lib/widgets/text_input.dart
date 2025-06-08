import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const CustomTextInput({super.key, required this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8,
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.white10,
        border: Border.all(color: AppColors.white20, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.white40,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          border: InputBorder.none,
        ),
        cursorColor: Colors.white,
      ),
    );
  }
}
