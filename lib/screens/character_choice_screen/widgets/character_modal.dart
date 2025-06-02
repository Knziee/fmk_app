import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/character.dart';
import '../../../providers/user_selection.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/success_button.dart';

class CharacterModal extends StatefulWidget {
  final List<Character> characters;
  final String type;
  final Character? currentSelected;
  final Function(Character?) onConfirm;

  const CharacterModal({
    super.key,
    required this.characters,
    required this.type,
    required this.currentSelected,
    required this.onConfirm,
  });

  @override
  State<CharacterModal> createState() => _CharacterModalState();
}

class _CharacterModalState extends State<CharacterModal> {
  Character? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.currentSelected;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final userSelection = Provider.of<UserSelection>(context, listen: false);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.025,
            horizontal: screenWidth * 0.04,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...widget.characters.map(
                (character) => _buildCharacterItem(
                  character,
                  screenWidth,
                  screenHeight,
                  userSelection,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.025),
                child: SuccessButton(
                  text: selected != null ? "Confirm" : "Close",
                  onPressed: () {
                    widget.onConfirm(selected);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterItem(
    Character character,
    double screenWidth,
    double screenHeight,
    UserSelection userSelection,
  ) {
    final currentType = userSelection.getCharacterType(character.id);
    final alreadySelected = currentType != null;
    final emoji = {'f': '🍆', 'm': '💍', 'k': '🪦'}[currentType];
    final imageHeight = screenHeight * 0.25;

    return GestureDetector(
      onTap: () => _handleCharacterTap(character, currentType, alreadySelected),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: imageHeight,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColorFiltered(
                      colorFilter: selected == character
                          ? const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.multiply,
                            )
                          : const ColorFilter.matrix(<double>[
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ]),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Image.network(
                          character.imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(color: AppColors.black40),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth,
              height: imageHeight,
              child: Stack(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.matrix(
                      selected == character
                          ? <double>[
                              1,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ]
                          : <double>[
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ],
                    ),
                    child: Image.network(
                      character.imageUrl,
                      fit: BoxFit.contain,
                      width: screenWidth,
                      height: imageHeight,
                    ),
                  ),
                  if (selected == character)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.green40,
                            width: screenWidth * 0.018,
                          ),
                        ),
                      ),
                    ),
                  if (emoji != null)
                    Positioned(
                      top: screenHeight * 0.015,
                      right: screenWidth * 0.03,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.02,
                          ),
                        ),
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: screenWidth * 0.06),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                color: Colors.black54,
                child: Text(
                  character.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCharacterTap(
    Character character,
    String? currentType,
    bool alreadySelected,
  ) {
    if (alreadySelected && currentType != widget.type) {
      _showMoveConfirmationDialog(character, currentType!);
    } else {
      setState(() {
        selected = selected == character ? null : character;
      });
    }
  }

  void _showMoveConfirmationDialog(Character character, String currentType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Move Character?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_horiz, size: 40, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              "${character.name} is already selected as\n'${{'f': 'F*', 'm': 'Marry', 'k': 'Kill'}[currentType]}'",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Move to '${{'f': 'F*', 'm': 'Marry', 'k': 'Kill'}[widget.type]}'?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              final selection = Provider.of<UserSelection>(
                context,
                listen: false,
              );

              selection.removeCharacter(currentType);
              selection.selectCharacter(widget.type, character);

              Navigator.pop(context);
              setState(() {
                selected = character;
              });
            },
            child: const Text("Move", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
