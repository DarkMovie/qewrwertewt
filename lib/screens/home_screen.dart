// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azmonrahnamayi/providers/test_provider.dart';
import 'package:azmonrahnamayi/providers/theme_provider.dart';
import 'package:azmonrahnamayi/screens/about_screen.dart';
import 'package:azmonrahnamayi/screens/booklet_test_screen.dart';
import 'package:azmonrahnamayi/screens/history_screen.dart';
import 'package:azmonrahnamayi/screens/question_screen.dart';
import 'package:azmonrahnamayi/screens/question_count_screen.dart'; // اضافه کردن import جدید
import 'package:azmonrahnamayi/utils/constants.dart';
import 'package:azmonrahnamayi/widgets/styled_button.dart';
import 'package:azmonrahnamayi/widgets/booklet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // بارگذاری سوالات و نتایج در اسپلش اسکرین انجام می‌شود
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final testProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;
              final screenWidth = constraints.maxWidth;
              final isTablet = screenWidth > 600;

              // محاسبه اندازه‌های واکنش‌گرا
              final headerPadding = isTablet ? 30.0 : 20.0;
              final headerVerticalPadding = isTablet ? 30.0 : 24.0;
              final sectionSpacing = isTablet ? 30.0 : 20.0;
              final gridPadding = isTablet ? 24.0 : 16.0;
              final gridSpacing = isTablet ? 16.0 : 12.0;
              final buttonSpacing = isTablet ? 20.0 : 16.0;
              final titleFontSize = isTablet ? 28.0 : 24.0;
              final subtitleFontSize = isTablet ? 18.0 : 16.0;
              final sectionTitleFontSize = isTablet ? 24.0 : 20.0;
              final badgeFontSize = isTablet ? 16.0 : 14.0;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(
                      context,
                      themeProvider,
                      headerPadding,
                      headerVerticalPadding,
                      titleFontSize,
                      subtitleFontSize,
                    ),
                    SizedBox(height: sectionSpacing),
                    _buildRandomTestCard(context, isTablet),
                    SizedBox(height: sectionSpacing),
                    _buildBookletsSection(
                      context,
                      isTablet,
                      sectionTitleFontSize,
                      badgeFontSize,
                      gridPadding,
                      gridSpacing,
                      screenHeight,
                    ),
                    SizedBox(height: sectionSpacing),
                    _buildActionButtons(context, buttonSpacing, isTablet),
                    SizedBox(height: sectionSpacing),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeProvider themeProvider,
    double horizontalPadding,
    double verticalPadding,
    double titleFontSize,
    double subtitleFontSize,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  themeProvider.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Colors.white,
                  size: titleFontSize * 0.8,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
          SizedBox(height: verticalPadding * 0.3),
          Text(
            'آماده آزمون آیین نامه هستید؟',
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRandomTestCard(BuildContext context, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 30.0 : 20.0),
      child: StyledButton(
        title: 'آزمون تصادفی',
        subtitle: 'سوالات به صورت تصادفی از همه دفترچه‌ها',
        icon: Icons.shuffle,
        fontSize: isTablet ? 20.0 : 18.0,
        onTap: () {
          // به جای رفتن مستقیم به QuestionScreen، ابتدا به QuestionCountScreen برو
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuestionCountScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookletsSection(
    BuildContext context,
    bool isTablet,
    double sectionTitleFontSize,
    double badgeFontSize,
    double gridPadding,
    double gridSpacing,
    double screenHeight,
  ) {
    // محاسبه تعداد ستون‌های گرید بر اساس اندازه صفحه
    int crossAxisCount = 2;
    if (isTablet) {
      crossAxisCount = 3;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 30.0 : 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'دفترچه‌های آزمون',
                    style: TextStyle(
                      fontSize: sectionTitleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 12.0 : 8.0,
                  vertical: isTablet ? 6.0 : 4.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '10 دفترچه',
                  style: TextStyle(
                    fontSize: badgeFontSize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: gridSpacing),
        SizedBox(
          height: screenHeight * 0.5, // محدود کردن ارتفاع GridView
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: gridPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.2,
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return BookletCard(
                number: index + 1,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookletTestScreen(bookletNumber: index + 1),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    double buttonSpacing,
    bool isTablet,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 30.0 : 20.0),
      child: Row(
        children: [
          Expanded(
            child: StyledButton(
              title: 'نتایج آزمون‌ها',
              icon: Icons.assessment,
              fontSize: isTablet ? 18.0 : 16.0,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: buttonSpacing),
          Expanded(
            child: StyledButton(
              title: 'درباره ما',
              icon: Icons.info,
              backgroundColor: Colors.grey.shade300,
              textColor: Colors.black,
              fontSize: isTablet ? 18.0 : 16.0,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
