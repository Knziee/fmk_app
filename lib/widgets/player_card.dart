import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class PlayerCard extends StatelessWidget {
  final int currentAvatarIndex;
  final String playerName;
  final Widget? icon;
  final bool isCurrentPlayer;

  const PlayerCard({
    super.key,
    required this.currentAvatarIndex,
    required this.playerName,
    this.icon,
    this.isCurrentPlayer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(15),
        border: isCurrentPlayer
            ? Border.all(color: AppColors.white20, width: 2)
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Image.asset(
            'assets/images/avatars/$currentAvatarIndex.png',
            width: 45,
            height: 45, 
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              playerName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (icon != null) icon!,
        ],
      ),
    );
  }
}
