// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:azmonrahnamayi/providers/test_provider.dart';
import 'package:azmonrahnamayi/providers/theme_provider.dart';
import 'package:azmonrahnamayi/screens/about_screen.dart';
import 'package:azmonrahnamayi/screens/booklet_test_screen.dart';
import 'package:azmonrahnamayi/screens/history_screen.dart';
import 'package:azmonrahnamayi/screens/question_screen.dart';
import 'package:azmonrahnamayi/screens/question_count_screen.dart';
import 'package:azmonrahnamayi/screens/profile_screen.dart';
import 'package:azmonrahnamayi/utils/constants.dart';
import 'package:azmonrahnamayi/widgets/styled_button.dart';
import 'package:azmonrahnamayi/widgets/booklet_card.dart';
import 'package:azmonrahnamayi/models/user.dart';
import 'package:azmonrahnamayi/services/user_service.dart';
import 'package:azmonrahnamayi/services/test_history_service.dart';
import 'package:azmonrahnamayi/services/image_service.dart'; // اضافه کردن سرویس تصویر
import 'package:url_launcher/url_launcher.dart';
import 'dart:io'; // اضافه کردن برای کار با فایل‌ها
import 'dart:convert';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  final UserService _userService = UserService();
  final TestHistoryService _testHistoryService = TestHistoryService();
  final ImageService _imageService = ImageService(); // اضافه کردن سرویس تصویر
  User? _user;
  int _testHistoryCount = 0;

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // انیمیشن شاینر برای تیک آبی
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _shimmerController, curve: Curves.ease));
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await _userService.getUser();
    final testHistoryCount = await _testHistoryService.getTestHistoryCount();
    setState(() {
      _user = user;
      _testHistoryCount = testHistoryCount;
    });
  }

  void _shareApp() {
    Share.share(
      'برنامه آزمون رهنمایی رانندگی را دانلود کنید!\n\n'
      'آماده شوید برای آزمون آیین نامه راهنمایی و رانندگی با مجموعه کامل سوالات.\n\n'
      'دانلود از: https://ehsanjs.ir/azmoon',
      subject: 'آزمون رهنمایی رانندگی',
    );
  }

  void _rateApp() async {
    const url = 'https://ehsanjs.ir/azmoon';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا در باز کردن لینک', style: GoogleFonts.vazirmatn()),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _navigateToProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );

    if (result == true) {
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final testProvider = Provider.of<TestProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // نقاط شکست هوشمندانه برای ریسپانسیو
    final isSmallPhone = screenWidth < 360;
    final isMediumPhone = screenWidth >= 360 && screenWidth < 600;
    final isTablet = screenWidth >= 600;

    // محاسبه اندازه‌های ریسپانسیو
    final appBarHeight = topPadding > 40
        ? topPadding + kToolbarHeight
        : kToolbarHeight;

    // اندازه‌های فونت ریسپانسیو
    final appBarTitleSize = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 18.0);
    final appBarIconSize = isTablet ? 28.0 : (isMediumPhone ? 24.0 : 22.0);
    final appBarAvatarSize = isTablet ? 14.0 : (isMediumPhone ? 12.0 : 10.0);
    final appBarNameSize = isTablet ? 11.0 : (isMediumPhone ? 9.0 : 8.0);

    final sectionTitleSize = isTablet ? 22.0 : (isMediumPhone ? 20.0 : 18.0);
    final cardTitleSize = isTablet ? 20.0 : (isMediumPhone ? 18.0 : 16.0);
    final cardSubtitleSize = isTablet ? 16.0 : (isMediumPhone ? 14.0 : 12.0);
    final badgeSize = isTablet ? 16.0 : (isMediumPhone ? 14.0 : 12.0);

    // اندازه‌های فاصله‌گذاری ریسپانسیو
    final appBarPadding = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 16.0);
    final cardPadding = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 16.0);
    final gridPadding = isTablet ? 20.0 : (isMediumPhone ? 16.0 : 12.0);
    final gridSpacing = isTablet ? 20.0 : (isMediumPhone ? 16.0 : 12.0);

    // اندازه‌های دکمه ریسپانسیو
    final buttonPadding = isTablet ? 14.0 : (isMediumPhone ? 12.0 : 10.0);
    final buttonFontSize = isTablet ? 18.0 : (isMediumPhone ? 16.0 : 14.0);

    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appBarPadding,
                vertical: isTablet ? 12.0 : 8.0,
              ),
              child: Row(
                children: [
                  // دکمه منو
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: appBarIconSize,
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // عنوان اپلیکیشن
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppConstants.appName,
                        style: GoogleFonts.vazirmatn(
                          fontSize: appBarTitleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // پروفایل کاربر - طراحی فشرده و بهینه
                  GestureDetector(
                    onTap: _navigateToProfile,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8.0 : 6.0,
                        vertical: isTablet ? 4.0 : 3.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // آواتار کاربر - سایز کوچکتر
                          _buildAppBarAvatar(appBarAvatarSize),
                          const SizedBox(width: 4),
                          // نام کاربر - فقط یک خط
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // محدود کردن طول نام کاربر
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isTablet ? 70.0 : 50.0,
                                ),
                                child: Text(
                                  _user?.fullName ?? 'کاربر مهمان',
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: appBarNameSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              // تیک آبی زیبا برای همه کاربران
                              _buildPremiumBlueTick(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(context, isTablet, isMediumPhone, isDarkMode),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: isSmallPhone ? 12.0 : 16.0,
                  left: cardPadding,
                  right: cardPadding,
                  bottom: cardPadding,
                ),
                child: _buildRandomTestCard(
                  context,
                  isTablet,
                  isMediumPhone,
                  cardTitleSize,
                  cardSubtitleSize,
                  buttonFontSize,
                  buttonPadding,
                  isDarkMode,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: cardPadding,
                    right: cardPadding,
                    bottom: bottomPadding > 0 ? bottomPadding + 8.0 : 8.0,
                  ),
                  child: _buildBookletsSection(
                    context,
                    isTablet,
                    isMediumPhone,
                    sectionTitleSize,
                    badgeSize,
                    gridPadding,
                    gridSpacing,
                    screenHeight,
                    isDarkMode,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تیک آبی پریمیوم برای AppBar
  Widget _buildPremiumBlueTick() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [Colors.blue.shade300, Colors.blue.shade600],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              // آیکون تیک
              Icon(Icons.verified, color: Colors.white, size: 10),
              // افکت شاینر
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Transform.translate(
                    offset: Offset(_shimmerAnimation.value * 20, 0),
                    child: Container(
                      width: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.8),
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
    );
  }

  Widget _buildAppBarAvatar(double avatarSize) {
    if (_user?.profileImagePath == null) {
      return CircleAvatar(
        radius: avatarSize,
        backgroundColor: Colors.white.withOpacity(0.3),
        child: Icon(Icons.person, color: Colors.white, size: avatarSize),
      );
    }

    final imagePath = _user!.profileImagePath!;

    // بررسی نوع مسیر تصویر
    if (imagePath.startsWith('data:image')) {
      try {
        final base64String = imagePath.split(',').last;
        final decodedBytes = base64.decode(base64String);
        return CircleAvatar(
          radius: avatarSize,
          backgroundColor: Colors.white.withOpacity(0.3),
          backgroundImage: MemoryImage(decodedBytes),
        );
      } catch (e) {
        print('Error decoding base64: $e');
        return CircleAvatar(
          radius: avatarSize,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Icon(Icons.person, color: Colors.white, size: avatarSize),
        );
      }
    } else if (imagePath.startsWith('http')) {
      return CircleAvatar(
        radius: avatarSize,
        backgroundColor: Colors.white.withOpacity(0.3),
        backgroundImage: NetworkImage(imagePath),
      );
    } else {
      // مسیر فایل محلی (از ImageService)
      try {
        final file = File(imagePath);
        if (file.existsSync()) {
          return CircleAvatar(
            radius: avatarSize,
            backgroundColor: Colors.white.withOpacity(0.3),
            backgroundImage: FileImage(file),
          );
        } else {
          // فایل وجود ندارد
          return CircleAvatar(
            radius: avatarSize,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Icon(Icons.person, color: Colors.white, size: avatarSize),
          );
        }
      } catch (e) {
        print('Error loading image file: $e');
        return CircleAvatar(
          radius: avatarSize,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Icon(Icons.person, color: Colors.white, size: avatarSize),
        );
      }
    }
  }

  Widget _buildDrawer(
    BuildContext context,
    bool isTablet,
    bool isMediumPhone,
    bool isDarkMode,
  ) {
    final itemFontSize = isTablet ? 18.0 : (isMediumPhone ? 16.0 : 14.0);
    final iconSize = isTablet ? 28.0 : (isMediumPhone ? 24.0 : 22.0);
    final padding = isTablet ? 16.0 : (isMediumPhone ? 14.0 : 12.0);

    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding * 1.5,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: isTablet ? 60 : 50,
                        height: isTablet ? 60 : 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.menu_book,
                          color: Colors.white,
                          size: isTablet ? 36 : 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.appName,
                              style: GoogleFonts.vazirmatn(
                                color: Colors.white,
                                fontSize: isTablet ? 28.0 : 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'آماده آزمون رانندگی',
                              style: GoogleFonts.vazirmatn(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: isTablet ? 16.0 : 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _navigateToProfile,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildProfileAvatar(isTablet ? 24.0 : 20.0),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _user?.fullName ?? 'کاربر مهمان',
                                        style: GoogleFonts.vazirmatn(
                                          color: Colors.white,
                                          fontSize: isTablet ? 16.0 : 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // تیک آبی پریمیوم برای همه کاربران در منو
                                    _buildPremiumBlueBadge(isTablet),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '@${_user?.username ?? 'guest'}',
                                  style: GoogleFonts.vazirmatn(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: isTablet ? 14.0 : 12.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: Text(
                      'منوی اصلی',
                      style: GoogleFonts.vazirmatn(
                        fontSize: isTablet ? 16.0 : 14.0,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.home,
                    title: 'صفحه اصلی',
                    iconSize: iconSize,
                    fontSize: itemFontSize,
                    isDarkMode: isDarkMode,
                    isCurrent: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.assessment,
                    title: 'نتایج آزمون‌ها',
                    iconSize: iconSize,
                    fontSize: itemFontSize,
                    isDarkMode: isDarkMode,
                    trailing: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        _testHistoryCount.toString(),
                        style: GoogleFonts.vazirmatn(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: Text(
                      'دیگر',
                      style: GoogleFonts.vazirmatn(
                        fontSize: isTablet ? 16.0 : 14.0,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    title: isDarkMode ? 'حالت روشن' : 'حالت تاریک',
                    iconSize: iconSize,
                    fontSize: itemFontSize,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleTheme();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.info,
                    title: 'درباره ما',
                    iconSize: iconSize,
                    fontSize: itemFontSize,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.share,
                    title: 'اشتراک گذاری',
                    iconSize: iconSize,
                    fontSize: itemFontSize,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      _shareApp();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.star,
                    title: 'امتیاز به برنامه',
                    iconSize: iconSize,
                    fontSize: itemFontSize,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      _rateApp();
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'نسخه',
                        style: GoogleFonts.vazirmatn(
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                          fontSize: isTablet ? 14.0 : 12.0,
                        ),
                      ),
                      Text(
                        ' 1.0.0',
                        style: GoogleFonts.vazirmatn(
                          color: isDarkMode
                              ? Colors.grey[300]
                              : Colors.grey[700],
                          fontSize: isTablet ? 14.0 : 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تمامی حقوق محفوظ است © 2025',
                    style: GoogleFonts.vazirmatn(
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                      fontSize: isTablet ? 12.0 : 10.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تیک آبی پریمیوم برای منو
  Widget _buildPremiumBlueBadge(bool isTablet) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 8 : 6,
            vertical: isTablet ? 4 : 3,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade700],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: isTablet ? 16 : 14,
                  ),
                  SizedBox(width: isTablet ? 4 : 2),
                  Text(
                    'کاربر ویژه',
                    style: GoogleFonts.vazirmatn(
                      color: Colors.white,
                      fontSize: isTablet ? 10 : 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // افکت شاینر
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Transform.translate(
                    offset: Offset(_shimmerAnimation.value * 40, 0),
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.6),
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
    );
  }

  Widget _buildProfileAvatar(double avatarSize) {
    if (_user?.profileImagePath == null) {
      return CircleAvatar(
        radius: avatarSize,
        backgroundColor: Colors.white.withOpacity(0.2),
        child: const Icon(Icons.person, color: Colors.white),
      );
    }

    final imagePath = _user!.profileImagePath!;

    // بررسی نوع مسیر تصویر
    if (imagePath.startsWith('data:image')) {
      try {
        final base64String = imagePath.split(',').last;
        final decodedBytes = base64.decode(base64String);
        return CircleAvatar(
          radius: avatarSize,
          backgroundColor: Colors.white.withOpacity(0.2),
          backgroundImage: MemoryImage(decodedBytes),
        );
      } catch (e) {
        print('Error decoding base64: $e');
        return CircleAvatar(
          radius: avatarSize,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: const Icon(Icons.person, color: Colors.white),
        );
      }
    } else if (imagePath.startsWith('http')) {
      return CircleAvatar(
        radius: avatarSize,
        backgroundColor: Colors.white.withOpacity(0.2),
        backgroundImage: NetworkImage(imagePath),
      );
    } else {
      // مسیر فایل محلی (از ImageService)
      try {
        final file = File(imagePath);
        if (file.existsSync()) {
          return CircleAvatar(
            radius: avatarSize,
            backgroundColor: Colors.white.withOpacity(0.2),
            backgroundImage: FileImage(file),
          );
        } else {
          // فایل وجود ندارد
          return CircleAvatar(
            radius: avatarSize,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white),
          );
        }
      } catch (e) {
        print('Error loading image file: $e');
        return CircleAvatar(
          radius: avatarSize,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: const Icon(Icons.person, color: Colors.white),
        );
      }
    }
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required double iconSize,
    required double fontSize,
    required bool isDarkMode,
    bool isCurrent = false,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isCurrent
            ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
            : (isDarkMode
                  ? Colors.grey[800]!.withOpacity(0.5)
                  : Colors.grey[100]),
        borderRadius: BorderRadius.circular(16),
        border: isCurrent
            ? Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                width: 1.5,
              )
            : null,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCurrent
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: isCurrent
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.vazirmatn(
            fontSize: fontSize,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
            color: isCurrent
                ? Theme.of(context).colorScheme.primary
                : (isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        onTap: onTap,
        trailing:
            trailing ??
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isCurrent
                  ? Theme.of(context).colorScheme.primary
                  : (isDarkMode ? Colors.grey[400] : Colors.grey),
            ),
      ),
    );
  }

  Widget _buildRandomTestCard(
    BuildContext context,
    bool isTablet,
    bool isMediumPhone,
    double titleFontSize,
    double subtitleFontSize,
    double buttonFontSize,
    double buttonPadding,
    bool isDarkMode,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 10.0 : 8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.shuffle,
                  color: Colors.white,
                  size: isTablet ? 28.0 : 24.0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'آزمون تصادفی',
                      style: GoogleFonts.vazirmatn(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isTablet ? 6.0 : 4.0),
                    Text(
                      'سوالات به صورت تصادفی از همه دفترچه‌ها',
                      style: GoogleFonts.vazirmatn(
                        fontSize: subtitleFontSize,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20.0 : 16.0),
          StyledButton(
            title: 'شروع آزمون',
            subtitle: 'آماده اید؟',
            icon: Icons.play_arrow,
            onTap: () async {
              setState(() {
                _isLoading = true;
              });

              await Future.delayed(const Duration(seconds: 1));

              setState(() {
                _isLoading = false;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuestionCountScreen(),
                ),
              );
            },
            isLoading: _isLoading,
            backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
            textColor: Theme.of(context).colorScheme.primary,
            fontSize: buttonFontSize,
            padding: EdgeInsets.symmetric(
              vertical: buttonPadding,
              horizontal: isTablet ? 24.0 : 16.0,
            ),
            borderRadius: 16.0,
            elevation: 0,
            showShadow: false,
            borderWidth: 1.0,
            borderColor: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildBookletsSection(
    BuildContext context,
    bool isTablet,
    bool isMediumPhone,
    double sectionTitleFontSize,
    double badgeFontSize,
    double gridPadding,
    double gridSpacing,
    double screenHeight,
    bool isDarkMode,
  ) {
    int crossAxisCount = 2;
    if (isTablet) {
      crossAxisCount = 3;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'دفترچه‌های آزمون',
                style: GoogleFonts.vazirmatn(
                  fontSize: sectionTitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 12.0 : 8.0,
                vertical: isTablet ? 6.0 : 4.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '10 دفترچه',
                style: GoogleFonts.vazirmatn(
                  fontSize: badgeFontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: gridSpacing),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: gridPadding),
            physics: const BouncingScrollPhysics(),
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
}
