import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/basic_button.dart';
import '../themes/app_colors.dart';
import '../models/character.dart';
import '../services/character_services.dart';
import '../providers/user_selection.dart';

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

    final elapsed = DateTime.now().difference(startTime);
    final minLoadingDuration = Duration(seconds: 2);

    if (elapsed < minLoadingDuration) {
      await Future.delayed(minLoadingDuration - elapsed);
    }

    setState(() {
      characters = fetched;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Loading your options...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24),
                      CircularProgressIndicator(),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Text(
                        'These are your\noptions!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
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
                            _buildAvatar(
                              characters[0].imageUrl,
                              Offset(-50, 115),
                              248,
                            ),
                          if (characters.length > 1)
                            _buildAvatar(
                              characters[1].imageUrl,
                              Offset(-15, -120),
                              201,
                            ),
                          if (characters.length > 2)
                            _buildAvatar(
                              characters[2].imageUrl,
                              Offset(120, 0),
                              114,
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 62.0),
                      child: BasicButton(
                        text: 'Continue',
                        onPressed: () {
                          // Navigate to the next screen or perform an action
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String imageUrl, Offset offset, double size) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white40, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.black25,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
