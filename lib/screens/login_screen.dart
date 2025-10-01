// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:azmonrahnamayi/models/user.dart';
import 'package:azmonrahnamayi/services/user_service.dart';
import 'package:azmonrahnamayi/screens/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _userService = UserService();
  bool _isLoading = false;

  late AnimationController _animationController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // انیمیشن‌های ورود
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _shimmerController, curve: Curves.ease));

    _animationController.forward();
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _animationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // بستن کیبورد هنگام ارسال فرم
      FocusScope.of(context).unfocus();

      setState(() {
        _isLoading = true;
      });

      final user = User(
        username: _usernameController.text.trim(),
        fullName: _fullNameController.text.trim(),
      );

      await _userService.saveUser(user);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    }
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
    final isSmallScreen = screenHeight < 700;

    // محاسبه اندازه‌های ریسپانسیو
    final logoSize = isTablet ? 120.0 : (isMediumPhone ? 100.0 : 90.0);
    final iconSize = isTablet ? 60.0 : (isMediumPhone ? 50.0 : 45.0);
    final titleSize = isTablet ? 28.0 : (isMediumPhone ? 24.0 : 22.0);
    final subtitleSize = isTablet ? 18.0 : (isMediumPhone ? 16.0 : 14.0);
    final inputFontSize = isTablet ? 16.0 : (isMediumPhone ? 15.0 : 14.0);
    final buttonFontSize = isTablet ? 18.0 : (isMediumPhone ? 16.0 : 15.0);
    final helperFontSize = isTablet ? 12.0 : (isMediumPhone ? 11.0 : 10.0);
    final padding = isTablet ? 32.0 : (isMediumPhone ? 24.0 : 20.0);
    final spacing = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 16.0);
    final borderRadius = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 16.0);
    final fieldHeight = isTablet ? 60.0 : (isMediumPhone ? 56.0 : 52.0);
    final buttonHeight = isTablet ? 60.0 : (isMediumPhone ? 56.0 : 52.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Colors.orange.shade300,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      mediaQuery.size.height -
                      mediaQuery.padding.top -
                      mediaQuery.padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // لوگو و عنوان با انیمیشن
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            children: [
                              // لوگو با افکت شاینر
                              AnimatedBuilder(
                                animation: _shimmerAnimation,
                                builder: (context, child) {
                                  return Container(
                                    width: logoSize,
                                    height: logoSize,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: iconSize,
                                        ),
                                        // افکت شاینر
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              logoSize / 2,
                                            ),
                                            child: Transform.translate(
                                              offset: Offset(
                                                _shimmerAnimation.value *
                                                    logoSize,
                                                0,
                                              ),
                                              child: Container(
                                                width: logoSize,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.white.withOpacity(
                                                        0.5,
                                                      ),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: spacing),
                              // عنوان با افکت شاینر
                              AnimatedBuilder(
                                animation: _shimmerAnimation,
                                builder: (context, child) {
                                  return Stack(
                                    children: [
                                      Text(
                                        'خوش آمدید',
                                        style: GoogleFonts.vazirmatn(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: titleSize,
                                        ),
                                      ),
                                      // افکت شاینر روی متن
                                      Positioned.fill(
                                        child: ClipRect(
                                          child: Transform.translate(
                                            offset: Offset(
                                              _shimmerAnimation.value * 200,
                                              0,
                                            ),
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.white.withOpacity(
                                                      0.4,
                                                    ),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              Text(
                                'لطفاً اطلاعات خود را وارد کنید',
                                style: GoogleFonts.vazirmatn(
                                  color: Colors.white70,
                                  fontSize: subtitleSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),

                      // فرم ورود با طراحی مدرن
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxWidth: isTablet ? 500 : 400,
                          ),
                          padding: EdgeInsets.all(padding),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade800.withOpacity(0.8)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(borderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // فیلد نام کاربری با طراحی جدید
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'نام کاربری (انگلیسی)',
                                    hintText: 'مثلا: john123',
                                    labelStyle: GoogleFonts.vazirmatn(
                                      fontSize: inputFontSize,
                                    ),
                                    hintStyle: GoogleFonts.vazirmatn(
                                      fontSize: inputFontSize,
                                      color: Colors.grey.shade500,
                                    ),
                                    helperStyle: GoogleFonts.vazirmatn(
                                      fontSize: helperFontSize,
                                      color: Colors.grey.shade600,
                                    ),
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 2.0,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                    helperText:
                                        'فقط حروف انگلیسی و اعداد، حداقل ۴ کاراکتر',
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: fieldHeight * 0.3,
                                      horizontal: 16,
                                    ),
                                  ),
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: inputFontSize,
                                  ),
                                  textAlign: TextAlign
                                      .left, // چینش چپ به چپ برای متن انگلیسی
                                  textDirection: TextDirection
                                      .ltr, // جهت متن انگلیسی از چپ به راست
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z0-9]'),
                                    ),
                                  ],
                                  validator: (value) {
                                    if (value != null) {
                                      return User.validateUsername(
                                        value.trim(),
                                      );
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    // تبدیل به حروف کوچک
                                    if (value.isNotEmpty) {
                                      _usernameController.value =
                                          TextEditingValue(
                                            text: value.toLowerCase(),
                                            selection: TextSelection.collapsed(
                                              offset: value.length,
                                            ),
                                          );
                                    }
                                  },
                                ),
                                SizedBox(height: spacing),

                                // فیلد نام کامل با طراحی جدید
                                TextFormField(
                                  controller: _fullNameController,
                                  decoration: InputDecoration(
                                    labelText: 'نام کامل (فارسی)',
                                    hintText: 'مثلا: علی محمدی',
                                    labelStyle: GoogleFonts.vazirmatn(
                                      fontSize: inputFontSize,
                                    ),
                                    hintStyle: GoogleFonts.vazirmatn(
                                      fontSize: inputFontSize,
                                      color: Colors.grey.shade500,
                                    ),
                                    helperStyle: GoogleFonts.vazirmatn(
                                      fontSize: helperFontSize,
                                      color: Colors.grey.shade600,
                                    ),
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.badge,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 2.0,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                    helperText: 'فقط حروف فارسی',
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: fieldHeight * 0.3,
                                      horizontal: 16,
                                    ),
                                  ),
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: inputFontSize,
                                  ),
                                  textAlign: TextAlign
                                      .right, // چینش راست به راست برای متن فارسی
                                  textDirection: TextDirection
                                      .rtl, // جهت متن فارسی از راست به چپ
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value != null) {
                                      return User.validateFullName(
                                        value.trim(),
                                      );
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: spacing),

                                // دکمه ورود با طراحی جدید
                                SizedBox(
                                  width: double.infinity,
                                  height: buttonHeight,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      shadowColor: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.3),
                                      elevation: 8,
                                    ),
                                    child: _isLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Text(
                                                'در حال ورود...',
                                                style: GoogleFonts.vazirmatn(
                                                  fontSize: buttonFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            'ورود',
                                            style: GoogleFonts.vazirmatn(
                                              fontSize: buttonFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
