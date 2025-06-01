import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../themes/app_colors.dart';
import '../providers/user_selection.dart';

class PickCategoryScreen extends StatefulWidget {
  const PickCategoryScreen({super.key});

  @override
  State<PickCategoryScreen> createState() => _PickCategoryScreenState();
}

class _PickCategoryScreenState extends State<PickCategoryScreen> {
  String? selectedGender;

  String get genderLabel {
    switch (selectedGender) {
      case 'women':
        return 'Choose between women';
      case 'men':
        return 'Choose between men';
      case 'both':
        return 'Choose between both';
      default:
        return 'Choose a gender';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Animes', 'emoji': '✨'},
      {'title': 'Games', 'emoji': '🎮'},
      {'title': 'Cinema', 'emoji': '🎬'},
      {'title': 'TV', 'emoji': '📺'},
      {'title': 'Athletes', 'emoji': '🏅'},
      {'title': 'Create Category', 'emoji': '+'},
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightOrange, AppColors.darkPink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: const Offset(-30, 0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Pick a category',
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(25),
                      borderColor: AppColors.white20,
                      selectedBorderColor: AppColors.white20,
                      fillColor: AppColors.darkPink20,
                      selectedColor: Colors.white,
                      color: Colors.white,
                      isSelected: [
                        selectedGender == 'women',
                        selectedGender == 'both',
                        selectedGender == 'men',
                      ],
                      onPressed: (index) {
                        final gender = ['women', 'both', 'men'][index];

                        setState(() {
                          selectedGender = gender;
                        });

                        Provider.of<UserSelection>(
                          context,
                          listen: false,
                        ).setGender(gender);
                      },
                      children: [
                        Container(
                          color: AppColors.white10,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: const Text(
                            '♀️',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          color: AppColors.white10,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: const Text(
                            '♀️♂️',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          color: AppColors.white10,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: const Text(
                            '♂️',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      genderLabel,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryCard(
                      title: category['title']!,
                      emoji: category['emoji']!,
                      isCreate: category['title'] == 'Create Category',
                      onTap: () {
                        final provider = Provider.of<UserSelection>(
                          context,
                          listen: false,
                        );
                        provider.setCategory(
                          category['title']!,
                          category['emoji']!,
                        );

                        // Exemplo: navegar para próxima tela
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => const NextScreen()));
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String emoji;
  final bool isCreate;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.title,
    required this.emoji,
    this.isCreate = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // permite ripple sobre gradiente
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        splashColor: Colors.white24, // cor do toque
        onTap: onTap,
        child: Container(
          width: 158,
          height: 158,
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.white20, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: isCreate ? 0 : 8),
              Text(
                emoji,
                style: GoogleFonts.poppins(
                  fontSize: 48,
                  fontWeight: isCreate ? FontWeight.w200 : FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isCreate ? 20 : 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
