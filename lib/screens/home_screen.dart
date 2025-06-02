import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pick_category_screen.dart';
import '../themes/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 160),
              Text(
                'F*, Marry,\nKill',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 220),
              _buildMenuButton(context, 'Single Player', enabled: true),
              const SizedBox(height: 16),
              _buildMenuButton(context, 'Multiplayer', enabled: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String label, {
    required bool enabled,
  }) {
    return SizedBox(
      width: 276,
      height: 84,
      child: ElevatedButton(
        onPressed: enabled
            ? () {
                if (label == 'Single Player') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PickCategoryScreen(),
                    ),
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: enabled
                ? const LinearGradient(
                    colors: [
                      AppColors.lightOrangeButton,
                      AppColors.darkOrangeButton,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : LinearGradient(
                    colors: [Colors.grey.shade400, Colors.grey.shade600],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 28,
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
