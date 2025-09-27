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
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
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
    if (widget.onTap != null) {
      _animationController.forward();
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _animationController.reverse();
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
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
        final isTablet = constraints.maxWidth > 600;

        // محاسبه اندازه‌های واکنش‌گرا
        final fontSize = widget.fontSize ?? (isTablet ? 18.0 : 16.0);
        final paddingVertical = isTablet ? 20.0 : 16.0;
        final paddingHorizontal = isTablet ? 24.0 : 20.0;
        final iconSize = isTablet ? 28.0 : 24.0;
        final marginVertical = isTablet ? 16.0 : 12.0;
        final borderRadius = isTablet ? 16.0 : 12.0;
        final borderWidth = widget.isSelected ? 2.5 : 1.5;

        // تعیین رنگ‌ها بر اساس وضعیت
        Color backgroundColor = Colors.transparent;
        Color textColor =
            Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
        Color borderColor = Colors.grey.shade300;
        IconData? trailingIcon;
        Color? iconColor;

        if (widget.showResult) {
          if (widget.isCorrect) {
            backgroundColor = Colors.green.withOpacity(0.2);
            textColor = Colors.green.shade800;
            borderColor = Colors.green;
            trailingIcon = Icons.check_circle;
            iconColor = Colors.green;
          } else if (widget.isSelected && !widget.isCorrect) {
            backgroundColor = Colors.red.withOpacity(0.2);
            textColor = Colors.red.shade800;
            borderColor = Colors.red;
            trailingIcon = Icons.cancel;
            iconColor = Colors.red;
          }
        } else if (widget.isSelected) {
          backgroundColor = Theme.of(context).primaryColor.withOpacity(0.2);
          textColor = Theme.of(context).primaryColor;
          borderColor = Theme.of(context).primaryColor;
        }

        return Container(
          margin: EdgeInsets.only(bottom: marginVertical),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Material(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  elevation: widget.isSelected ? 2 : 0,
                  child: InkWell(
                    onTap: widget.onTap,
                    onTapDown: _handleTapDown,
                    onTapUp: _handleTapUp,
                    onTapCancel: _handleTapCancel,
                    borderRadius: BorderRadius.circular(borderRadius),
                    splashColor: widget.showResult
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.2),
                    highlightColor: widget.showResult
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: paddingVertical,
                        horizontal: paddingHorizontal,
                      ),
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
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          if (trailingIcon != null)
                            Padding(
                              padding: EdgeInsets.only(right: iconSize * 0.3),
                              child: Icon(
                                trailingIcon,
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
