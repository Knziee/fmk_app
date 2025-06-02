import 'package:flutter/material.dart';
import 'package:fmk_app/models/character.dart';
import 'package:fmk_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../options_screen.dart';
import '../../providers/user_selection.dart';
import '../../themes/app_colors.dart';
import '../../widgets/basic_button.dart';
import '../../widgets/success_button.dart';
import '../../services/character_services.dart';
import 'dart:ui';

class CharacterChoiceScreen extends StatefulWidget {
  const CharacterChoiceScreen({super.key});

  @override
  State<CharacterChoiceScreen> createState() => _CharacterChoiceState();
}

class _CharacterChoiceState extends State<CharacterChoiceScreen> {
  bool showAgree = false;
  bool votingCompleted = false;
  bool isLoading = false;
  double agreeOpacity = 0.0;
  final logger = Logger();

  Widget _buildChoiceCard({
    required String label,
    required String emoji,
    required Color borderColor,
    required Color footerColor,
    required VoidCallback onTap,
    Character? selectedCharacter,
    required String type,
    required bool showAgree,
  }) {
    String percentageText = '';
    if (selectedCharacter != null) {
      percentageText = calculateVotePercentage(selectedCharacter, type);
    }

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
                        ? Text(
                            'Press to choose',
                            style: TextStyle(
                              color: AppColors.white80,
                              fontSize: 16,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 12,
                                    sigmaY: 12,
                                  ),
                                  child: Image.network(
                                    selectedCharacter.imageUrl,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Container(color: AppColors.black40),
                                Image.network(
                                  selectedCharacter.imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),
                  ),

                  if (selectedCharacter != null && showAgree)
                    Positioned(
                      child: AnimatedOpacity(
                        opacity: agreeOpacity,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        child: Container(
                          width: 105,
                          height: 27,
                          decoration: BoxDecoration(
                            color: AppColors.black20,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: TweenAnimationBuilder<String>(
                            tween: StringTween(
                              begin: "0%",
                              end: percentageText,
                            ),
                            duration: Duration(milliseconds: 1000),
                            builder:
                                (
                                  BuildContext context,
                                  String value,
                                  Widget? child,
                                ) {
                                  return Center(
                                    // Use Center instead of alignment parameter
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.thumb_up,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'agree',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userSelection = Provider.of<UserSelection>(context);
    final characters = userSelection.selectedCharacters;
    final allChoicesMade =
        userSelection.fChoice != null &&
        userSelection.mChoice != null &&
        userSelection.kChoice != null;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightOrange, AppColors.darkPink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: const Offset(10, 15),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose a person to',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // F*
              _buildChoiceCard(
                label: 'F*',
                emoji: '🍆',
                borderColor: const Color(0xFFD63384),
                footerColor: const Color(0xFFD63384),
                onTap: () => _showCharacterModal(
                  context,
                  characters,
                  'f',
                  userSelection.fChoice,
                ),
                selectedCharacter: userSelection.fChoice,
                type: 'f',
                showAgree: showAgree,
              ),

              // Marry
              _buildChoiceCard(
                label: 'Marry',
                emoji: '💍',
                borderColor: const Color(0xFFFFB6C1),
                footerColor: const Color(0xFFFFB6C1),
                onTap: () => _showCharacterModal(
                  context,
                  characters,
                  'm',
                  userSelection.mChoice,
                ),
                selectedCharacter: userSelection.mChoice,
                type: 'm',
                showAgree: showAgree,
              ),

              // Kill
              _buildChoiceCard(
                label: 'Kill',
                emoji: '🪦',
                borderColor: const Color(0xFF5C5C5C),
                footerColor: const Color(0xFF5C5C5C),
                onTap: () => _showCharacterModal(
                  context,
                  characters,
                  'k',
                  userSelection.kChoice,
                ),
                selectedCharacter: userSelection.kChoice,
                type: 'k',
                showAgree: showAgree,
              ),
              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 34.0),
                child: votingCompleted
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SuccessButton(
                            text: 'Play Again',
                            onPressed: () {
                              context.read<UserSelection>().resetSelections();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OptionsScreen(),
                                ),
                              );
                              setState(() {
                                votingCompleted = false;
                                showAgree = false;
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          BasicButton(
                            text: 'Quit',
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            isShort: true,
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: allChoicesMade ? 1.0 : 0.5,
                            child: IgnorePointer(
                              ignoring: !allChoicesMade || isLoading,
                              child: SuccessButton(
                                text: 'Done',
                                isWide: true,
                                onPressed: _handleDonePressed,
                              ),
                            ),
                          ),
                          if (isLoading)
                            Positioned(
                              child: Container(
                                width: 324, // Mesma largura do botão wide
                                height: 46, // Mesma altura do seu botão
                                decoration: BoxDecoration(
                                  color: AppColors.black40,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCharacterModal(
    BuildContext context,
    List<Character> characters,
    String type,
    Character? currentSelected,
  ) {
    if (votingCompleted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.black80,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final userSelection = Provider.of<UserSelection>(
          context,
          listen: false,
        );
        Character? selected = currentSelected;

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
              left: 0,
              right: 0,
              bottom: 20,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...characters.map((character) {
                      final currentType = userSelection.getCharacterType(
                        character.id,
                      );

                      final alreadySelected = currentType != null;

                      final emoji = {
                        'f': '🍆',
                        'm': '💍',
                        'k': '🪦',
                      }[currentType];

                      return GestureDetector(
                        onTap: () {
                          if (alreadySelected && currentType != type) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Move Character?"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.swap_horiz,
                                      size: 40,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "${character.name} is already selected as\n'${{'f': 'F*', 'm': 'Marry', 'k': 'Kill'}[currentType]}'",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Move to '${{'f': 'F*', 'm': 'Marry', 'k': 'Kill'}[type]}'?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                    ),
                                    onPressed: () {
                                      final selection =
                                          Provider.of<UserSelection>(
                                            context,
                                            listen: false,
                                          );
                                      selection.moveCharacter(
                                        character.id,
                                        type,
                                      );
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Move",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            setState(() {
                              selected = selected == character
                                  ? null
                                  : character;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Stack(
                            children: [
                              Container(
                                width: screenWidth,
                                height: 206,
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
                                          imageFilter: ImageFilter.blur(
                                            sigmaX: 12,
                                            sigmaY: 12,
                                          ),
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
                                height: 206,
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
                                        height: 206,
                                      ),
                                    ),

                                    if (selected == character)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.green40,
                                              width: 7,
                                            ),
                                          ),
                                        ),
                                      ),

                                    if (emoji != null)
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            emoji,
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  color: Colors.black54,
                                  child: Text(
                                    character.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SuccessButton(
                        text: selected != null ? "Confirm" : "Close",
                        onPressed: () {
                          final selection = Provider.of<UserSelection>(
                            context,
                            listen: false,
                          );
                          if (selected != null) {
                            selection.selectCharacter(type, selected!);
                          } else {
                            selection.removeCharacter(type);
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleDonePressed() async {
    try {
      setState(() {
        isLoading = true;
        showAgree = true;
        agreeOpacity = 0.0;
      });

      final userSelection = context.read<UserSelection>();
      final categoryId = userSelection.selectedCategoryId!;
      final fChar = userSelection.fChoice;
      final marryChar = userSelection.mChoice;
      final killChar = userSelection.kChoice;

      await Future.delayed(Duration(milliseconds: 50));

      setState(() {
        agreeOpacity = 1.0;
      });
      final characterService = CharacterService();

      if (fChar != null) {
        await characterService.incrementVote(categoryId, fChar.id, 'f');
      }
      if (marryChar != null) {
        await characterService.incrementVote(categoryId, marryChar.id, 'marry');
      }
      if (killChar != null) {
        await characterService.incrementVote(categoryId, killChar.id, 'kill');
      }

      setState(() {
        votingCompleted = true;
        isLoading = false;
      });
    } catch (e) {
      logger.e('❌ Error registering votes', error: e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to register votes. Please try again.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _handleDonePressed,
            ),
          ),
        );
      }

      setState(() {
        showAgree = false;
        isLoading = false;
      });
    }
  }
}

String calculateVotePercentage(Character character, String type) {
  final votesMap = character.votes;

  final totalVotes = votesMap.values.fold<int>(0, (sum, v) => sum + v);

  if (totalVotes == 0) return '0%';

  final typeKey = typeMap(type);
  final typeVotes = votesMap[typeKey] ?? 0;

  final percentage = (typeVotes / totalVotes) * 100;

  return '${percentage.toStringAsFixed(0)}%';
}

String typeMap(String type) {
  switch (type) {
    case 'f':
      return 'f';
    case 'm':
      return 'marry';
    case 'k':
      return 'kill';
    default:
      return '';
  }
}

class StringTween extends Tween<String> {
  StringTween({super.begin, super.end});

  @override
  String lerp(double t) {
    if (begin == null || end == null) return '';

    // Para animação de porcentagem (remove o % para cálculo)
    if (begin!.endsWith('%') && end!.endsWith('%')) {
      final beginValue = double.parse(begin!.substring(0, begin!.length - 1));
      final endValue = double.parse(end!.substring(0, end!.length - 1));
      final currentValue = (beginValue + (endValue - beginValue) * t).round();
      return '$currentValue%';
    }

    // Padrão: retorna o valor final quando t >= 0.5
    return t < 0.5 ? begin! : end!;
  }
}
