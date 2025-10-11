// lib/utils/constants.dart
class AppConstants {
  // اطلاعات اصلی برنامه
  static const String appName = 'آزمون آیین نامه رانندگی';
  static const String appVersion = '1.0.0';
  static const String developerName = 'احسان فضلی';
  static const String developerEmail = 'ehsanfazlinejad@gmail.com';
  static const String developerWebsite = 'ehsanjs.ir';

  // اطلاعات تیم نکزو
  static const String teamName = 'نکزو تیم';
  static const String teamWebsite = 'nexzo.ir';
  static const String teamAppWebsite = 'azmoon.nexzo.ir';
  static const String teamSupportEmail = 'ehsanfazlinejad@gmail.com';

  // منابع محتوا
  static const String contentSource =
      'تمامی محتوای این اپلیکیشن توسط تیم نکزو (Nexzo Team) تهیه شده است';
  static const String copyrightNotice =
      'تمامی حقوق مادی و معنوی این اپلیکیشن متعلق به تیم نکزو (Nexzo Team) می‌باشد';

  // سیاست حریم خصوصی
  static const String privacyPolicyTitle = 'سیاست حریم خصوصی';
  static const String privacyPolicyIntro =
      'تیم نکزو (Nexzo Team) به حریم خصوصی کاربران خود احترام می‌گذارد و متعهد به حفاظت از اطلاعات شخصی شماست.';
  static const String privacyPolicyOffline =
      'این اپلیکیشن به صورت کاملاً آفلاین عمل می‌کند و هیچ‌گونه داده‌ای از کاربران را در سرورهای خود یا سرورهای شخص ثالث ذخیره نمی‌کند.';
  static const String privacyPolicyDataStorage =
      'تمامی اطلاعات شما از جمله سوالات پاسخ داده شده، نتایج آزمون‌ها و تنظیمات شخصی، فقط در حافظه دستگاه شما ذخیره می‌شوند و ما به هیچ وجه به این داده‌ها دسترسی نداریم.';

  // تنظیمات آزمون
  static const int bookletCount = 10;
  static const int defaultRandomTestQuestionCount = 20;
  static const int maxRandomTestQuestionCount = 50;
  static const int minRandomTestQuestionCount = 5;

  // پیام‌های انگیزشی
  static const List<String> motivationalMessages = [
    "آفرین! عالی بود 👏",
    "خوب بود، ادامه بده 💪",
    "نیاز به تمرین بیشتری داری 📚",
    "ناامید نشو، دفعه بعد بهتر میشی 💪",
    "پشتکار تو قابل تحسینه! 🔥",
    "هر تمرینی تو رو به هدف نزدیکتر میکنه 🎯",
  ];

  // مسیرهای دارایی‌ها
  static const String questionsAssetPath = 'assets/questions';
  static const String imagesAssetPath = 'assets/images';
  static const String defaultAvatarImage = 'avatar.png';

  // رنگ‌های اصلی برنامه
  static const int primaryColorValue = 0xFFFF6B00;
  static const int secondaryColorValue = 0xFFFF9E44;

  // تنظیمات انیمیشن
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // متدهای کمکی
  static String getRandomMotivationalMessage() {
    return motivationalMessages[DateTime.now().millisecond %
        motivationalMessages.length];
  }

  static String getMotivationalMessageByScore(int score, int totalQuestions) {
    final percentage = (score / totalQuestions) * 100;

    if (percentage >= 90) {
      return motivationalMessages[0]; // "آفرین! عالی بود 👏"
    } else if (percentage >= 70) {
      return motivationalMessages[1]; // "خوب بود، ادامه بده 💪"
    } else if (percentage >= 50) {
      return motivationalMessages[2]; // "نیاز به تمرین بیشتری داری 📚"
    } else {
      return motivationalMessages[3]; // "ناامید نشو، دفعه下次 بهتر میشی 💪"
    }
  }

  static String getBookletAssetPath(int bookletNumber) {
    return '$questionsAssetPath/list$bookletNumber.json';
  }

  static String getImageAssetPath(String imageName) {
    return '$imagesAssetPath/$imageName';
  }
}

