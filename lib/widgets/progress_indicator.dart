// lib/widgets/progress_indicator.dart
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final double? height;
  final double? fontSize;
  final bool showPercentage;
  final Color? backgroundColor;
  final Color? progressColor;

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
        // تشخیص دقیق‌تر اندازه صفحه برای واکنش‌گرایی بهتر
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallPhone = screenWidth < 360;
        final isLargePhone = screenWidth >= 360 && screenWidth < 600;
        final isTablet = screenWidth >= 600;

        // محاسبه اندازه‌های واکنش‌گرا بر اساس اندازه صفحه
        double progressHeight, textFontSize, percentageFontSize, spacing;

        if (isSmallPhone) {
          progressHeight = height ?? 6.0;
          textFontSize = fontSize ?? 14.0;
          percentageFontSize = fontSize != null ? fontSize! * 0.85 : 12.0;
          spacing = 6.0;
        } else if (isLargePhone) {
          progressHeight = height ?? 8.0;
          textFontSize = fontSize ?? 15.0;
          percentageFontSize = fontSize != null ? fontSize! * 0.9 : 13.0;
          spacing = 8.0;
        } else {
          // isTablet
          progressHeight = height ?? 12.0;
          textFontSize = fontSize ?? 18.0;
          percentageFontSize = fontSize != null ? fontSize! * 0.9 : 16.0;
          spacing = 12.0;
        }

        // محاسبه درصد با مدیریت خطا
        final progress = total > 0 ? current / total : 0.0;
        final percentage = (progress * 100).toInt();

        // تعیین رنگ‌ها
        final bgColor = backgroundColor ?? Colors.grey.shade300;
        final progColor = progressColor ?? Theme.of(context).primaryColor;

        // بهینه‌سازی فضای عمودی برای موبایل
        final compactLayout = isSmallPhone || isLargePhone;

        return compactLayout
            ? _buildCompactLayout(
                context,
                constraints,
                progress,
                percentage,
                progressHeight,
                textFontSize,
                percentageFontSize,
                spacing,
                bgColor,
                progColor,
              )
            : _buildStandardLayout(
                context,
                constraints,
                progress,
                percentage,
                progressHeight,
                textFontSize,
                percentageFontSize,
                spacing,
                bgColor,
                progColor,
              );
      },
    );
  }

  Widget _buildCompactLayout(
    BuildContext context,
    BoxConstraints constraints,
    double progress,
    int percentage,
    double progressHeight,
    double textFontSize,
    double percentageFontSize,
    double spacing,
    Color bgColor,
    Color progColor,
  ) {
    return Row(
      children: [
        // متن اطلاعات در سمت چپ
        Expanded(
          flex: 2,
          child: Text(
            'سوال $current از $total',
            style: TextStyle(
              fontSize: textFontSize,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(width: spacing),

        // نوار پیشرفت در وسط
        Expanded(
          flex: 5,
          child: Container(
            height: progressHeight,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(progressHeight / 2),
            ),
            child: Stack(
              children: [
                // بخش پیشرفت
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 300,
                  ), // کاهش مدت زمان انیمیشن برای عملکرد بهتر
                  curve: Curves.easeInOut,
                  width:
                      constraints.maxWidth *
                      0.5 *
                      progress, // تنظیم عرض بر اساس فضای موجود
                  decoration: BoxDecoration(
                    color: progColor,
                    borderRadius: BorderRadius.circular(progressHeight / 2),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: spacing),

        // درصد در سمت راست
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
    );
  }

  Widget _buildStandardLayout(
    BuildContext context,
    BoxConstraints constraints,
    double progress,
    int percentage,
    double progressHeight,
    double textFontSize,
    double percentageFontSize,
    double spacing,
    Color bgColor,
    Color progColor,
  ) {
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
  }
}
