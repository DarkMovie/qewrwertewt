// lib/widgets/styled_button.dart
import 'package:flutter/material.dart';

class StyledButton extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final double? subtitleFontSize;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;

  const StyledButton({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.subtitleFontSize,
    this.iconSize,
    this.padding,
    this.borderRadius,
    this.elevation,
  });

  @override
  State<StyledButton> createState() => _StyledButtonState();
}

class _StyledButtonState extends State<StyledButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    _animationController.reverse();
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth > 600;

        // محاسبه اندازه‌های واکنش‌گرا
        final defaultFontSize = isTablet ? 20.0 : 18.0;
        final defaultSubtitleFontSize = isTablet ? 16.0 : 14.0;
        final defaultIconSize = isTablet ? 32.0 : 28.0;
        final defaultPadding = isTablet
            ? const EdgeInsets.all(24.0)
            : const EdgeInsets.all(20.0);
        final defaultBorderRadius = isTablet ? 24.0 : 20.0;
        final defaultElevation = isTablet ? 6.0 : 4.0;

        // استفاده از مقادیر سفارشی یا پیش‌فرض
        final fontSize = widget.fontSize ?? defaultFontSize;
        final subtitleFontSize =
            widget.subtitleFontSize ?? defaultSubtitleFontSize;
        final iconSize = widget.iconSize ?? defaultIconSize;
        final padding = widget.padding ?? defaultPadding;
        final borderRadius = widget.borderRadius ?? defaultBorderRadius;
        final elevation = widget.elevation ?? defaultElevation;

        // تعیین رنگ‌ها
        final bgColor =
            widget.backgroundColor ?? Theme.of(context).colorScheme.primary;
        final txtColor = widget.textColor ?? Colors.white;

        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Material(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderRadius),
                elevation: elevation,
                child: InkWell(
                  onTap: widget.onTap,
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  borderRadius: BorderRadius.circular(borderRadius),
                  splashColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Container(
                    padding: padding,
                    child: Row(
                      children: [
                        // آیکون دکمه
                        Container(
                          padding: EdgeInsets.all(iconSize * 0.4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: txtColor,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(width: iconSize * 0.6),

                        // متن دکمه
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: txtColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (widget.subtitle != null) ...[
                                SizedBox(height: fontSize * 0.2),
                                Text(
                                  widget.subtitle!,
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: txtColor.withOpacity(0.8),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // آیکون فلش
                        Icon(
                          Icons.arrow_forward_ios,
                          color: txtColor,
                          size: iconSize * 0.8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
