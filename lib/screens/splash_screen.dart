// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:azmonrahnamayi/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:azmonrahnamayi/providers/test_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // انیمیشن برای نوار پیشرفت
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // انیمیشن برای پالس آیکون‌ها
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);

    // بارگذاری سوالات و نتایج با تایم‌اوت
    _loadDataWithTimeout();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadDataWithTimeout() async {
    try {
      // تنظیم تایم‌اوت 10 ثانیه‌ای برای بارگذاری داده‌ها
      await Future.any([
        _loadData(),
        Future.delayed(const Duration(seconds: 10)),
      ]);

      // اگر تایم‌اوت رخ داده باشد
      if (mounted && _isLoading) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'بارگذاری داده‌ها بیش از حد طول کشید. لطفاً اتصال اینترنت خود را بررسی کنید.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'خطا در بارگذاری داده‌ها: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadData() async {
    try {
      final testProvider = Provider.of<TestProvider>(context, listen: false);
      await testProvider.loadQuestions();
      await testProvider.loadTestResults();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // شروع انیمیشن پیشرفت
        _progressController.forward();

        // رفتن به صفحه اصلی پس از اتمام انیمیشن
        _progressController.addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFF6B00),
              const Color(0xFFFF9E44),
              Colors.orange.shade100,
            ],
          ),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;
              final screenWidth = constraints.maxWidth;
              final isTablet = screenWidth > 600;

              // محاسبه اندازه‌های واکنش‌گرا
              final iconSize = isTablet ? 120.0 : 80.0;
              final titleFontSize = isTablet ? 36.0 : 28.0;
              final subtitleFontSize = isTablet ? 22.0 : 18.0;
              final containerPadding = isTablet ? 30.0 : 20.0;
              final spacing = isTablet ? 40.0 : 30.0;
              final loadingSize = isTablet ? 60.0 : 50.0;

              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // لوگوی برنامه با انیمیشن پالس (تغییر یافته)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(containerPadding),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              // تغییر: جایگزینی آیکون با تصویر
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: iconSize,
                                  height: iconSize,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: spacing),
                      Text(
                        'آزمون آیین نامه رانندگی',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'نسخه حرفه‌ای',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: spacing),

                      // بخش لودینگ با انیمیشن پیشرفت
                      if (_isLoading)
                        Column(
                          children: [
                            // نوار پیشرفت سفارشی
                            Container(
                              width: screenWidth * 0.6,
                              height: isTablet ? 12 : 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: AnimatedBuilder(
                                animation: _progressAnimation,
                                builder: (context, child) {
                                  return FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: _progressAnimation.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // انیمیشن نقطه‌های لودینگ
                                _buildLoadingDot(isTablet, 0),
                                SizedBox(width: 8),
                                _buildLoadingDot(isTablet, 1),
                                SizedBox(width: 8),
                                _buildLoadingDot(isTablet, 2),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'در حال بارگذاری داده‌ها...',
                              style: TextStyle(
                                fontSize: subtitleFontSize * 0.8,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        )
                      else if (_hasError)
                        // بخش خطا با انیمیشن
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            key: const ValueKey('error'),
                            children: [
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                      size: loadingSize,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1,
                                ),
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(
                                    fontSize: subtitleFontSize * 0.8,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                    _hasError = false;
                                    _errorMessage = '';
                                  });
                                  _loadDataWithTimeout();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFFF6B00),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.1,
                                    vertical: screenHeight * 0.02,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'تلاش مجدد',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        // بخش موفقیت با انیمیشن
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: loadingSize,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ساخت نقطه‌های لودینگ با انیمیشن
  Widget _buildLoadingDot(bool isTablet, int index) {
    final dotSize = isTablet ? 12.0 : 10.0;
    final delay = index * 0.2;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
