// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azmonrahnamayi/providers/test_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter/animation.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final String testType;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.testType,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _progressController.forward();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    final testProvider = Provider.of<TestProvider>(context, listen: false);
    final message = testProvider.getMotivationalMessage();
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(now);

    return Scaffold(
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;
              final screenWidth = constraints.maxWidth;
              final isTablet = screenWidth > 600;

              // محاسبه اندازه‌های واکنش‌گرا
              final titleFontSize = isTablet ? 32.0 : 28.0;
              final circleSize = isTablet ? 220.0 : 180.0;
              final percentageFontSize = isTablet ? 52.0 : 46.0;
              final scoreFontSize = isTablet ? 24.0 : 20.0;
              final tableFontSize = isTablet ? 16.0 : 14.0;
              final buttonFontSize = isTablet ? 18.0 : 16.0;
              final paddingValue = isTablet ? 24.0 : 16.0;
              final spacing = isTablet ? 24.0 : 16.0;

              return Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    'نتیجه آزمون',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(paddingValue),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              // دایره نمره با انیمیشن
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: circleSize,
                                    height: circleSize,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _progressAnimation,
                                    builder: (context, child) {
                                      return SizedBox(
                                        width: circleSize * 0.9,
                                        height: circleSize * 0.9,
                                        child: CircularProgressIndicator(
                                          value: _progressAnimation.value,
                                          strokeWidth: 12,
                                          backgroundColor: Colors.white
                                              .withOpacity(0.3),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                _getMessageColor(percentage),
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    '${percentage.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: percentageFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: spacing),
                              Text(
                                'نمره شما: ${widget.score} از ${widget.totalQuestions}',
                                style: TextStyle(
                                  fontSize: scoreFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: spacing * 0.8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: paddingValue * 0.8,
                                  vertical: paddingValue * 0.4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getMessageColor(
                                    percentage,
                                  ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    fontSize: scoreFontSize - 2,
                                    fontWeight: FontWeight.bold,
                                    color: _getMessageColor(percentage),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: spacing),

                              // جدول نتایج بهبود یافته
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // هدر جدول
                                    Container(
                                      padding: EdgeInsets.all(
                                        paddingValue * 0.8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'جزئیات نتایج',
                                            style: TextStyle(
                                              fontSize: tableFontSize + 2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              formattedDate,
                                              style: TextStyle(
                                                fontSize: tableFontSize - 2,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // بدنه جدول با کارت‌های زیبا
                                    Padding(
                                      padding: EdgeInsets.all(
                                        paddingValue * 0.6,
                                      ),
                                      child: Column(
                                        children: [
                                          // کارت تعداد سوالات
                                          _buildResultCard(
                                            icon: Icons.quiz,
                                            title: 'تعداد سوالات',
                                            value: '${widget.totalQuestions}',
                                            iconColor: Colors.blue,
                                            fontSize: tableFontSize,
                                            isTablet: isTablet,
                                          ),

                                          SizedBox(height: spacing * 0.5),

                                          // کارت پاسخ صحیح
                                          _buildResultCard(
                                            icon: Icons.check_circle,
                                            title: 'پاسخ صحیح',
                                            value: '${widget.score}',
                                            iconColor: Colors.green,
                                            fontSize: tableFontSize,
                                            isTablet: isTablet,
                                          ),

                                          SizedBox(height: spacing * 0.5),

                                          // کارت پاسخ غلط
                                          _buildResultCard(
                                            icon: Icons.cancel,
                                            title: 'پاسخ غلط',
                                            value:
                                                '${widget.totalQuestions - widget.score}',
                                            iconColor: Colors.red,
                                            fontSize: tableFontSize,
                                            isTablet: isTablet,
                                          ),

                                          SizedBox(height: spacing * 0.5),

                                          // کارت درصد موفقیت
                                          _buildResultCard(
                                            icon: Icons.percent,
                                            title: 'درصد موفقیت',
                                            value:
                                                '${percentage.toStringAsFixed(1)}%',
                                            iconColor: _getMessageColor(
                                              percentage,
                                            ),
                                            fontSize: tableFontSize,
                                            isTablet: isTablet,
                                            isBold: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: spacing),

                              // دکمه‌های اقدام
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Share.share(
                                          'من در آزمون آیین نامه رانندگی امتیاز ${widget.score} از ${widget.totalQuestions} را کسب کردم! $message',
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.02,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 3,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.share,
                                            size: buttonFontSize,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'اشتراک گذاری',
                                            style: TextStyle(
                                              fontSize: buttonFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.04),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).popUntil((route) => route.isFirst);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.black,
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.02,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 3,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.home,
                                            size: buttonFontSize,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'بازگشت به خانه',
                                            style: TextStyle(
                                              fontSize: buttonFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ساخت کارت نتایج
  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required double fontSize,
    required bool isTablet,
    bool isBold = false,
  }) {
    final cardPadding = isTablet ? 16.0 : 12.0;
    final iconSize = isTablet ? 28.0 : 24.0;
    final titleSize = isTablet ? 18.0 : 16.0;
    final valueSize = isTablet ? 20.0 : 18.0;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(cardPadding * 0.8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          SizedBox(width: cardPadding),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueSize,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                    color: isBold ? iconColor : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMessageColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return Colors.blue;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}
