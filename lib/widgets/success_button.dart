import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class SuccessButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final bool isWide;
  final Widget? child;

  const SuccessButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 46,
    this.isWide = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isWide ? 324.0 : (width ?? 200.0);
    final gradientColors = [
      AppColors.lightGreenButton,
      AppColors.mediumGreenButton,
    ];

    return Material(
      borderRadius: BorderRadius.circular(15),
      color: Colors.transparent, 
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onPressed,
          child: Container(
            width: buttonWidth,
            height: height,
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
        ),
      ),
    );
  }
}
