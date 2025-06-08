import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void _goToNextCharacter() {
    if (currentCharacterIndex < characters.length - 1) {
      setState(() {
        currentCharacterIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlayersChoicesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final character = characters[currentCharacterIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  character['name'] ?? '',
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
                  imageProvider: AssetImage(
                    'assets/images/avatars/$currentAvatarIndex.png',
                  ),
                  offset: Offset.zero,
                  size: screenWidth * 0.4,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                height: screenHeight * 0.4,
                child: ListView.builder(
                  itemCount: mockPlayers.length,
                  itemBuilder: (context, index) {
                    final player = mockPlayers[index];
                    final choices = player['choices'] as Map<String, String>;
                    final currentId = characters[currentCharacterIndex]['id'];

                    String? emoji;
                    if (choices['f'] == currentId) {
                      emoji = '🍆';
                    } else if (choices['m'] == currentId) {
                      emoji = '💍';
                    } else if (choices['k'] == currentId) {
                      emoji = '🪦';
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: PlayerCard(
                        currentAvatarIndex: player['currentAvatarIndex'],
                        playerName: player['name'],
                        isCurrentPlayer: player['isCurrentPlayer'] ?? false,
                        icon: emoji != null
                            ? Text(emoji, style: const TextStyle(fontSize: 22))
                            : null,
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
