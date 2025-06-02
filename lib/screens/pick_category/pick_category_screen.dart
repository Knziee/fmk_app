import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../../themes/app_colors.dart';
import '../../../providers/user_selection.dart';
import '../../../models/categories.dart';
import '../../../services/categories_services.dart';
import '../../widgets/background_gradient.dart';
import '../options_screen/options_screen.dart';

class PickCategoryScreen extends StatefulWidget {
  const PickCategoryScreen({super.key});

  @override
  State<PickCategoryScreen> createState() => _PickCategoryScreenState();
}

const genderOptions = [
  {'label': '♀️', 'value': 'female'},
  {'label': '♀️♂️', 'value': 'both'},
  {'label': '♂️', 'value': 'male'},
];

class _PickCategoryScreenState extends State<PickCategoryScreen> {
  String? selectedGender;
  List<Category>? categories;
  bool isLoading = true;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final service = CategoryService();
      final fetchedCategories = await service.fetchCategories();

      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      logger.e('❌ Error loading categories', error: e);

      setState(() {
        categories = [];
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load categories. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String get genderLabel {
    switch (selectedGender) {
      case 'female':
        return 'Choose between women';
      case 'male':
        return 'Choose between men';
      case 'both':
        return 'Choose between both';
      default:
        return 'Choose a gender';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Scaffold(
        body: BackgroundGradient(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    final displayCategories = categories ?? [];

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
                      'Pick a category',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ToggleButtons(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.06,
                          ),
                          borderColor: AppColors.white20,
                          selectedBorderColor: AppColors.white20,
                          fillColor: AppColors.darkPink20,
                          selectedColor: Colors.white,
                          color: Colors.white,
                          isSelected: genderOptions
                              .map((g) => selectedGender == g['value'])
                              .toList(),
                          onPressed: (index) {
                            final gender =
                                genderOptions[index]['value'] as String;
                            setState(() {
                              selectedGender = gender;
                            });

                            Provider.of<UserSelection>(
                              context,
                              listen: false,
                            ).setGender(gender);
                          },
                          children: genderOptions.map((g) {
                            return Container(
                              color: AppColors.white10,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.01,
                              ),
                              child: Text(
                                g['label']!,
                                style: TextStyle(fontSize: screenWidth * 0.05),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          genderLabel,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: screenWidth * 0.04,
                        mainAxisSpacing: screenWidth * 0.04,
                        childAspectRatio: 1,
                      ),
                      itemCount: displayCategories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == displayCategories.length) {
                          return _CategoryCard(
                            title: 'Create Category',
                            emoji: '+',
                            isCreate: true,
                            screenWidth: screenWidth,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Create Category feature coming soon!',
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        final category = displayCategories[index];
                        return _CategoryCard(
                          title: category.title,
                          emoji: category.emoji,
                          screenWidth: screenWidth,
                          onTap: () {
                            Provider.of<UserSelection>(
                              context,
                              listen: false,
                            ).setCategory(category.id);
                            if (selectedGender != null) {
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const OptionsScreen(),
                                    ),
                                  );
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please select a gender first.',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String emoji;
  final bool isCreate;
  final double screenWidth;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.title,
    required this.emoji,
    required this.screenWidth,
    this.isCreate = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(screenWidth * 0.06),
      child: InkWell(
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
        splashColor: Colors.white24,
        onTap: onTap,
        child: Container(
          width: screenWidth * 0.4,
          height: screenWidth * 0.4,
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(screenWidth * 0.06),
            border: Border.all(color: AppColors.white20, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: isCreate ? 0 : screenWidth * 0.02),
              Text(
                emoji,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.12,
                  fontWeight: isCreate ? FontWeight.w200 : FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isCreate ? screenWidth * 0.05 : screenWidth * 0.06,
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
