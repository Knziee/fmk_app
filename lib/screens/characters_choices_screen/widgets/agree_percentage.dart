import 'package:flutter/material.dart';
import '../../../themes/app_colors.dart';

class AgreePercentage extends StatefulWidget {
  final int percentage;

  const AgreePercentage({super.key, required this.percentage});

  @override
  State<AgreePercentage> createState() => _AgreePercentageState();
}

class _AgreePercentageState extends State<AgreePercentage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: 105,
        height: 27,
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: AppColors.black20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: widget.percentage.toDouble()),
              duration: const Duration(milliseconds: 1200),
              builder: (context, value, child) {
                return Text(
                  "${value.toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
            const Icon(Icons.thumb_up, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            const Text(
              'agree',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
