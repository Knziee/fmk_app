import 'package:flutter/material.dart';
import '../../widgets/avatar_circle.dart';
import '../../widgets/background_gradient.dart';
import '../characters_choices_screen/characters_choices_screen.dart';
import 'package:provider/provider.dart';
import '../../widgets/basic_button.dart';
import '../../models/character.dart';
import '../../services/character_services.dart';
import '../../providers/user_selection.dart';
import 'dart:async';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  List<Character> characters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    final startTime = DateTime.now();

    final selection = Provider.of<UserSelection>(context, listen: false);
    final service = CharacterService();
    final fetched = await service.fetchRandomCharacters(selection);

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

    final elapsed = DateTime.now().difference(startTime);
    final minLoadingDuration = Duration(seconds: 2);
    if (elapsed < minLoadingDuration) {
      await Future.delayed(minLoadingDuration - elapsed);
    }

    setState(() {
      characters = fetched;
      isLoading = false;
    });

    selection.setCharacters(fetched);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Finding perfect options...',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.2,
                                child: CircularProgressIndicator(
                                  strokeWidth: 8,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: screenWidth * 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.03,
                        top: screenHeight * 0.04,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: screenWidth * 0.08,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth * 0.08),
                      child: Text(
                        'These are your\noptions!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.09,
                          height: 1.06,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (characters.isNotEmpty)
                            AvatarCircle(
                              imageProvider: NetworkImage(
                                characters[0].imageUrl,
                              ),
                              offset: Offset(
                                -screenWidth * 0.13,
                                screenHeight * 0.15,
                              ),
                              size: screenWidth * 0.62,
                            ),
                          if (characters.length > 1)
                            AvatarCircle(
                              imageProvider: NetworkImage(
                                characters[1].imageUrl,
                              ),
                              offset: Offset(
                                -screenWidth * 0.04,
                                -screenHeight * 0.15,
                              ),
                              size: screenWidth * 0.5,
                            ),
                          if (characters.length > 2)
                            AvatarCircle(
                              imageProvider: NetworkImage(
                                characters[2].imageUrl,
                              ),
                              offset: Offset(screenWidth * 0.3, 0),
                              size: screenWidth * 0.28,
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                      child: BasicButton(
                        text: 'Continue',
                        onPressed: () {
                          Provider.of<UserSelection>(
                            context,
                            listen: false,
                          ).resetSelections();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CharacterChoiceScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
