import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class AvatarCircle extends StatelessWidget {
  final ImageProvider imageProvider;
  final Offset offset;
  final double size;

  const AvatarCircle({
    super.key,
    required this.imageProvider,
    required this.offset,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white40, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.black25,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
