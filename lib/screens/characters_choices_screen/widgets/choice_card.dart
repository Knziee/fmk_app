import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../models/character.dart';
import '../../../themes/app_colors.dart';
import 'agree_percentage.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;
    final cardHeight = cardWidth * 0.5;
    final footerHeight = cardHeight * 0.235;
    final int percentageInt = int.parse(percentageText.replaceAll('%', ''));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(vertical: cardHeight * 0.07),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor.withOpacity(0.4), width: 1),
          borderRadius: BorderRadius.circular(cardHeight * 0.12),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: selectedCharacter == null
                        ? _buildPlaceholder(cardHeight * 0.11)
                        : _buildCharacterImage(cardHeight * 0.12),
                  ),
                  if (selectedCharacter != null && showAgree)
                    Positioned(
                      child: AgreePercentage(percentage: percentageInt),
                    ),
                ],
              ),
            ),
            _buildFooter(footerHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(double fontSize) {
    return Text(
      'Press to choose',
      style: TextStyle(color: AppColors.white80, fontSize: fontSize),
    );
  }

  Widget _buildCharacterImage(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
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

  Widget _buildFooter(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: footerColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(height * 0.5),
          bottomRight: Radius.circular(height * 0.5),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$emoji $label',
              style: TextStyle(
                color: Colors.white,
                fontSize: height * 0.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
