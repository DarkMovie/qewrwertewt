// lib/screens/question_count_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:azmonrahnamayi/screens/question_screen.dart';

class QuestionCountScreen extends StatefulWidget {
  const QuestionCountScreen({super.key});

  @override
  State<QuestionCountScreen> createState() => _QuestionCountScreenState();
}

class _QuestionCountScreenState extends State<QuestionCountScreen>
    with TickerProviderStateMixin {
  int selectedQuestionCount = 20;
  final TextEditingController _textController = TextEditingController();

  late AnimationController _animationController;
  late AnimationController _sliderController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _textController.text = selectedQuestionCount.toString();

    // انیمیشن‌ها
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _sliderController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _sliderController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // نقاط شکست هوشمندانه برای ریسپانسیو
    final isSmallPhone = screenWidth < 360;
    final isMediumPhone = screenWidth >= 360 && screenWidth < 600;
    final isTablet = screenWidth >= 600;
    final isSmallHeight = screenHeight < 700;

    // محاسبه اندازه‌های ریسپانسیو
    final titleFontSize = isTablet ? 24.0 : (isMediumPhone ? 22.0 : 20.0);
    final cardTitleSize = isTablet ? 20.0 : (isMediumPhone ? 18.0 : 17.0);
    final inputFontSize = isTablet ? 18.0 : (isMediumPhone ? 16.0 : 15.0);
    final buttonFontSize = isTablet ? 18.0 : (isMediumPhone ? 16.0 : 15.0);
    final quickSelectFontSize = isTablet ? 16.0 : (isMediumPhone ? 15.0 : 14.0);
    final padding = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 16.0);
    final spacing = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 16.0);
    final cardRadius = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 18.0);
    final buttonHeight = isSmallHeight ? 50.0 : 56.0;
    final quickSelectHeight = isSmallHeight ? 36.0 : 40.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تعداد سوالات',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: spacing * 0.8),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'تعداد سوالات مورد نظر را انتخاب کنید',
                    style: GoogleFonts.vazirmatn(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: spacing * 1.5),

                // کارت انتخاب تعداد سوالات
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: EdgeInsets.all(padding * 0.8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade800.withOpacity(0.9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(cardRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'تعداد سوالات',
                            style: GoogleFonts.vazirmatn(
                              fontSize: cardTitleSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: spacing * 0.8),

                          // اسلایدر انتخاب تعداد سوالات
                          Column(
                            children: [
                              AnimatedBuilder(
                                animation: _sliderController,
                                builder: (context, child) {
                                  return SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      inactiveTrackColor: Colors.grey.shade300,
                                      thumbColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      overlayColor: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.1),
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 12.0,
                                      ),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                            overlayRadius: 24.0,
                                          ),
                                      valueIndicatorColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      valueIndicatorTextStyle:
                                          GoogleFonts.vazirmatn(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      showValueIndicator:
                                          ShowValueIndicator.onlyForDiscrete,
                                    ),
                                    child: Slider(
                                      value: selectedQuestionCount.toDouble(),
                                      min: 1,
                                      max: 300,
                                      divisions: 299,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedQuestionCount = value.toInt();
                                          _textController.text =
                                              selectedQuestionCount.toString();
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: spacing * 0.5),

                              // نمایش تعداد انتخاب شده
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: padding * 0.6,
                                      vertical: padding * 0.3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      '$selectedQuestionCount سوال',
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: inputFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: spacing * 0.8),

                          // ورودی متنی برای تعداد سوالات
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _textController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'تعداد سوالات (1-300)',
                                    labelStyle: GoogleFonts.vazirmatn(
                                      fontSize: inputFontSize * 0.9,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 2.0,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: padding * 0.6,
                                      vertical: padding * 0.5,
                                    ),
                                  ),
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: inputFontSize,
                                  ),
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      int? num = int.tryParse(value);
                                      if (num != null &&
                                          num >= 1 &&
                                          num <= 300) {
                                        setState(() {
                                          selectedQuestionCount = num;
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: spacing * 1.5),

                // دکمه شروع آزمون
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(
                            testType: 'random',
                            questionCount: selectedQuestionCount,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      foregroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      padding: EdgeInsets.symmetric(
                        vertical: buttonHeight * 0.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: buttonFontSize),
                        SizedBox(width: 8),
                        Text(
                          'شروع آزمون',
                          style: GoogleFonts.vazirmatn(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: spacing),

                // پیشنهادات سریع
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'پیشنهادات سریع:',
                        style: GoogleFonts.vazirmatn(
                          fontSize: inputFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: spacing * 0.4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildQuickSelectButton(
                            10,
                            quickSelectFontSize,
                            quickSelectHeight,
                          ),
                          _buildQuickSelectButton(
                            20,
                            quickSelectFontSize,
                            quickSelectHeight,
                          ),
                          _buildQuickSelectButton(
                            30,
                            quickSelectFontSize,
                            quickSelectHeight,
                          ),
                          _buildQuickSelectButton(
                            50,
                            quickSelectFontSize,
                            quickSelectHeight,
                          ),
                          _buildQuickSelectButton(
                            100,
                            quickSelectFontSize,
                            quickSelectHeight,
                          ),
                          _buildQuickSelectButton(
                            150,
                            quickSelectFontSize,
                            quickSelectHeight,
                          ),
                          _buildQuickSelectButton(
                            200,
                            quickSelectFontSize,
                            quickSelectHeight,
                          ),
                          _buildQuickSelectButton(
                            300,
                            quickSelectFontSize,
                            quickSelectHeight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSelectButton(int count, double fontSize, double height) {
    final isSelected = selectedQuestionCount == count;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedQuestionCount = count;
            _textController.text = count.toString();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.white.withOpacity(0.2),
          foregroundColor: isSelected ? Colors.white : Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: height * 0.25,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isSelected
                ? BorderSide.none
                : BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          elevation: isSelected ? 3 : 1,
        ),
        child: Text(
          '$count',
          style: GoogleFonts.vazirmatn(
            fontSize: fontSize,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
