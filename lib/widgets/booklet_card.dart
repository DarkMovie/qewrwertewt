// lib/widgets/booklet_card.dart
import 'package:flutter/material.dart';

class BookletCard extends StatefulWidget {
  final int number;
  final VoidCallback onTap;

  const BookletCard({super.key, required this.number, required this.onTap});

  @override
  State<BookletCard> createState() => _BookletCardState();
}

class _BookletCardState extends State<BookletCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // افزودن انیمیشن فشردگی برای بازخورد لمسی
    setState(() {
      _isTapped = true;
    });

    // اجرای انیمیشن فشردگی
    _animationController.reverse().then((_) {
      if (mounted) {
        _animationController.forward().then((_) {
          if (mounted) {
            setState(() {
              _isTapped = false;
            });
            // فراخوانی تابع onTap پس از اتمام انیمیشن
            widget.onTap();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;
        final isTablet = cardWidth > 150; // تشخیص تبلت بر اساس اندازه کارت

        // محاسبه اندازه‌های واکنش‌گرا
        final numberFontSize = isTablet ? 28.0 : 24.0;
        final titleFontSize = isTablet ? 18.0 : 16.0;
        final buttonFontSize = isTablet ? 14.0 : 12.0;
        final iconPadding = isTablet ? 16.0 : 12.0;
        final spacing = isTablet ? 16.0 : 12.0;
        final buttonPadding = isTablet ? 16.0 : 12.0;
        final buttonVerticalPadding = isTablet ? 6.0 : 4.0;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            // تنظیم مقیاس بر اساس حالت فشرده شده
            final scale = _isTapped ? 0.95 : _scaleAnimation.value;

            return Transform.scale(
              scale: scale,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: InkWell(
                  onTap: _handleTap,
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: isTablet ? 12 : 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(iconPadding),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${widget.number}',
                            style: TextStyle(
                              fontSize: numberFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing),
                        Text(
                          'دفترچه ${widget.number}',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: spacing * 0.7),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: buttonPadding,
                            vertical: buttonVerticalPadding,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'شروع آزمون',
                            style: TextStyle(
                              fontSize: buttonFontSize,
                              color: Colors.white,
                            ),
                          ),
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
