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
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _explanationController = AnimationController(
      duration: const Duration(milliseconds: 250),
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
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isSmallPhone = screenWidth < 360 || screenHeight < 600;
        final isLargePhone =
            (screenWidth >= 360 && screenWidth < 600) ||
            (screenHeight >= 600 && screenHeight < 800);
        final isTablet = screenWidth >= 600;

        double cardMargin,
            cardPadding,
            imageHeight,
            questionFontSize,
            optionFontSize,
            explanationFontSize,
            spacing,
            buttonFontSize;

        if (isSmallPhone) {
          cardMargin = 12.0;
          cardPadding = 16.0;
          imageHeight = 180.0;
          questionFontSize = 16.0;
          optionFontSize = 14.0;
          explanationFontSize = 13.0;
          spacing = 12.0;
          buttonFontSize = 14.0;
        } else if (isLargePhone) {
          cardMargin = 16.0;
          cardPadding = 18.0;
          imageHeight = 220.0;
          questionFontSize = 17.0;
          optionFontSize = 15.0;
          explanationFontSize = 14.0;
          spacing = 14.0;
          buttonFontSize = 15.0;
        } else {
          // isTablet
          cardMargin = 24.0;
          cardPadding = 24.0;
          imageHeight = 300.0;
          questionFontSize = 22.0;
          optionFontSize = 18.0;
          explanationFontSize = 16.0;
          spacing = 24.0;
          buttonFontSize = 18.0;
        }

        final compactLayout = isSmallPhone;
        final optionButtonHeight = compactLayout ? 50.0 : 60.0;

        return Container(
          margin: EdgeInsets.all(cardMargin),
          child: Card(
            elevation: compactLayout ? 4 : 8,
            shadowColor: Colors.black.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(compactLayout ? 16 : 20),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question image if available
                  if (widget.question.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        compactLayout ? 12 : 16,
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: imageHeight),
                        width: double.infinity,
                        child: InteractiveViewer(
                          panEnabled: true,
                          minScale: 1.0,
                          maxScale: 3.0,
                          child: Image.asset(
                            widget.question.imageUrl,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: imageHeight,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(
                                    compactLayout ? 12 : 16,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: compactLayout ? 40 : 50,
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
                      height: 1.4,
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
                      optionCircleSize: compactLayout
                          ? 28.0
                          : (isLargePhone ? 32.0 : 40.0),
                      optionCircleFontSize: compactLayout
                          ? 14.0
                          : (isLargePhone ? 15.0 : 18.0),
                      iconSize: compactLayout
                          ? 20.0
                          : (isLargePhone ? 22.0 : 28.0),
                      buttonHeight: optionButtonHeight,
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
                                      compactLayout
                                          ? 8.0
                                          : (isLargePhone ? 10.0 : 12.0),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.lightbulb,
                                      color: Colors.blue,
                                      size: compactLayout
                                          ? 20.0
                                          : (isLargePhone ? 22.0 : 28.0),
                                    ),
                                  ),
                                  SizedBox(width: spacing * 0.5),
                                  Text(
                                    'توضیح:',
                                    style: TextStyle(
                                      fontSize: explanationFontSize + 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: spacing * 0.5),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                  compactLayout
                                      ? 14.0
                                      : (isLargePhone ? 16.0 : 20.0),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    compactLayout ? 10 : 12,
                                  ),
                                ),
                                child: Text(
                                  widget.question.explanation,
                                  style: TextStyle(
                                    fontSize: explanationFontSize,
                                    height: 1.4,
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
                      height: compactLayout ? 48.0 : 56.0,
                      child: ElevatedButton(
                        onPressed: widget.onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              compactLayout ? 10 : 12,
                            ),
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
    required double buttonHeight,
  }) {
    Color backgroundColor = Colors.transparent;
    Color borderColor = Colors.grey.shade300;
    Color textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    IconData? trailingIcon;

    if (showExplanation) {
      if (isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.15);
        borderColor = Colors.green;
        textColor = Colors.green.shade800;
        trailingIcon = Icons.check_circle;
      } else if (isSelected) {
        backgroundColor = Colors.red.withOpacity(0.15);
        borderColor = Colors.red;
        textColor = Colors.red.shade800;
        trailingIcon = Icons.cancel;
      }
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.15);
      borderColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.primary;
    }

    // محاسبه ارتفاع مورد نیاز برای متن
    final textPainter =
        TextPainter(
          text: TextSpan(
            text: option,
            style: TextStyle(fontSize: optionFontSize, height: 1.4),
          ),
          textDirection: TextDirection.rtl,
          maxLines: 5, // حداکثر 5 خط برای متن
        )..layout(
          maxWidth: MediaQuery.of(context).size.width - 100,
        ); // حذف فضای دایره و آیکون

    // محاسبه ارتفاع دکمه بر اساس ارتفاع متن
    final calculatedHeight = textPainter.height + (buttonHeight * 0.4);
    final finalHeight = calculatedHeight > buttonHeight
        ? calculatedHeight
        : buttonHeight;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: buttonHeight * 0.2),
      child: InkWell(
        onTap: isAnswered
            ? null
            : () {
                widget.onAnswerSelected(option);
              },
        borderRadius: BorderRadius.circular(buttonHeight * 0.2),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.08),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.04),
        child: Container(
          // استفاده از ارتفاع محاسبه شده به جای ارتفاع ثابت
          constraints: BoxConstraints(minHeight: buttonHeight),
          padding: EdgeInsets.symmetric(
            vertical: buttonHeight * 0.2,
            horizontal: buttonHeight * 0.3,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(buttonHeight * 0.2),
            border: Border.all(color: borderColor, width: 1.5),
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
                    height: 1.4,
                  ),
                  textDirection: TextDirection.rtl,
                  // افزایش حداکثر خطوط و تغییر نوع overflow
                  maxLines: 5,
                  overflow: TextOverflow.visible,
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
                  padding: EdgeInsets.only(right: optionCircleSize * 0.2),
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
