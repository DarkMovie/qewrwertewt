// lib/widgets/booklet_card.dart
import 'package:flutter/material.dart';

class BookletCard extends StatefulWidget {
  final int number;
  final VoidCallback onTap;
  final String? title;
  final Color? primaryColor;
  final Color? secondaryColor;

  const BookletCard({
    super.key,
    required this.number,
    required this.onTap,
    this.title,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  State<BookletCard> createState() => _BookletCardState();
}

class _BookletCardState extends State<BookletCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late AnimationController _bounceController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _bounceAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() => _isPressed = true);
    _scaleController.reverse().then((_) {
      if (mounted) {
        _scaleController.forward().then((_) {
          if (mounted) {
            setState(() => _isPressed = false);
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
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 360;
        final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
        final isLargeScreen = screenWidth >= 600;

        // Responsive sizing
        final cardWidth = constraints.maxWidth;
        final cardHeight = isSmallScreen
            ? cardWidth *
                  1.15 // Reduced height
            : isMediumScreen
            ? cardWidth * 1.05
            : cardWidth * 0.9;

        // Responsive font sizes
        final numberSize = isSmallScreen
            ? 28.0
            : isMediumScreen
            ? 32.0
            : 36.0;
        final titleSize = isSmallScreen
            ? 16.0
            : isMediumScreen
            ? 18.0
            : 20.0;

        // Responsive padding
        final padding = isSmallScreen
            ? 12.0
            : isMediumScreen
            ? 16.0
            : 20.0;
        final borderRadius = isSmallScreen
            ? 12.0
            : isMediumScreen
            ? 16.0
            : 20.0;

        final primaryColor =
            widget.primaryColor ?? Theme.of(context).colorScheme.primary;
        final secondaryColor =
            widget.secondaryColor ?? Theme.of(context).colorScheme.secondary;

        return AnimatedBuilder(
          animation: Listenable.merge([
            _scaleController,
            _shimmerController,
            _bounceController,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value * (_isPressed ? 0.95 : 1.0),
              child: Stack(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _handleTap,
                      borderRadius: BorderRadius.circular(borderRadius),
                      splashColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.1),
                      child: Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          gradient: LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: isSmallScreen ? 8 : 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Number circle with bounce animation
                              AnimatedBuilder(
                                animation: _bounceAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      -6 * (1 - _bounceAnimation.value),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        isSmallScreen ? 10 : 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.25),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.15,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '${widget.number}',
                                          style: TextStyle(
                                            fontSize: numberSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                offset: const Offset(0, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: isSmallScreen ? 10 : 14),

                              // Title with shimmer effect
                              Expanded(
                                child: Center(
                                  child: Stack(
                                    children: [
                                      // Main text
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          widget.title ??
                                              'دفترچه ${widget.number}',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: titleSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(
                                                  0.4,
                                                ),
                                                offset: const Offset(0, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Shimmer effect
                                      ClipRect(
                                        child: AnimatedBuilder(
                                          animation: _shimmerAnimation,
                                          builder: (context, child) {
                                            return Transform.translate(
                                              offset: Offset(
                                                _shimmerAnimation.value * 100,
                                                0,
                                              ),
                                              child: Container(
                                                width: 30,
                                                height: titleSize * 1.2,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.white.withOpacity(
                                                        0.3,
                                                      ),
                                                      Colors.transparent,
                                                    ],
                                                    stops: const [
                                                      0.0,
                                                      0.5,
                                                      1.0,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Top edge highlight
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom edge highlight
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
