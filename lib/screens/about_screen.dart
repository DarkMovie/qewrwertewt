// lib/screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:azmonrahnamayi/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('درباره ما'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // تشخیص دقیق‌تر اندازه صفحه برای واکنش‌گرایی بهتر
              final screenHeight = constraints.maxHeight;
              final screenWidth = constraints.maxWidth;
              final isSmallPhone = screenWidth < 360 || screenHeight < 600;
              final isLargePhone =
                  (screenWidth >= 360 && screenWidth < 600) ||
                  (screenHeight >= 600 && screenHeight < 800);
              final isTablet = screenWidth >= 600;

              // محاسبه اندازه‌های واکنش‌گرا بر اساس اندازه صفحه
              double titleFontSize,
                  avatarRadius,
                  contentPadding,
                  buttonWidth,
                  descriptionFontSize,
                  cardPadding,
                  iconSize;

              if (isSmallPhone) {
                titleFontSize = 24.0;
                avatarRadius = 60.0;
                contentPadding = 16.0;
                buttonWidth = 140.0;
                descriptionFontSize = 16.0;
                cardPadding = 12.0;
                iconSize = 24.0;
              } else if (isLargePhone) {
                titleFontSize = 26.0;
                avatarRadius = 65.0;
                contentPadding = 18.0;
                buttonWidth = 150.0;
                descriptionFontSize = 17.0;
                cardPadding = 14.0;
                iconSize = 26.0;
              } else {
                // isTablet
                titleFontSize = 36.0;
                avatarRadius = 100.0;
                contentPadding = 40.0;
                buttonWidth = 200.0;
                descriptionFontSize = 18.0;
                cardPadding = 16.0;
                iconSize = 28.0;
              }

              // بهینه‌سازی فاصله‌ها برای صفحه‌های کوچک
              final spacingFactor = isSmallPhone
                  ? 0.02
                  : (isLargePhone ? 0.025 : 0.03);
              final buttonVerticalPadding = isSmallPhone ? 14.0 : 16.0;
              final buttonHorizontalPadding = isSmallPhone ? 30.0 : 40.0;
              final buttonBorderRadius = isSmallPhone ? 12.0 : 16.0;

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        screenHeight - MediaQuery.of(context).padding.top,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * spacingFactor),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: isTablet ? 600 : double.infinity,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  screenWidth * (isSmallPhone ? 0.04 : 0.05),
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(
                                isSmallPhone ? 20 : 30,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: isSmallPhone ? 12 : 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(contentPadding),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // آواتار فقط با تصویر - بدون آیکون
                                  Container(
                                    width: avatarRadius * 2,
                                    height: avatarRadius * 2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/nexzo.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * spacingFactor,
                                  ),
                                  Text(
                                    AppConstants.appName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: titleFontSize,
                                        ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'نسخه 1.0.0',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey.shade600,
                                          fontSize: descriptionFontSize * 0.85,
                                        ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * spacingFactor,
                                  ),
                                  Text(
                                    'این اپلیکیشن با هدف خدمت رسانی به شما عزیزان توسط نکزو تیم ساخته شده است.',
                                    style: TextStyle(
                                      fontSize: descriptionFontSize,
                                      height: 1.5, // افزایش خوانایی متن
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height:
                                        screenHeight * (spacingFactor * 1.3),
                                  ),
                                  _buildContactCard(
                                    context,
                                    icon: Icons.email,
                                    title: 'ایمیل',
                                    subtitle: AppConstants.developerEmail,
                                    onTap: () async {
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: AppConstants.developerEmail,
                                      );
                                      await _launchUrl(
                                        context,
                                        emailLaunchUri,
                                        'خطا در باز کردن ایمیل',
                                      );
                                    },
                                    cardPadding: cardPadding,
                                    iconSize: iconSize,
                                  ),
                                  SizedBox(
                                    height:
                                        screenHeight * (spacingFactor * 0.7),
                                  ),
                                  _buildContactCard(
                                    context,
                                    icon: Icons.language,
                                    title: 'سایت',
                                    subtitle: AppConstants.developerWebsite,
                                    onTap: () async {
                                      final Uri websiteLaunchUri = Uri.parse(
                                        'https://${AppConstants.developerWebsite}',
                                      );
                                      await _launchUrl(
                                        context,
                                        websiteLaunchUri,
                                        'خطا در باز کردن سایت',
                                      );
                                    },
                                    cardPadding: cardPadding,
                                    iconSize: iconSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * (spacingFactor * 1.3)),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * spacingFactor,
                          ),
                          child: SizedBox(
                            width: buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: buttonVerticalPadding,
                                  horizontal: buttonHorizontalPadding,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    buttonBorderRadius,
                                  ),
                                ),
                              ),
                              child: const Text('بازگشت'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(
    BuildContext context,
    Uri url,
    String errorMessage,
  ) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showErrorSnackBar(context, errorMessage);
      }
    } catch (e) {
      _showErrorSnackBar(context, errorMessage);
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required double cardPadding,
    required double iconSize,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(cardPadding * 0.8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: iconSize,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade600,
                size: iconSize * 0.8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

