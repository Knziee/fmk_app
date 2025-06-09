import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/player.dart';
import '../../providers/lobby_provider.dart';
import '../../providers/user_selection.dart';
import '../../widgets/avatar_circle.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/basic_button.dart';
import '../../widgets/player_card.dart';
import '../players_choices_screen/player_choices_screen.dart';

class CharacterVotesScreen extends StatefulWidget {
  const CharacterVotesScreen({super.key});

  @override
  State<CharacterVotesScreen> createState() => _CharacterVotesScreenState();
}

class _CharacterVotesScreenState extends State<CharacterVotesScreen> {
  int currentCharacterIndex = 0;
  List<Player> players = [];
  bool isLoading = true;
  int visibleCount = 0;

  @override
  void initState() {
    super.initState();
    _loadVotes();
  }

  Future<void> _loadVotes() async {
    final lobbyProvider = context.read<LobbyProvider>();

    await lobbyProvider.fetchFinalResults();
    final fetchedPlayers = lobbyProvider.players;

    setState(() {
      players = fetchedPlayers;
      isLoading = false;
      visibleCount = 0;
    });

    _startRevealAnimation(fetchedPlayers.length);
  }

  void _startRevealAnimation(int total) async {
    for (int i = 0; i < total; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        visibleCount++;
      });
    }
  }

  void _goToNextCharacter() {
    final userSelection = context.read<UserSelection>();

    if (currentCharacterIndex < userSelection.selectedCharacters.length - 1) {
      setState(() {
        currentCharacterIndex++;
        visibleCount = 0;
      });
      _startRevealAnimation(players.length);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlayersChoicesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final userSelection = context.watch<UserSelection>();
    final characters = userSelection.selectedCharacters;

    if (isLoading || characters.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final character = characters[currentCharacterIndex];

    return Scaffold(
      body: BackgroundGradient(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.12),
              Center(
                child: Text(
                  character.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.05,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: AvatarCircle(
                  imageProvider: NetworkImage(character.imageUrl),
                  offset: Offset.zero,
                  size: screenWidth * 0.4,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                height: screenHeight * 0.4,
                child: ListView.builder(
                  itemCount: visibleCount,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final choices = player.choices;
                    final currentId = character.id;
                    final currentPlayerId = context
                        .read<LobbyProvider>()
                        .localPlayer
                        ?.id;
                    final isCurrentPlayer = player.id == currentPlayerId;

                    String? emoji;
                    if (choices['f'] == currentId) {
                      emoji = '🍆';
                    } else if (choices['marry'] == currentId) {
                      emoji = '💍';
                    } else if (choices['kill'] == currentId) {
                      emoji = '🪦';
                    }

                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 40, end: 0),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, double offsetX, child) {
                        return Opacity(
                          opacity: 1,
                          child: Transform.translate(
                            offset: Offset(offsetX, 0),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: PlayerCard(
                          currentAvatarIndex: player.avatarId,
                          playerName: player.nickname,
                          isCurrentPlayer: isCurrentPlayer,
                          icon: emoji != null
                              ? Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 22),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              BasicButton(
                text: currentCharacterIndex < characters.length - 1
                    ? 'Next'
                    : 'Complete results',
                onPressed: _goToNextCharacter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
