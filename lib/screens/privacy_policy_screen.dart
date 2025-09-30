// lib/screens/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:azmonrahnamayi/utils/constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سیاست حریم خصوصی',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('مقدمه', isDarkMode),
            const SizedBox(height: 12),
            _buildContentCard(
              context,
              isDarkMode,
              'تیم نکزو (Nexzo Team) به حریم خصوصی کاربران خود احترام می‌گذارد و متعهد به حفاظت از اطلاعات شخصی شماست. این سیاست حریم خصوصی توضیح می‌دهد که چگونه ما اطلاعات شما را جمع‌آوری، استفاده و محافظت می‌کنیم.',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('جمع‌آوری اطلاعات', isDarkMode),
            const SizedBox(height: 12),
            _buildContentCard(
              context,
              isDarkMode,
              'این اپلیکیشن به صورت کاملاً آفلاین عمل می‌کند و هیچ‌گونه داده‌ای از کاربران را در سرورهای خود یا سرورهای شخص ثالث ذخیره نمی‌کند. تمام اطلاعات شما فقط در حافظه دستگاه شما ذخیره می‌شوند.',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('استفاده از اطلاعات', isDarkMode),
            const SizedBox(height: 12),
            _buildContentCard(
              context,
              isDarkMode,
              'اطلاعات شما فقط برای عملکرد صحیح اپلیکیشن استفاده می‌شوند و در اختیار هیچ شخص ثالثی قرار نمی‌گیرند. ما از اطلاعات شما برای اهداف بازاریابی یا تبلیغاتی استفاده نمی‌کنیم.',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('حفاظت از اطلاعات', isDarkMode),
            const SizedBox(height: 12),
            _buildContentCard(
              context,
              isDarkMode,
              'ما از اقدامات امنیتی مناسب برای محافظت از اطلاعات شما در برابر دسترسی، استفاده یا افشای غیرمجاز استفاده می‌کنیم. با این حال، از آنجا که اطلاعات فقط در دستگاه شما ذخیره می‌شوند، مسئولیت حفاظت از دستگاه شما بر عهده خودتان است.',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('تماس با ما', isDarkMode),
            const SizedBox(height: 12),
            _buildContentCard(
              context,
              isDarkMode,
              'اگر سوال یا نگرانی در مورد این سیاست حریم خصوصی دارید، می‌توانید از طریق ایمیل زیر با ما تماس بگیرید:\n\nsupport@nexzo.ir',
            ),

            const SizedBox(height: 32),

            Center(
              child: Text(
                'به‌روزرسانی: ${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
                style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: GoogleFonts.vazirmatn(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, bool isDarkMode, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.vazirmatn(
          fontSize: 16,
          height: 1.6,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
