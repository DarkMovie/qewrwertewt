import 'package:flutter/material.dart';
import 'package:azmonrahnamayi/screens/home_screen.dart';
import 'package:azmonrahnamayi/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:azmonrahnamayi/providers/test_provider.dart';
import 'package:azmonrahnamayi/services/user_service.dart';

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
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();

    // کنترلرهای انیمیشن
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // تنظیم انیمیشن‌ها
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

    // شروع انیمیشن‌ها
    _animationController.forward();
    _pulseController.repeat(reverse: true);

    // بارگذاری داده‌ها با تاخیر حداقلی برای نمایش اسپلش
    _loadDataWithMinimumDelay();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadDataWithMinimumDelay() async {
    try {
      // حداقل 2 ثانیه نمایش اسپلش
      await Future.delayed(const Duration(seconds: 2));

      // بارگذاری داده‌ها
      await _loadData();

      // شروع انیمیشن پیشرفت
      _progressController.forward();

      // پس از اتمام انیمیشن، هدایت به صفحه مناسب
      _progressController.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          _navigateToNextScreen();
        }
      });
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

      // مرحله 1: بارگذاری داده‌های عمومی (سوالات) - همیشه انجام می‌شود
      await testProvider.loadQuestions();

      // مرحله 2: بررسی و بارگذاری داده‌های شخصی (نتایج آزمون)
      final isLoggedIn = await _userService.isLoggedIn();

      if (isLoggedIn) {
        await testProvider.loadTestResults();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      rethrow;
    }
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    // بررسی وضعیت ورود کاربر با تاخیر برای اطمینان از به‌روزرسانی توکن
    Future.delayed(const Duration(milliseconds: 300), () async {
      final isLoggedIn = await _userService.isLoggedIn();

      if (!mounted) return;

      if (!isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    // ریست کردن کنترلرها
    _progressController.reset();

    // تلاش مجدد برای بارگذاری داده‌ها
    _loadDataWithMinimumDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF6B00),
              const Color(0xFFFF9E44),
              Colors.orange.shade100,
            ],
            stops: const [0.0, 0.5, 1.0],
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

              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // لوگوی برنامه با افکت پالس
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
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: iconSize,
                                  height: iconSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.menu_book,
                                      size: iconSize,
                                      color: const Color(0xFFFF6B00),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: spacing),

                      // عنوان برنامه
                      Text(
                        'آزمون آیین نامه رانندگی',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),

                      // زیرعنوان
                      Text(
                        'نسخه حرفه‌ای',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.normal,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: spacing),

                      // بخش لودینگ
                      if (_isLoading)
                        Column(
                          children: [
                            // نوار پیشرفت
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
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.white70,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // متن لودینگ
                            Text(
                              'در حال بارگذاری داده‌ها...',
                              style: TextStyle(
                                fontSize: subtitleFontSize * 0.8,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        )
                      else if (_hasError)
                        // بخش خطا
                        Column(
                          children: [
                            // آیکون خطا
                            Container(
                              padding: EdgeInsets.all(isTablet ? 16 : 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: isTablet ? 60 : 50,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // متن خطا
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

                            // دکمه تلاش مجدد
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.white70],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _retryLoading,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: const Color(0xFFFF6B00),
                                  elevation: 0,
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
                            ),
                          ],
                        )
                      else
                        // بخش موفقیت
                        Column(
                          children: [
                            // آیکون موفقیت
                            Container(
                              padding: EdgeInsets.all(isTablet ? 16 : 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: isTablet ? 60 : 50,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // متن موفقیت
                            Text(
                              'بارگذاری با موفقیت انجام شد',
                              style: TextStyle(
                                fontSize: subtitleFontSize * 0.8,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
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
}
