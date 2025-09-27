// lib/widgets/progress_indicator.dart
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final double? height; // ارتفاع سفارشی برای نوار پیشرفت
  final double? fontSize; // اندازه فونت سفارشی
  final bool showPercentage; // نمایش یا عدم نمایش درصد
  final Color? backgroundColor; // رنگ پس‌زمینه سفارشی
  final Color? progressColor; // رنگ پیشرفت سفارشی

  const CustomProgressIndicator({
    super.key,
    required this.current,
    required this.total,
    this.height,
    this.fontSize,
    this.showPercentage = true,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth > 600;

        // محاسبه اندازه‌های واکنش‌گرا
        final progressHeight = height ?? (isTablet ? 12.0 : 8.0);
        final textFontSize = fontSize ?? (isTablet ? 18.0 : 16.0);
        final percentageFontSize = fontSize != null
            ? fontSize! * 0.9
            : (isTablet ? 16.0 : 14.0);
        final spacing = isTablet ? 12.0 : 8.0;

        // محاسبه درصد با مدیریت خطا
        final progress = total > 0 ? current / total : 0.0;
        final percentage = (progress * 100).toInt();

        // تعیین رنگ‌ها
        final bgColor = backgroundColor ?? Colors.grey.shade300;
        final progColor = progressColor ?? Theme.of(context).primaryColor;

        return Column(
          children: [
            // نوار پیشرفت
            Container(
              height: progressHeight,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(progressHeight / 2),
              ),
              child: Stack(
                children: [
                  // بخش پیشرفت
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: progColor,
                      borderRadius: BorderRadius.circular(progressHeight / 2),
                    ),
                  ),

                  // متن درصد در مرکز نوار پیشرفت
                  if (showPercentage)
                    Center(
                      child: Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: percentageFontSize,
                          fontWeight: FontWeight.bold,
                          color: progress > 0.5 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: spacing),

            // متن اطلاعات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'سوال $current از $total',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showPercentage)
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: percentageFontSize,
                      fontWeight: FontWeight.bold,
                      color: progColor,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
