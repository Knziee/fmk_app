import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_selection.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/basic_button.dart';
import '../../widgets/info_card.dart';
import '../../widgets/text_input.dart';

class SelectModeScreen extends StatefulWidget {
  const SelectModeScreen({super.key});

  @override
  State<SelectModeScreen> createState() => _SelectModeScreenState();
}

class _SelectModeScreenState extends State<SelectModeScreen> {
  final TextEditingController _codeController = TextEditingController();

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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  Center(
                    child: Text(
                      'Select Mode',
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
                    child: Text(
                      'How do you want to play?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  InfoCard(
                    icon: Icons.shuffle,
                    title: 'Random',
                    description:
                        'The persons are random but based on the category you choose!',
                    onTap: () {},
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Opacity(
                    opacity: 0.5,
                    child: InfoCard(
                      icon: Icons.how_to_reg,
                      title: 'By Choice',
                      description:
                          'Each turn everyone choose three persons from the selected you choose!',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.16),
                  Center(
                    child: Text(
                      'Or join a game with a code?',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextInput(hintText: '', controller: _codeController),
                  SizedBox(height: screenHeight * 0.04),
                  Opacity(
                    opacity: isInputValid ? 1.0 : 0.5,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                      child: BasicButton(
                        text: 'Join',
                        onPressed: () {
                          if (!isInputValid) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SelectModeScreen(),
                            ),
                          );
                        },
                      ),
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
