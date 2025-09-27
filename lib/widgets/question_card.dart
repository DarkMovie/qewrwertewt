// lib/widgets/question_card.dart
import 'package:flutter/material.dart';
import 'package:azmonrahnamayi/models/question.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final bool isAnswered;
  final String? selectedAnswer;
  final bool showExplanation;
  final Function(String) onAnswerSelected;
  final VoidCallback onNextPressed;

  const QuestionCard({
    super.key,
    required this.question,
    required this.isAnswered,
    this.selectedAnswer,
    required this.showExplanation,
    required this.onAnswerSelected,
    required this.onNextPressed,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _explanationController;
  late Animation<double> _explanationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _explanationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _explanationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _explanationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    if (widget.showExplanation) {
      _explanationController.forward();
    }
  }

  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.showExplanation != widget.showExplanation) {
      if (widget.showExplanation) {
        _explanationController.forward();
      } else {
        _explanationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _explanationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final isTablet = screenWidth > 600;

        // محاسبه اندازه‌های واکنش‌گرا
        final cardMargin = isTablet ? 24.0 : 16.0;
        final cardPadding = isTablet ? 24.0 : 20.0;
        final imageHeight = isTablet ? 300.0 : 250.0; // افزایش ارتفاع تصویر
        final questionFontSize = isTablet ? 22.0 : 18.0;
        final optionFontSize = isTablet ? 18.0 : 16.0;
        final explanationFontSize = isTablet ? 16.0 : 14.0;
        final spacing = isTablet ? 24.0 : 16.0;
        final buttonFontSize = isTablet ? 18.0 : 16.0;

        return Container(
          margin: EdgeInsets.all(cardMargin),
          child: Card(
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question image if available
                  if (widget.question.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: imageHeight * 1.5, // افزایش حداکثر ارتفاع
                        ),
                        width: double.infinity,
                        child: InteractiveViewer(
                          // اضافه کردن قابلیت زوم
                          panEnabled: true,
                          minScale: 1.0,
                          maxScale: 4.0, // امکان زوم تا 4 برابر
                          child: Image.asset(
                            widget.question.imageUrl,
                            fit: BoxFit.contain, // نمایش کامل تصویر بدون برش
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: imageHeight,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: isTablet ? 60 : 50,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                  if (widget.question.imageUrl.isNotEmpty)
                    SizedBox(height: spacing),

                  // Question text
                  Text(
                    widget.question.question,
                    style: TextStyle(
                      fontSize: questionFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing),

                  // Options
                  ...widget.question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = widget.selectedAnswer == option;
                    final isCorrect = option == widget.question.correctAnswer;

                    return _buildOptionButton(
                      context,
                      option: option,
                      index: index,
                      isSelected: isSelected,
                      isCorrect: isCorrect,
                      isAnswered: widget.isAnswered,
                      showExplanation: widget.showExplanation,
                      optionFontSize: optionFontSize,
                      optionCircleSize: isTablet ? 40.0 : 32.0,
                      optionCircleFontSize: isTablet ? 18.0 : 16.0,
                      iconSize: isTablet ? 28.0 : 24.0,
                    );
                  }).toList(),
                  SizedBox(height: spacing),

                  // Explanation section
                  if (widget.showExplanation &&
                      widget.question.explanation.isNotEmpty) ...[
                    AnimatedBuilder(
                      animation: _explanationAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _explanationAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              SizedBox(height: spacing * 0.75),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                      isTablet ? 12.0 : 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.lightbulb,
                                      color: Colors.blue,
                                      size: isTablet ? 28.0 : 24.0,
                                    ),
                                  ),
                                  SizedBox(width: spacing * 0.5),
                                  Text(
                                    'توضیح:',
                                    style: TextStyle(
                                      fontSize: explanationFontSize + 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: spacing * 0.5),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.question.explanation,
                                  style: TextStyle(
                                    fontSize: explanationFontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],

                  // Next button (only show if explanation is not shown)
                  if (!widget.showExplanation && widget.isAnswered)
                    SizedBox(height: spacing),

                  if (!widget.showExplanation && widget.isAnswered)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 20.0 : 16.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'ادامه',
                          style: TextStyle(fontSize: buttonFontSize),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required String option,
    required int index,
    required bool isSelected,
    required bool isCorrect,
    required bool isAnswered,
    required bool showExplanation,
    required double optionFontSize,
    required double optionCircleSize,
    required double optionCircleFontSize,
    required double iconSize,
  }) {
    Color backgroundColor = Colors.transparent;
    Color borderColor = Colors.grey.shade300;
    Color textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    IconData? trailingIcon;

    if (showExplanation) {
      if (isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.2);
        borderColor = Colors.green;
        textColor = Colors.green.shade800;
        trailingIcon = Icons.check_circle;
      } else if (isSelected) {
        backgroundColor = Colors.red.withOpacity(0.2);
        borderColor = Colors.red;
        textColor = Colors.red.shade800;
        trailingIcon = Icons.cancel;
      }
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.2);
      borderColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.primary;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isAnswered
            ? null
            : () {
                widget.onAnswerSelected(option);
              },
        borderRadius: BorderRadius.circular(12),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: optionCircleSize * 0.5,
            horizontal: optionCircleSize * 0.6,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              // Option text
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: optionFontSize,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: textColor,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),

              // Option letter (A, B, C, D)
              Container(
                width: optionCircleSize,
                height: optionCircleSize,
                decoration: BoxDecoration(
                  color: isSelected ? borderColor : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: TextStyle(
                      fontSize: optionCircleFontSize,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Result icon (if answered)
              if (trailingIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    trailingIcon,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: iconSize,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
