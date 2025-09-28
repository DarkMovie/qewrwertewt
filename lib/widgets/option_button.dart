// lib/widgets/option_button.dart
import 'package:flutter/material.dart';

class OptionButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback? onTap;
  final double? fontSize;

  const OptionButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
    this.fontSize,
  });

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // نقطه‌های شکست هوشمندانه برای ریسپانسیو
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isSmallPhone = screenWidth < 360 || screenHeight < 600;
        final isLargePhone =
            (screenWidth >= 360 && screenWidth < 600) ||
            (screenHeight >= 600 && screenHeight < 800);
        final isTablet = screenWidth >= 600;

        // محاسبه ابعاد واکنش‌گرا
        final fontSize =
            widget.fontSize ??
            (isSmallPhone
                ? 14.0
                : isLargePhone
                ? 15.0
                : 16.0);
        final padding = isSmallPhone
            ? 14.0
            : isLargePhone
            ? 16.0
            : 18.0;
        final iconSize = isSmallPhone
            ? 20.0
            : isLargePhone
            ? 22.0
            : 24.0;
        final margin = isSmallPhone
            ? 8.0
            : isLargePhone
            ? 10.0
            : 12.0;
        final borderRadius = isSmallPhone
            ? 12.0
            : isLargePhone
            ? 14.0
            : 16.0;
        final borderWidth = widget.isSelected ? 1.5 : 1.0;

        // سیستم رنگ‌های واکنش‌گرا
        Color backgroundColor = Colors.transparent;
        Color textColor =
            Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
        Color borderColor = Colors.grey.shade300;
        IconData? icon;
        Color? iconColor;

        if (widget.showResult) {
          if (widget.isCorrect) {
            backgroundColor = Colors.green.shade50;
            textColor = Colors.green.shade800;
            borderColor = Colors.green.shade300;
            icon = Icons.check_circle;
            iconColor = Colors.green.shade600;
          } else if (widget.isSelected && !widget.isCorrect) {
            backgroundColor = Colors.red.shade50;
            textColor = Colors.red.shade800;
            borderColor = Colors.red.shade300;
            icon = Icons.cancel;
            iconColor = Colors.red.shade600;
          }
        } else if (widget.isSelected) {
          backgroundColor = Theme.of(context).primaryColor.withOpacity(0.08);
          textColor = Theme.of(context).primaryColor;
          borderColor = Theme.of(context).primaryColor.withOpacity(0.5);
        }

        return Container(
          margin: EdgeInsets.only(bottom: margin),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Material(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  elevation: widget.isSelected ? 1 : 0.5,
                  child: InkWell(
                    onTap: widget.onTap,
                    onTapDown: (_) => _animationController.forward(),
                    onTapUp: (_) => _animationController.reverse(),
                    onTapCancel: () => _animationController.reverse(),
                    borderRadius: BorderRadius.circular(borderRadius),
                    splashColor: widget.showResult
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    highlightColor: widget.showResult
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.05),
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: borderColor,
                          width: borderWidth,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.text,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: widget.isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: textColor,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (icon != null)
                            Padding(
                              padding: EdgeInsets.only(right: padding * 0.5),
                              child: Icon(
                                icon,
                                color: iconColor,
                                size: iconSize,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
