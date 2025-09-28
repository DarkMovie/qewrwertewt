// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:azmonrahnamayi/models/user.dart';
import 'package:azmonrahnamayi/services/user_service.dart';
import 'package:azmonrahnamayi/screens/home_screen.dart';
import 'package:azmonrahnamayi/services/image_service.dart';
import 'package:azmonrahnamayi/utils/web_image_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final _userService = UserService();
  final _imageService = ImageService();
  User? _user;
  String? _profileImagePath;
  bool _isLoading = true;
  bool _isPickingImage = false;

  // کنترلرهای ویرایش
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  // انیمیشن‌ها
  late AnimationController _shimmerController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _initAnimations();
  }

  void _initAnimations() {
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _shimmerController, curve: Curves.ease));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.05).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _scaleController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _scaleController.forward();
          }
        });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _shimmerController.repeat();
    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _shimmerController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _userService.getUser();
      setState(() {
        _user = user;
        _profileImagePath = user?.profileImagePath;
        _usernameController.text = user?.username ?? '';
        _fullNameController.text = user?.fullName ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('خطا در بارگذاری اطلاعات کاربر');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.vazirmatn()),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.vazirmatn()),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final result = await WebImageDialog.show(context);

      if (result == null) {
        // کاربر انصراف داده است
        return;
      }

      if (result == 'delete') {
        // حذف تصویر پروفایل
        await _deleteProfileImage();
      } else {
        // انتخاب تصویر جدید
        await _updateProfileImage(result);
      }
    } catch (e) {
      _showErrorSnackBar('خطا در انتخاب تصویر: ${e.toString()}');
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  Future<void> _deleteProfileImage() async {
    setState(() {
      _profileImagePath = null;
    });

    try {
      if (_user != null) {
        final updatedUser = User(
          username: _user!.username,
          fullName: _user!.fullName,
          profileImagePath: null,
        );

        await _userService.saveUser(updatedUser);
        await _loadUser(); // بارگذاری مجدد اطلاعات کاربر
        _showSuccessSnackBar('تصویر پروفایل حذف شد');
      }
    } catch (e) {
      _showErrorSnackBar('خطا در حذف تصویر پروفایل');
      // در صورت خطا، وضعیت قبلی را بازگردانی می‌کنیم
      await _loadUser();
    }
  }

  Future<void> _updateProfileImage(String imagePath) async {
    setState(() {
      _profileImagePath = imagePath;
    });

    try {
      if (_user != null) {
        final updatedUser = User(
          username: _user!.username,
          fullName: _user!.fullName,
          profileImagePath: imagePath,
        );

        await _userService.saveUser(updatedUser);
        await _loadUser(); // بارگذاری مجدد اطلاعات کاربر
        _showSuccessSnackBar('تصویر پروفایل به‌روزرسانی شد');
      }
    } catch (e) {
      _showErrorSnackBar('خطا در به‌روزرسانی تصویر پروفایل');
      // در صورت خطا، وضعیت قبلی را بازگردانی می‌کنیم
      await _loadUser();
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _saveUserInfo();
      }
    });
  }

  Future<void> _saveUserInfo() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedUser = User(
        username: _usernameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        profileImagePath: _profileImagePath,
      );

      await _userService.saveUser(updatedUser);
      setState(() {
        _user = updatedUser;
      });

      _showSuccessSnackBar('اطلاعات با موفقیت به‌روزرسانی شد');
    } catch (e) {
      _showErrorSnackBar('خطا در ذخیره اطلاعات: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _skipProfileSetup() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // نقاط شکست هوشمندانه برای ریسپانسیو
    final isSmallPhone = screenWidth < 360;
    final isMediumPhone = screenWidth >= 360 && screenWidth < 600;
    final isTablet = screenWidth >= 600;

    // محاسبه اندازه‌های ریسپانسیو
    final avatarSize = isTablet ? 160.0 : (isMediumPhone ? 140.0 : 120.0);
    final avatarIconSize = isTablet ? 80.0 : (isMediumPhone ? 70.0 : 60.0);
    final titleSize = isTablet ? 26.0 : (isMediumPhone ? 24.0 : 22.0);
    final subtitleSize = isTablet ? 16.0 : (isMediumPhone ? 15.0 : 14.0);
    final inputFontSize = isTablet ? 16.0 : (isMediumPhone ? 15.0 : 14.0);
    final labelFontSize = isTablet ? 14.0 : (isMediumPhone ? 13.0 : 12.0);
    final buttonFontSize = isTablet ? 16.0 : (isMediumPhone ? 15.0 : 14.0);
    final padding = isTablet ? 32.0 : (isMediumPhone ? 24.0 : 20.0);
    final spacing = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 16.0);
    final borderRadius = isTablet ? 24.0 : (isMediumPhone ? 20.0 : 16.0);
    final fieldHeight = isTablet ? 60.0 : (isMediumPhone ? 56.0 : 52.0);
    final buttonHeight = isTablet ? 56.0 : (isMediumPhone ? 52.0 : 48.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'پروفایل کاربر',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _toggleEdit,
            tooltip: _isEditing ? 'ذخیره تغییرات' : 'ویرایش پروفایل',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator(color: Colors.white)
                  else
                    _buildProfileContent(
                      avatarSize,
                      avatarIconSize,
                      titleSize,
                      subtitleSize,
                      inputFontSize,
                      labelFontSize,
                      buttonFontSize,
                      padding,
                      spacing,
                      borderRadius,
                      fieldHeight,
                      buttonHeight,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    double avatarSize,
    double avatarIconSize,
    double titleSize,
    double subtitleSize,
    double inputFontSize,
    double labelFontSize,
    double buttonFontSize,
    double padding,
    double spacing,
    double borderRadius,
    double fieldHeight,
    double buttonHeight,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // آواتار کاربر با طراحی جدید
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: _isPickingImage ? null : _pickImage,
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _isPickingImage
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : _buildProfileImage(avatarIconSize),
                ),
              ),
            );
          },
        ),
        SizedBox(height: spacing * 0.8),
        Text(
          'پروفایل کاربری',
          style: GoogleFonts.vazirmatn(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: titleSize,
          ),
        ),
        SizedBox(height: spacing * 0.3),
        Text(
          'برای انتخاب تصویر پروفایل ضربه بزنید',
          style: GoogleFonts.vazirmatn(
            color: Colors.white70,
            fontSize: subtitleSize,
          ),
        ),
        SizedBox(height: spacing * 1.5),

        // اطلاعات کاربر با طراحی جدید
        SlideTransition(
          position: _slideAnimation,
          child: _buildUserForm(
            padding,
            spacing,
            borderRadius,
            fieldHeight,
            inputFontSize,
            labelFontSize,
          ),
        ),
        SizedBox(height: spacing * 1.5),

        // دکمه‌ها
        _buildActionButtons(buttonHeight, buttonFontSize, spacing),
      ],
    );
  }

  Widget _buildProfileImage(double iconSize) {
    if (_profileImagePath == null) {
      return Icon(Icons.person, color: Colors.white, size: iconSize);
    }

    try {
      final file = File(_profileImagePath!);
      if (file.existsSync()) {
        return ClipOval(
          child: Image.file(
            file,
            fit: BoxFit.cover,
            width: 140,
            height: 140,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, color: Colors.white, size: iconSize);
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error loading image: $e');
    }

    return Icon(Icons.person, color: Colors.white, size: iconSize);
  }

  Widget _buildUserForm(
    double padding,
    double spacing,
    double borderRadius,
    double fieldHeight,
    double inputFontSize,
    double labelFontSize,
  ) {
    return Container(
      padding: EdgeInsets.all(padding * 0.75),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800.withOpacity(0.8)
            : Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // نام کاربری
            _buildTextField(
              controller: _usernameController,
              enabled: _isEditing,
              labelText: 'نام کاربری',
              hintText: 'نام کاربری را وارد کنید',
              icon: Icons.person,
              validator: (value) {
                if (_isEditing) {
                  return User.validateUsername(value?.trim() ?? '');
                }
                return null;
              },
              fieldHeight: fieldHeight,
              inputFontSize: inputFontSize,
              labelFontSize: labelFontSize,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
            ),

            SizedBox(height: spacing * 0.3),

            // نام کامل
            _buildTextField(
              controller: _fullNameController,
              enabled: _isEditing,
              labelText: 'نام کامل',
              hintText: 'نام کامل را وارد کنید',
              icon: Icons.badge,
              validator: (value) {
                if (_isEditing) {
                  return User.validateFullName(value?.trim() ?? '');
                }
                return null;
              },
              fieldHeight: fieldHeight,
              inputFontSize: inputFontSize,
              labelFontSize: labelFontSize,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),

            SizedBox(height: spacing * 0.8),

            // تیک آبی برای همه کاربران
            _buildPremiumBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required bool enabled,
    required String labelText,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    required double fieldHeight,
    required double inputFontSize,
    required double labelFontSize,
    required TextAlign textAlign,
    required TextDirection textDirection,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: GoogleFonts.vazirmatn(fontSize: labelFontSize),
          hintStyle: GoogleFonts.vazirmatn(
            fontSize: inputFontSize,
            color: Colors.grey.shade500,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: fieldHeight * 0.3,
            horizontal: 16,
          ),
        ),
        style: GoogleFonts.vazirmatn(fontSize: inputFontSize),
        textAlign: textAlign,
        textDirection: textDirection,
        validator: validator,
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 1),
      ),
      child: Row(
        children: [
          // تیک آبی با انیمیشن شاینر
          AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(2),
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
                    const Icon(Icons.verified, color: Colors.white, size: 24),
                    // افکت شاینر
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Transform.translate(
                          offset: Offset(_shimmerAnimation.value * 30, 0),
                          child: Container(
                            width: 30,
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
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'کاربر ویژه',
                  style: GoogleFonts.vazirmatn(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'شما یک کاربر ویژه در برنامه ما هستید',
                  style: GoogleFonts.vazirmatn(
                    color: Colors.blue.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    double buttonHeight,
    double buttonFontSize,
    double spacing,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _skipProfileSetup,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: buttonHeight * 0.4),
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'رد کردن',
              style: GoogleFonts.vazirmatn(
                color: Colors.white,
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: spacing * 0.5),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: buttonHeight * 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'ادامه',
              style: GoogleFonts.vazirmatn(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'راهنما',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'شما می‌توانید اطلاعات پروفایل خود را ویرایش کنید یا این مرحله را رد کنید.',
          style: GoogleFonts.vazirmatn(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('متوجه شدم', style: GoogleFonts.vazirmatn()),
          ),
        ],
      ),
    );
  }
}
