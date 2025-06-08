import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/cancel_button.dart';
import '../../widgets/player_card.dart';
import '../../widgets/success_button.dart';
import '../character_votes_screen/character_votes_screen.dart';
import 'widgets/lobby_code_input.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final TextEditingController _codeController = TextEditingController();
  final List<Map<String, dynamic>> mockPlayers = [
    {
      'currentAvatarIndex': 1,
      'name': 'Bombardino',
      'isReady': true,
      'isCurrentPlayer': false,
    },
    {
      'currentAvatarIndex': 2,
      'name': 'Thugthung',
      'isReady': false,
      'isCurrentPlayer': true,
    },
    {
      'currentAvatarIndex': 3,
      'name': 'Sahurino',
      'isReady': false,
      'isCurrentPlayer': false,
    },
    {
      'currentAvatarIndex': 4,
      'name': 'Crocodilo',
      'isReady': true,
      'isCurrentPlayer': false,
    },
    {
      'currentAvatarIndex': 5,
      'name': 'Pastaroni',
      'isReady': false,
      'isCurrentPlayer': false,
    },
  ];
  bool isReadyButton = false;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() {
      setState(() {
        isInputValid = _codeController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  bool isInputValid = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BackgroundGradient(
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.04,
              left: screenWidth * 0.02,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: screenWidth * 0.08,
                ),
                onPressed: () => Navigator.pop(context),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                padding: EdgeInsets.zero,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  Center(
                    child: Text(
                      'Lobby',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.095,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(child: LobbyCodeInput(code: "ABC123XYZ")),
                  SizedBox(height: screenHeight * 0.06),
                  SizedBox(
                    height: screenHeight * 0.4,
                    child: ListView.builder(
                      itemCount: mockPlayers.length,
                      itemBuilder: (context, index) {
                        final player = mockPlayers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: PlayerCard(
                            currentAvatarIndex: player['currentAvatarIndex'],
                            playerName: player['name'],
                            isReady: player['isReady'],
                            isCurrentPlayer: player['isCurrentPlayer'] ?? false,
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  Center(
                    child: isReadyButton
                        ? CancelButton(
                            text: 'Cancel',
                            isWide: true,
                            onPressed: () {
                              setState(() {
                                isReadyButton = false;
                              });
                            },
                          )
                        : SuccessButton(
                            text: 'Ready',
                            isWide: true,
                            onPressed: () {
                              setState(() {
                                isReadyButton = true;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CharacterVotesScreen(),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
