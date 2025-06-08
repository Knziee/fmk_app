import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pick_avatar_screen/pick_avatar_screen.dart';
import '../pick_category/pick_category_screen.dart';
import '../../themes/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightOrange, AppColors.darkPink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.2),
              Text(
                'F*, Marry,\nKill',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: screenHeight * 0.25),
              _buildMenuButton(
                context,
                'Single Player',
                screenWidth: screenWidth,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildMenuButton(
                context,
                'Multiplayer',
                screenWidth: screenWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String label, {
    required double screenWidth,
  }) {
    return SizedBox(
      width: screenWidth * 0.7,
      height: screenWidth * 0.2,
      child: ElevatedButton(
        onPressed: () {
          if (label == 'Single Player') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PickCategoryScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PickAvatarScreen(),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.06),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.lightOrangeButton, AppColors.darkOrangeButton],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(screenWidth * 0.06),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
