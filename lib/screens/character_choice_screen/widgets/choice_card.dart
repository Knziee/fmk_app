import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../models/character.dart';
import '../../../themes/app_colors.dart';
import './agree_percentage.dart';

class ChoiceCard extends StatelessWidget {
  final String label;
  final String emoji;
  final Color borderColor;
  final Color footerColor;
  final VoidCallback onTap;
  final Character? selectedCharacter;
  final String type;
  final bool showAgree;
  final String percentageText;

  const ChoiceCard({
    super.key,
    required this.label,
    required this.emoji,
    required this.borderColor,
    required this.footerColor,
    required this.onTap,
    this.selectedCharacter,
    required this.type,
    required this.showAgree,
    required this.percentageText,
  });

  @override
  Widget build(BuildContext context) {
    final int percentageInt = int.parse(percentageText.replaceAll('%', ''));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 344,
        height: 170,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor.withOpacity(0.4), width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: selectedCharacter == null
                        ? _buildPlaceholder()
                        : _buildCharacterImage(),
                  ),
                  if (selectedCharacter != null && showAgree)
                    Positioned(
                      child: AgreePercentage(
                        percentage: percentageInt,
                      ), 
                    ),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Text(
      'Press to choose',
      style: TextStyle(color: AppColors.white80, fontSize: 16),
    );
  }

  Widget _buildCharacterImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Image.network(selectedCharacter!.imageUrl, fit: BoxFit.fill),
          ),
          Container(color: AppColors.black40),
          Image.network(selectedCharacter!.imageUrl, fit: BoxFit.contain),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: footerColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$emoji $label',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
