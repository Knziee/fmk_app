import 'package:flutter/material.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/basic_button.dart';
import '../../widgets/player_choices_card.dart';

class PlayersChoicesScreen extends StatefulWidget {
  const PlayersChoicesScreen({super.key});

  @override
  State<PlayersChoicesScreen> createState() => _PlayerChoicesScreenState();
}

class _PlayerChoicesScreenState extends State<PlayersChoicesScreen> {
  int currentAvatarIndex = 1;
  final int totalAvatars = 5;
  int currentCharacterIndex = 0;

  final List<Map<String, dynamic>> mockPlayers = [
    {
      'currentAvatarIndex': 1,
      'name': 'Bombardino',
      'isCurrentPlayer': false,
      'choices': {'f': 'c2', 'm': 'c3', 'k': 'c1'},
    },
    {
      'currentAvatarIndex': 2,
      'name': 'Thugthung',
      'isCurrentPlayer': true,
      'choices': {'f': 'c1', 'm': 'c2', 'k': 'c3'},
    },
    {
      'currentAvatarIndex': 3,
      'name': 'Sahurino',
      'isCurrentPlayer': false,
      'choices': {'f': 'c3', 'm': 'c1', 'k': 'c2'},
    },
    {
      'currentAvatarIndex': 4,
      'name': 'Crocodilo',
      'isCurrentPlayer': false,
      'choices': {'f': 'c1', 'm': 'c3', 'k': 'c2'},
    },
    {
      'currentAvatarIndex': 5,
      'name': 'Pastaroni',
      'isCurrentPlayer': false,
      'choices': {'f': 'c2', 'm': 'c1', 'k': 'c3'},
    },
  ];

  final List<Map<String, String>> characters = [
    {'id': 'c1', 'name': 'Scarlett Johansson'},
    {'id': 'c2', 'name': 'Emma Watson'},
    {'id': 'c3', 'name': 'Margot Robbie'},
  ];

  @override
  Widget build(BuildContext context) {
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
                  itemCount: mockPlayers.length,
                  itemBuilder: (context, index) {
                    final player = mockPlayers[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: PlayerChoicesCard(
                        playerName: player['name'],
                        characters: characters,
                        choices: player['choices'],
                        isCurrentPlayer: player['isCurrentPlayer'] ?? false,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 4),
              BasicButton(text: 'play again', onPressed: () => {}),
            ],
          ),
        ),
      ),
    );
  }
}
