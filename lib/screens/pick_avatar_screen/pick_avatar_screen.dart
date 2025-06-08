import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_selection.dart';
import '../../widgets/avatar_circle.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/basic_button.dart';
import '../../widgets/text_input.dart';
import '../select_mode_screen/select_mode_screen.dart';

class PickAvatarScreen extends StatefulWidget {
  const PickAvatarScreen({super.key});

  @override
  State<PickAvatarScreen> createState() => _PickAvatarScreenState();
}

class _PickAvatarScreenState extends State<PickAvatarScreen> {
  int currentAvatarIndex = 1;
  final int totalAvatars = 5;
  final TextEditingController _nicknameController = TextEditingController();
  bool isInputValid = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() {
      setState(() {
        isInputValid = _nicknameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _changeAvatar() {
    setState(() {
      currentAvatarIndex = currentAvatarIndex % totalAvatars + 1;
    });
  }

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
                      'Choose avatar and a nickname',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.095,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  Center(
                    child: Stack(
                      children: [
                        AvatarCircle(
                          imageProvider: AssetImage(
                            'assets/images/avatars/$currentAvatarIndex.png',
                          ),
                          offset: Offset.zero,
                          size: screenWidth * 0.7,
                          transparentBackground: true,
                        ),
                        Positioned(
                          bottom: 10,
                          right: 16,
                          child: GestureDetector(
                            onTap: _changeAvatar,
                            child: Container(
                              width: screenWidth * 0.14,
                              height: screenWidth * 0.14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Transform.rotate(
                                angle: 1.5708,
                                child: Icon(
                                  Icons.refresh,
                                  color: Colors.orange,
                                  size: screenWidth * 0.095,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  CustomTextInput(
                    hintText: 'YourNickNameHere',
                    controller: _nicknameController,
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  Opacity(
                    opacity: isInputValid ? 1.0 : 0.5,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                      child: BasicButton(
                        text: 'Continue',
                        onPressed: () {
                          if (!isInputValid) return;

                          final userSelection = Provider.of<UserSelection>(
                            context,
                            listen: false,
                          );
                          userSelection.setAvatarIndex(currentAvatarIndex);
                          userSelection.setNickname(
                            _nicknameController.text.trim(),
                          );
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
