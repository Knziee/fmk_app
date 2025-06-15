import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/lobby_provider.dart';
import '../../providers/user_selection.dart';
import '../../services/character_services.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/cancel_button.dart';
import '../../widgets/player_card.dart';
import '../../widgets/success_button.dart';
import '../options_screen/options_screen.dart';
import 'widgets/lobby_code_input.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  bool isLoading = false;
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final lobbyProvider = Provider.of<LobbyProvider>(context);
    final players = lobbyProvider.players;
    final currentPlayerId = lobbyProvider.localPlayer?.id;

    final currentPlayer = players.firstWhere(
      (p) => p.id == currentPlayerId,
      orElse: () => lobbyProvider.localPlayer!,
    );
    final isReady = currentPlayer.ready;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final allReady = players.isNotEmpty && players.every((p) => p.ready);

      if (allReady && !_navigated) {
        _navigated = true;

        final userSelection = Provider.of<UserSelection>(
          context,
          listen: false,
        );

        if (lobbyProvider.isHost) {
          setState(() => isLoading = true);

          final gender = lobbyProvider.selectedGender;
          final categoryId = lobbyProvider.categoryId;

          if (gender != null && categoryId != null) {
            final characterService = CharacterService();

            final fetched = await characterService
                .fetchRandomCharactersByValues(
                  gender: gender,
                  categoryId: categoryId,
                );

            await Future.wait(
              fetched.map((character) {
                final image = NetworkImage(character.imageUrl);
                final completer = Completer();

                image
                    .resolve(const ImageConfiguration())
                    .addListener(
                      ImageStreamListener(
                        (info, _) => completer.complete(),
                        onError: (error, stackTrace) => completer.complete(),
                      ),
                    );

                return completer.future;
              }),
            );

            await lobbyProvider.saveRandomCharacters(fetched);
            userSelection.setCharacters(fetched);
          } else {
            print('Error while looking for options.');
          }

          setState(() => isLoading = false);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OptionsScreen()),
        );
      }
    });

    return Scaffold(
      body: BackgroundGradient(
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.04,
              left: screenWidth * 0.02,
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: screenWidth * 0.08,
                ),
                onPressed: () {
                  final lobbyProvider = Provider.of<LobbyProvider>(
                    context,
                    listen: false,
                  );
                  lobbyProvider.leaveLobby();
                  Navigator.pop(context);
                },
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
                  Center(
                    child: LobbyCodeInput(code: lobbyProvider.lobbyCode ?? ''),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  SizedBox(
                    height: screenHeight * 0.4,
                    child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final isCurrentPlayer = player.id == currentPlayerId;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: PlayerCard(
                            currentAvatarIndex: player.avatarId,
                            playerName: player.nickname,
                            isCurrentPlayer: isCurrentPlayer,
                            icon: player.ready
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  Center(
                    child: lobbyProvider.isHost && isLoading
                        ? Column(
                            children: [
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Setting things up...',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : isReady
                        ? CancelButton(
                            text: 'Cancel',
                            isWide: true,
                            onPressed: () async {
                              await lobbyProvider.setReady(false);
                            },
                          )
                        : SuccessButton(
                            text: 'Ready',
                            isWide: true,
                            onPressed: () async {
                              await lobbyProvider.setReady(true);
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
