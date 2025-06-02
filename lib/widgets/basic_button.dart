import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class BasicButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final bool isShort;

  const BasicButton({
    super.key,
    this.text,
    required this.onPressed,
    this.width = 324,
    this.height = 46,
    this.isShort = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isShort ? width * 0.4 : width;

    return Material(
      borderRadius: BorderRadius.circular(15),
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.lightPinkButton, AppColors.mediumPinkButton],
          ),
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
              text ?? 'Continue',
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
