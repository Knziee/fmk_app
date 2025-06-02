import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class BasicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const BasicButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 324,
    this.height = 46,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.lightPinkButton, AppColors.mediumPinkButton],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
