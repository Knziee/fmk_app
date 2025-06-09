import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import 'avatar_circle.dart';
import '../models/character.dart';

class PlayerChoicesCard extends StatelessWidget {
  final String playerName;
  final List<Character> characters;
  final Map<String, String> choices;
  final bool isCurrentPlayer;

  const PlayerChoicesCard({
    super.key,
    required this.playerName,
    required this.characters,
    required this.choices,
    this.isCurrentPlayer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentPlayer
            ? Border.all(color: AppColors.white20, width: 2)
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              playerName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                children: characters.asMap().entries.map((entry) {
                  final index = entry.key;
                  final character = entry.value;

                  Widget? emojiWidget;
                  if (choices['f'] == character.id) {
                    emojiWidget = const Text(
                      '🍆',
                      style: TextStyle(fontSize: 20),
                    );
                  } else if (choices['marry'] == character.id) {
                    emojiWidget = const Text(
                      '💍',
                      style: TextStyle(fontSize: 20),
                    );
                  } else if (choices['kill'] == character.id) {
                    emojiWidget = const Text(
                      '🪦',
                      style: TextStyle(fontSize: 20),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < characters.length - 1 ? 12 : 0,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AvatarCircle(
                          imageProvider: NetworkImage(character.imageUrl),
                          offset: Offset.zero,
                          size: 48,
                        ),
                        if (emojiWidget != null)
                          Positioned(left: -4, bottom: -4, child: emojiWidget),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
