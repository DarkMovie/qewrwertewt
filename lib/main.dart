// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:azmonrahnamayi/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:azmonrahnamayi/providers/theme_provider.dart';
import 'package:azmonrahnamayi/providers/test_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void main() {
  // بهینه‌سازی بارگذاری فونت‌ها
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TestProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'آزمون آیین نامه رانندگی',
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fa', 'IR'), // فارسی ایران
              Locale('en', 'US'), // انگلیسی
            ],
            locale: const Locale('fa', 'IR'),
            // بهینه‌سازی عملکرد با استفاده از builder
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                  devicePixelRatio: MediaQuery.of(
                    context,
                  ).devicePixelRatio.clamp(1.0, 3.0),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: child!,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // بهینه‌سازی تم روشن با کاهش تکرار و بهبود عملکرد
  ThemeData _buildLightTheme() {
    const Color primaryColor = Color(0xFFFF6B00);
    const Color secondaryColor = Color(0xFFFF9E44);
    const Color tertiaryColor = Color(0xFFFFD93D);
    const Color surfaceColor = Color(0xFFF8F9FA);
    const Color backgroundColor = Color(0xFFF8F9FA);
    const Color errorColor = Color(0xFFB00020);

    // ساخت رنگ‌بندی پایه
    final colorScheme = const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    );

    // ساخت تم پایه
    final baseTheme = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    // ساخت تم نهایی با اعمال تغییرات
    return baseTheme.copyWith(
      // بهینه‌سازی فونت با استفاده از تم پایه
      textTheme: GoogleFonts.vazirmatnTextTheme(baseTheme.textTheme)
          .apply(
            bodyColor: const Color(0xFF333333),
            displayColor: const Color(0xFF333333),
          )
          .copyWith(
            displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
              fontSize: 28,
            ),
            displayMedium: baseTheme.textTheme.displayMedium?.copyWith(
              fontSize: 24,
            ),
            displaySmall: baseTheme.textTheme.displaySmall?.copyWith(
              fontSize: 20,
            ),
            headlineLarge: baseTheme.textTheme.headlineLarge?.copyWith(
              fontSize: 28,
            ),
            headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
              fontSize: 20,
            ),
            headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
              fontSize: 18,
            ),
            titleLarge: baseTheme.textTheme.titleLarge?.copyWith(fontSize: 18),
            titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
              fontSize: 15,
            ),
            titleSmall: baseTheme.textTheme.titleSmall?.copyWith(fontSize: 13),
            bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(fontSize: 15),
            bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(fontSize: 13),
            bodySmall: baseTheme.textTheme.bodySmall?.copyWith(fontSize: 11),
            labelLarge: baseTheme.textTheme.labelLarge?.copyWith(fontSize: 13),
            labelMedium: baseTheme.textTheme.labelMedium?.copyWith(
              fontSize: 11,
            ),
            labelSmall: baseTheme.textTheme.labelSmall?.copyWith(fontSize: 10),
          ),

      // بهینه‌سازی دکمه‌ها
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: primaryColor.withOpacity(0.3),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),

      // بهینه‌سازی کارت‌ها
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(6),
      ),

      // بهینه‌سازی تقسیم‌کننده‌ها
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 1,
      ),

      // بهینه‌سازی فیلدهای ورودی
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),

      // بهینه‌سازی نشانگر پیشرفت
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: Color(0xFFE0E0E0),
        linearMinHeight: 6,
        refreshBackgroundColor: primaryColor,
      ),

      // بهینه‌سازی اسنک‌بار
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF333333),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        behavior: SnackBarBehavior.floating,
        actionTextColor: primaryColor,
      ),

      // بهینه‌سازی نوار پایین
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF757575),
        type: BottomNavigationBarType.fixed,
        elevation: 4,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // بهینه‌سازی دکمه شناور
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 8,
      ),

      // بهینه‌سازی تب‌ها
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: const Color(0xFF757575),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),

      // بهینه‌سازی چیپ‌ها
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE0E0E0),
        deleteIconColor: const Color(0xFF757575),
        disabledColor: const Color(0xFFE0E0E0),
        selectedColor: primaryColor.withOpacity(0.2),
        secondarySelectedColor: primaryColor,
        shadowColor: Colors.black.withOpacity(0.08),
        selectedShadowColor: Colors.black.withOpacity(0.08),
        checkmarkColor: primaryColor,
        labelStyle: const TextStyle(color: Color(0xFF333333), fontSize: 13),
        secondaryLabelStyle: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 13,
        ),
        brightness: Brightness.light,
        elevation: 2,
        pressElevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
    );
  }

  // بهینه‌سازی تم تاریک با کاهش تکرار و بهبود عملکرد
  ThemeData _buildDarkTheme() {
    const Color primaryColor = Color(0xFFFF6B00);
    const Color secondaryColor = Color(0xFFFF9E44);
    const Color tertiaryColor = Color(0xFFFFD93D);
    const Color surfaceColor = Color(0xFF1F1F1F);
    const Color backgroundColor = Color(0xFF121212);
    const Color errorColor = Color(0xFFCF6679);

    // ساخت رنگ‌بندی پایه
    final colorScheme = const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    );

    // ساخت تم پایه
    final baseTheme = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    // ساخت تم نهایی با اعمال تغییرات
    return baseTheme.copyWith(
      // بهینه‌سازی فونت با استفاده از تم پایه
      textTheme: GoogleFonts.vazirmatnTextTheme(baseTheme.textTheme)
          .apply(bodyColor: Colors.white, displayColor: Colors.white)
          .copyWith(
            displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
              fontSize: 28,
            ),
            displayMedium: baseTheme.textTheme.displayMedium?.copyWith(
              fontSize: 24,
            ),
            displaySmall: baseTheme.textTheme.displaySmall?.copyWith(
              fontSize: 20,
            ),
            headlineLarge: baseTheme.textTheme.headlineLarge?.copyWith(
              fontSize: 28,
            ),
            headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
              fontSize: 20,
            ),
            headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
              fontSize: 18,
            ),
            titleLarge: baseTheme.textTheme.titleLarge?.copyWith(fontSize: 18),
            titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
              fontSize: 15,
            ),
            titleSmall: baseTheme.textTheme.titleSmall?.copyWith(fontSize: 13),
            bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(fontSize: 15),
            bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(fontSize: 13),
            bodySmall: baseTheme.textTheme.bodySmall?.copyWith(fontSize: 11),
            labelLarge: baseTheme.textTheme.labelLarge?.copyWith(fontSize: 13),
            labelMedium: baseTheme.textTheme.labelMedium?.copyWith(
              fontSize: 11,
            ),
            labelSmall: baseTheme.textTheme.labelSmall?.copyWith(fontSize: 10),
          ),

      // بهینه‌سازی دکمه‌ها
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: primaryColor.withOpacity(0.3),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),

      // بهینه‌سازی کارت‌ها
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(6),
      ),

      // بهینه‌سازی تقسیم‌کننده‌ها
      dividerTheme: const DividerThemeData(
        color: Color(0xFF424242),
        thickness: 1,
        space: 1,
      ),

      // بهینه‌سازی فیلدهای ورودی
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),

      // بهینه‌سازی نشانگر پیشرفت
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: Color(0xFF424242),
        linearMinHeight: 6,
        refreshBackgroundColor: primaryColor,
      ),

      // بهینه‌سازی اسنک‌بار
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF323232),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        behavior: SnackBarBehavior.floating,
        actionTextColor: primaryColor,
      ),

      // بهینه‌سازی نوار پایین
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF9E9E9E),
        type: BottomNavigationBarType.fixed,
        elevation: 4,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // بهینه‌سازی دکمه شناور
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 8,
      ),

      // بهینه‌سازی تب‌ها
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: const Color(0xFF9E9E9E),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),

      // بهینه‌سازی چیپ‌ها
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF424242),
        deleteIconColor: const Color(0xFF9E9E9E),
        disabledColor: const Color(0xFF424242),
        selectedColor: primaryColor.withOpacity(0.2),
        secondarySelectedColor: primaryColor,
        shadowColor: Colors.black.withOpacity(0.2),
        selectedShadowColor: Colors.black.withOpacity(0.2),
        checkmarkColor: primaryColor,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontSize: 13),
        brightness: Brightness.dark,
        elevation: 2,
        pressElevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: Color(0xFF424242), width: 1),
      ),
    );
  }
}
