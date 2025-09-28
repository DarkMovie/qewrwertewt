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
  final bool? isLoading;
  final Gradient? gradient;
  final Color? borderColor;
  final double? borderWidth;
  final bool? showShadow;
  final Widget? trailing;

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
    this.isLoading = false,
    this.gradient,
    this.borderColor,
    this.borderWidth,
    this.showShadow = true,
    this.trailing,
  });

  @override
  State<StyledButton> createState() => _StyledButtonState();
}

class _StyledButtonState extends State<StyledButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.ease),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isLoading != true) {
      _animationController.forward();
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isLoading != true) {
      _animationController.reverse();
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _handleTapCancel() {
    if (widget.isLoading != true) {
      _animationController.reverse();
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isSmallPhone = screenWidth < 360 || screenHeight < 600;
        final isLargePhone =
            (screenWidth >= 360 && screenWidth < 600) ||
            (screenHeight >= 600 && screenHeight < 800);
        final isTablet = screenWidth >= 600;

        // محاسبه اندازه‌های واکنش‌گرا بر اساس اندازه صفحه
        double fontSize, subtitleFontSize, iconSize, borderRadius, elevation;
        EdgeInsetsGeometry padding;

        if (isSmallPhone) {
          fontSize = widget.fontSize ?? 16.0;
          subtitleFontSize = widget.subtitleFontSize ?? 13.0;
          iconSize = widget.iconSize ?? 24.0;
          padding = widget.padding ?? const EdgeInsets.all(16.0);
          borderRadius = widget.borderRadius ?? 16.0;
          elevation = widget.elevation ?? 3.0;
        } else if (isLargePhone) {
          fontSize = widget.fontSize ?? 17.0;
          subtitleFontSize = widget.subtitleFontSize ?? 14.0;
          iconSize = widget.iconSize ?? 26.0;
          padding = widget.padding ?? const EdgeInsets.all(18.0);
          borderRadius = widget.borderRadius ?? 18.0;
          elevation = widget.elevation ?? 4.0;
        } else {
          // isTablet
          fontSize = widget.fontSize ?? 20.0;
          subtitleFontSize = widget.subtitleFontSize ?? 16.0;
          iconSize = widget.iconSize ?? 32.0;
          padding = widget.padding ?? const EdgeInsets.all(24.0);
          borderRadius = widget.borderRadius ?? 24.0;
          elevation = widget.elevation ?? 6.0;
        }

        // تعیین رنگ‌ها
        final bgColor =
            widget.backgroundColor ??
            (widget.gradient != null
                ? Colors.transparent
                : Theme.of(context).colorScheme.primary);
        final txtColor = widget.textColor ?? Colors.white;
        final borderColor = widget.borderColor ?? Colors.transparent;
        final borderWidth = widget.borderWidth ?? 0.0;

        // بهینه‌سازی فاصله‌ها برای صفحه‌های کوچک
        final iconPadding = iconSize * (isSmallPhone ? 0.3 : 0.4);
        final spacing = iconSize * (isSmallPhone ? 0.5 : 0.6);

        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Material(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderRadius),
                elevation: widget.showShadow! ? elevation : 0,
                shadowColor: widget.showShadow!
                    ? (bgColor.withOpacity(0.3))
                    : Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading != true ? widget.onTap : null,
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  borderRadius: BorderRadius.circular(borderRadius),
                  splashColor: Colors.white.withOpacity(0.25),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: widget.gradient,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(
                        color: borderColor,
                        width: borderWidth,
                      ),
                    ),
                    padding: padding,
                    child: widget.isLoading == true
                        ? _buildLoadingContent(iconSize, txtColor)
                        : _buildNormalContent(
                            context,
                            iconSize,
                            iconPadding,
                            spacing,
                            fontSize,
                            subtitleFontSize,
                            txtColor,
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

  Widget _buildNormalContent(
    BuildContext context,
    double iconSize,
    double iconPadding,
    double spacing,
    double fontSize,
    double subtitleFontSize,
    Color txtColor,
  ) {
    return Row(
      children: [
        // آیکون دکمه با طراحی جدید
        Container(
          padding: EdgeInsets.all(iconPadding),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(widget.icon, color: txtColor, size: iconSize),
        ),
        SizedBox(width: spacing),

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
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              if (widget.subtitle != null) ...[
                SizedBox(height: fontSize * 0.15),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: txtColor.withOpacity(0.8),
                    height: 1.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ],
          ),
        ),

        // آیکون فلش یا ویجت سفارشی
        widget.trailing ??
            Icon(
              Icons.arrow_forward_ios,
              color: txtColor,
              size: iconSize * 0.75,
            ),
      ],
    );
  }

  Widget _buildLoadingContent(double iconSize, Color txtColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(txtColor),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'لطفا صبر کنید...',
          style: TextStyle(
            fontSize: 16,
            color: txtColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
