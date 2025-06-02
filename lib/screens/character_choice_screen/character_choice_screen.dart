import 'package:flutter/material.dart';
import 'package:fmk_app/models/character.dart';
import 'package:fmk_app/screens/home_screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../widgets/background_gradient.dart';
import '../options_screen/options_screen.dart';
import '../../providers/user_selection.dart';
import '../../themes/app_colors.dart';
import '../../widgets/basic_button.dart';
import '../../widgets/success_button.dart';
import '../../services/character_services.dart';
import './widgets/choice_card.dart';
import './widgets/character_modal.dart';

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

  @override
  Widget build(BuildContext context) {
    final userSelection = Provider.of<UserSelection>(context);
    final characters = userSelection.selectedCharacters;
    final allChoicesMade =
        userSelection.fChoice != null &&
        userSelection.mChoice != null &&
        userSelection.kChoice != null;

    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Column(
            children: [
              _buildBackButton(),
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
              _buildChoiceCards(userSelection, characters),
              const Spacer(),
              _buildBottomButtons(userSelection, allChoicesMade),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Transform.translate(
        offset: const Offset(10, 15),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildChoiceCards(
    UserSelection userSelection,
    List<Character> characters,
  ) {
    return Column(
      children: [
        ChoiceCard(
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
          percentageText: userSelection.fChoice != null
              ? calculateVotePercentage(userSelection.fChoice!, 'f')
              : '0%',
        ),
        ChoiceCard(
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
          percentageText: userSelection.mChoice != null
              ? calculateVotePercentage(userSelection.mChoice!, 'm')
              : '0%',
        ),
        ChoiceCard(
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
          percentageText: userSelection.kChoice != null
              ? calculateVotePercentage(userSelection.kChoice!, 'k')
              : '0%',
        ),
      ],
    );
  }

  Widget _buildBottomButtons(UserSelection userSelection, bool allChoicesMade) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 34.0),
      child: votingCompleted
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SuccessButton(text: 'Play Again', onPressed: _handlePlayAgain),
                const SizedBox(width: 16),
                BasicButton(
                  text: 'Quit',
                  onPressed: _handleQuit,
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
                if (isLoading) _buildLoadingIndicator(),
              ],
            ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Positioned(
      child: Container(
        width: 324,
        height: 46,
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
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
        return CharacterModal(
          characters: characters,
          type: type,
          currentSelected: currentSelected,
          onConfirm: (character) {
            final selection = Provider.of<UserSelection>(
              context,
              listen: false,
            );
            if (character != null) {
              selection.selectCharacter(type, character);
            } else {
              selection.removeCharacter(type);
            }
          },
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

      await Future.delayed(Duration(milliseconds: 50));
      setState(() => agreeOpacity = 1.0);

      final userSelection = context.read<UserSelection>();
      final categoryId = userSelection.selectedCategoryId!;
      final characterService = CharacterService();

      await _registerVotes(userSelection, characterService, categoryId);

      setState(() {
        votingCompleted = true;
        isLoading = false;
      });
    } catch (e) {
      logger.e('❌ Error registering votes', error: e);
      _showErrorSnackbar(context);
      setState(() {
        showAgree = false;
        isLoading = false;
      });
    }
  }

  Future<void> _registerVotes(
    UserSelection userSelection,
    CharacterService service,
    String categoryId,
  ) async {
    final futures = <Future>[];

    if (userSelection.fChoice != null) {
      futures.add(
        service.incrementVote(categoryId, userSelection.fChoice!.id, 'f'),
      );
    }

    if (userSelection.mChoice != null) {
      futures.add(
        service.incrementVote(categoryId, userSelection.mChoice!.id, 'marry'),
      );
    }

    if (userSelection.kChoice != null) {
      futures.add(
        service.incrementVote(categoryId, userSelection.kChoice!.id, 'kill'),
      );
    }

    await Future.wait(futures);
  }

  void _showErrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Failed to register votes. Please try again.'),
        backgroundColor: Colors.red,
        action: SnackBarAction(label: 'Retry', onPressed: _handleDonePressed),
      ),
    );
  }

  void _handlePlayAgain() {
    context.read<UserSelection>().resetSelections();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OptionsScreen()),
    );
    setState(() {
      votingCompleted = false;
      showAgree = false;
    });
  }

  void _handleQuit() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
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
}
