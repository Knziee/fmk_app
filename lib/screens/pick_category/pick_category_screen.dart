import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../../themes/app_colors.dart';
import '../../../providers/user_selection.dart';
import '../../../models/categories.dart';
import '../../../services/categories_services.dart';
import '../options_screen.dart';

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
    if (isLoading) {
      return const Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.lightOrange, AppColors.darkPink],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 1.0],
            ),
          ),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final displayCategories = categories ?? [];

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
                      isSelected: genderOptions
                          .map((g) => selectedGender == g['value'])
                          .toList(),
                      onPressed: (index) {
                        final gender = genderOptions[index]['value'] as String;
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            g['label']!,
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
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
                  itemCount: displayCategories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == displayCategories.length) {
                      return _CategoryCard(
                        title: 'Create Category',
                        emoji: '+',
                        isCreate: true,
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
                      onTap: () {
                        Provider.of<UserSelection>(
                          context,
                          listen: false,
                        ).setCategory(category.id);
                        if (selectedGender != null) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OptionsScreen(),
                              ),
                            );
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select a gender first.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        splashColor: Colors.white24,
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
