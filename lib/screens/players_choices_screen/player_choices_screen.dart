import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lobby_provider.dart';
import '../../providers/user_selection.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/basic_button.dart';
import '../../widgets/player_choices_card.dart';
// import '../lobby_screen/lobby_screen.dart';

class PlayersChoicesScreen extends StatefulWidget {
  const PlayersChoicesScreen({super.key});

  @override
  State<PlayersChoicesScreen> createState() => _PlayerChoicesScreenState();
}

class _PlayerChoicesScreenState extends State<PlayersChoicesScreen> {
  int visibleCount = 0;

  @override
  void initState() {
    super.initState();
    startRevealAnimation();
  }

  void startRevealAnimation() async {
    final totalPlayers = context.read<LobbyProvider>().players.length;

    for (int i = 0; i < totalPlayers; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        visibleCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lobbyProvider = context.watch<LobbyProvider>();
    final userSelection = context.watch<UserSelection>();

    final playersFromProvider = lobbyProvider.players;
    final charactersFromProvider = userSelection.selectedCharacters;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final listHeight = screenHeight * 0.8;

    return Scaffold(
      body: BackgroundGradient(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenWidth * 0.15),
              SizedBox(
                height: listHeight,
                child: ListView.builder(
                  itemCount: visibleCount,
                  itemBuilder: (context, index) {
                    final player = playersFromProvider[index];
                    final currentPlayerId = context
                        .read<LobbyProvider>()
                        .localPlayer
                        ?.id;
                    final isCurrentPlayer = player.id == currentPlayerId;

                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 20, end: 0),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, double offset, child) {
                        return Opacity(
                          opacity: 1,
                          child: Transform.translate(
                            offset: Offset(0, offset),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: PlayerChoicesCard(
                          playerName: player.nickname,
                          characters: charactersFromProvider,
                          choices: player.choices,
                          isCurrentPlayer: isCurrentPlayer,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 4),
              Opacity(
                opacity: 0.5,
                child: BasicButton(text: 'WIP', onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
