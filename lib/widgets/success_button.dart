import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class SuccessButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final bool isWide; 

  const SuccessButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 46,
    this.isWide = false, 
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isWide ? 324.0 : (width ?? 200.0);
    final gradientColors = [
      AppColors.lightGreenButton,
      AppColors.mediumGreenButton,
    ];

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
