// lib/screens/sources_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:azmonrahnamayi/utils/constants.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'منابع و سیاست حریم خصوصی',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('منابع محتوا', isDarkMode),
            const SizedBox(height: 12),
            _buildContentCard(
              context,
              isDarkMode,
              'تمامی محتوای آموزشی، سوالات آزمون و مطالب ارائه شده در این اپلیکیشن توسط تیم نکزو (Nexzo Team) تهیه، گردآوری و تدوین شده است. این محتوا حاصل تحقیقات و تلاش‌های تیم ما است و از منابع معتبر داخلی و بین‌المللی در حوزه راهنمایی و رانندگی استفاده شده است.',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('منابع تیم نکزو', isDarkMode),
            const SizedBox(height: 12),
            _buildLinkCard(
              context,
              isDarkMode,
              'سایت اصلی نکزو',
              'nexzo.ir',
              'https://nexzo.ir',
            ),
            const SizedBox(height: 12),
            _buildLinkCard(
              context,
              isDarkMode,
              'سایت آزمون نکزو',
              'azmoon.nexzo.ir',
              'https://azmoon.nexzo.ir',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('سیاست حریم خصوصی', isDarkMode),
            const SizedBox(height: 12),
            _buildContentCard(
              context,
              isDarkMode,
              'این اپلیکیشن به صورت کاملاً آفلاین عمل می‌کند و هیچ‌گونه داده‌ای از کاربران را در سرورهای خود یا سرورهای شخص ثالث ذخیره نمی‌کند. تمام اطلاعات شما از جمله سوالات پاسخ داده شده، نتایج آزمون‌ها و تنظیمات شخصی، فقط در حافظه دستگاه شما ذخیره می‌شوند و ما به هیچ وجه به این داده‌ها دسترسی نداریم.',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('کپی‌رایت', isDarkMode),
            const SizedBox(height: 12),
            _buildContentCard(
              context,
              isDarkMode,
              'تمامی حقوق مادی و معنوی این اپلیکیشن و محتوای آن متعلق به تیم نکزو (Nexzo Team) می‌باشد. هرگونه کپی‌برداری یا استفاده غیرمجاز از محتوای این اپلیکیشن بدون ذکر منبع و کسب اجازه کتبی، پیگرد قانونی دارد.',
            ),

            const SizedBox(height: 32),

            Center(
              child: Text(
                'نسخه ${AppConstants.appVersion}',
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

  Widget _buildLinkCard(
    BuildContext context,
    bool isDarkMode,
    String title,
    String subtitle,
    String url,
  ) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'خطا در باز کردن لینک',
                style: GoogleFonts.vazirmatn(),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.language,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
