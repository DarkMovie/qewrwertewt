// lib/models/user.dart
class User {
  final String username;
  final String fullName;
  String? profileImagePath;
  final bool isVerified; // فیلد جدید برای نمایش تیک تأیید

  User({
    required this.username,
    required this.fullName,
    this.profileImagePath,
    this.isVerified = false, // مقدار پیش‌فرض
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'profileImagePath': profileImagePath,
      'isVerified': isVerified, // افزودن فیلد جدید
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      profileImagePath: json['profileImagePath'],
      isVerified: json['isVerified'] ?? false, // افزودن فیلد جدید
    );
  }

  // متد استاتیک برای اعتبارسنجی نام کاربری
  static String? validateUsername(String username) {
    // بررسی خالی بودن
    if (username.isEmpty) {
      return 'نام کاربری را وارد کنید';
    }

    // بررسی حداقل طول
    if (username.length < 4) {
      return 'نام کاربری باید حداقل ۴ کاراکتر باشد';
    }

    // بررسی حداکثر طول
    if (username.length > 20) {
      return 'نام کاربری نمی‌تواند بیشتر از ۲۰ کاراکتر باشد';
    }

    // بررسی اینکه فقط حروف انگلیسی و اعداد باشد
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      return 'نام کاربری باید فقط شامل حروف انگلیسی و اعداد باشد';
    }

    // بررسی اینکه با عدد شروع نشود
    if (RegExp(r'^[0-9]').hasMatch(username)) {
      return 'نام کاربری نمی‌تواند با عدد شروع شود';
    }

    return null; // هیچ خطایی وجود ندارد
  }

  // متد استاتیک برای اعتبارسنجی نام کامل
  static String? validateFullName(String fullName) {
    // بررسی خالی بودن
    if (fullName.isEmpty) {
      return 'نام کامل را وارد کنید';
    }

    // بررسی حداقل طول
    if (fullName.length < 3) {
      return 'نام کامل باید حداقل ۳ کاراکتر باشد';
    }

    // بررسی حداکثر طول
    if (fullName.length > 50) {
      return 'نام کامل نمی‌تواند بیشتر از ۵۰ کاراکتر باشد';
    }

    // بررسی اینکه فقط حروف فارسی و فاصله باشد
    if (!RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(fullName)) {
      return 'نام کامل باید فقط شامل حروف فارسی باشد';
    }

    // بررسی حداقل دو کلمه (نام و نام خانوادگی)
    if (!fullName.trim().contains(' ')) {
      return 'لطفاً نام و نام خانوادگی را وارد کنید';
    }

    return null; // هیچ خطایی وجود ندارد
  }

  // متد استاتیک برای اعتبارسنجی تصویر پروفایل
  static String? validateProfileImage(String? imagePath) {
    // تصویر پروفایل اختیاری است، پس نیازی به اعتبارسنجی نیست
    // اما در صورت وجود، می‌توانیم اعتبارسنجی‌های لازم را انجام دهیم
    if (imagePath != null && imagePath.isEmpty) {
      return 'مسیر تصویر پروفایل معتبر نیست';
    }

    return null; // هیچ خطایی وجود ندارد
  }

  // متد برای به‌روزرسانی نام کاربری با اعتبارسنجی
  User copyWithUsername(String newUsername) {
    // اعتبارسنجی نام کاربری جدید
    final error = validateUsername(newUsername);
    if (error != null) {
      throw ArgumentError(error);
    }

    return User(
      username: newUsername,
      fullName: fullName,
      profileImagePath: profileImagePath,
      isVerified: isVerified, // حفظ وضعیت تأیید
    );
  }

  // متد برای به‌روزرسانی نام کامل با اعتبارسنجی
  User copyWithFullName(String newFullName) {
    // اعتبارسنجی نام کامل جدید
    final error = validateFullName(newFullName);
    if (error != null) {
      throw ArgumentError(error);
    }

    return User(
      username: username,
      fullName: newFullName,
      profileImagePath: profileImagePath,
      isVerified: isVerified, // حفظ وضعیت تأیید
    );
  }

  // متد برای به‌روزرسانی تصویر پروفایل با اعتبارسنجی
  User copyWithProfileImage(String? newProfileImagePath) {
    // اعتبارسنجی تصویر پروفایل جدید
    final error = validateProfileImage(newProfileImagePath);
    if (error != null) {
      throw ArgumentError(error);
    }

    return User(
      username: username,
      fullName: fullName,
      profileImagePath: newProfileImagePath,
      isVerified: isVerified, // حفظ وضعیت تأیید
    );
  }

  // متد جدید برای به‌روزرسانی وضعیت تأیید
  User copyWithIsVerified(bool newIsVerified) {
    return User(
      username: username,
      fullName: fullName,
      profileImagePath: profileImagePath,
      isVerified: newIsVerified,
    );
  }

  // متد برای نمایش اطلاعات کاربر به صورت رشته
  @override
  String toString() {
    return 'User(username: $username, fullName: $fullName, hasProfileImage: ${profileImagePath != null}, isVerified: $isVerified)';
  }
}
