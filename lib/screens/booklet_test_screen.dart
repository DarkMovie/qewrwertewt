// lib/screens/booklet_test_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azmonrahnamayi/providers/test_provider.dart';
import 'package:azmonrahnamayi/screens/result_screen.dart';
import 'package:azmonrahnamayi/widgets/question_card.dart';

class BookletTestScreen extends StatefulWidget {
  final int bookletNumber;

  const BookletTestScreen({super.key, required this.bookletNumber});

  @override
  State<BookletTestScreen> createState() => _BookletTestScreenState();
}

class _BookletTestScreenState extends State<BookletTestScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _resultController;
  late Animation<double> _resultAnimation;
  bool _isSavingResult = false;
  bool _isNavigating = false;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize page controller
    _pageController = PageController();

    // Initialize animation controllers with optimized durations for mobile
    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: 200,
      ), // Reduced for better performance
      vsync: this,
    );

    _resultController = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ), // Reduced for better performance
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _resultAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );

    // Start the test after the frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final testProvider = Provider.of<TestProvider>(context, listen: false);
        testProvider.startBookletTest(widget.bookletNumber);

        // Start animations
        _animationController.forward();
        _resultController.forward();

        setState(() {
          _hasInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  Future<void> _finishTest(TestProvider testProvider) async {
    if (_isSavingResult || _isNavigating) return;

    setState(() {
      _isSavingResult = true;
    });

    try {
      await testProvider.saveTestResult('booklet${widget.bookletNumber}');

      if (mounted) {
        setState(() {
          _isNavigating = true;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              score: testProvider.score,
              totalQuestions: testProvider.currentQuestions.length,
              testType: 'booklet${widget.bookletNumber}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در ذخیره نتیجه آزمون: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        setState(() {
          _isSavingResult = false;
        });
      }
    }
  }

  void _navigateToQuestion(int index) {
    if (_pageController.hasClients && mounted) {
      _pageController.animateToPage(
        index,
        duration: const Duration(
          milliseconds: 200,
        ), // Reduced for better performance
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestProvider>(
      builder: (context, testProvider, child) {
        // Check if test is initialized
        if (!_hasInitialized || testProvider.currentQuestions.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    'در حال بارگذاری آزمون...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        // Check if test is finished
        if (testProvider.currentQuestionIndex >=
            testProvider.currentQuestions.length) {
          // Test finished
          if (!_isSavingResult && !_isNavigating) {
            // Use addPostFrameCallback to avoid calling setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_isNavigating) {
                _finishTest(testProvider);
              }
            });
          }

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    'در حال ذخیره نتیجه آزمون...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        final question =
            testProvider.currentQuestions[testProvider.currentQuestionIndex];
        final isAnswered = testProvider.isQuestionAnswered(
          testProvider.currentQuestionIndex,
        );
        final selectedAnswer = testProvider.getSelectedAnswer(
          testProvider.currentQuestionIndex,
        );
        final progress =
            (testProvider.currentQuestionIndex + 1) /
            testProvider.currentQuestions.length;

        // Update page controller when current question index changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients &&
              _pageController.page?.round() !=
                  testProvider.currentQuestionIndex &&
              mounted) {
            _navigateToQuestion(testProvider.currentQuestionIndex);
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: LayoutBuilder(
              builder: (context, constraints) {
                // More precise device size detection
                final screenWidth = constraints.maxWidth;
                final isSmallPhone = screenWidth < 360;
                final isLargePhone = screenWidth >= 360 && screenWidth < 600;
                final isTablet = screenWidth >= 600;

                final titleFontSize = isSmallPhone
                    ? 16.0
                    : isLargePhone
                    ? 18.0
                    : 20.0;

                return Text(
                  'دفترچه ${widget.bookletNumber}',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${testProvider.score}/${testProvider.currentQuestions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            elevation: 0,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              // More precise device size detection
              final screenHeight = constraints.maxHeight;
              final screenWidth = constraints.maxWidth;
              final isSmallPhone = screenWidth < 360 || screenHeight < 600;
              final isLargePhone =
                  (screenWidth >= 360 && screenWidth < 600) ||
                  (screenHeight >= 600 && screenHeight < 800);
              final isTablet = screenWidth >= 600;

              // Calculate responsive sizes
              double paddingValue,
                  spacing,
                  progressHeight,
                  buttonFontSize,
                  progressTextSize,
                  buttonHeight;

              if (isSmallPhone) {
                paddingValue = 12.0;
                spacing = 12.0;
                progressHeight = 6.0;
                buttonFontSize = 14.0;
                progressTextSize = 14.0;
                buttonHeight = screenHeight * 0.05;
              } else if (isLargePhone) {
                paddingValue = 16.0;
                spacing = 16.0;
                progressHeight = 8.0;
                buttonFontSize = 15.0;
                progressTextSize = 15.0;
                buttonHeight = screenHeight * 0.06;
              } else {
                // isTablet
                paddingValue = 24.0;
                spacing = 24.0;
                progressHeight = 10.0;
                buttonFontSize = 18.0;
                progressTextSize = 18.0;
                buttonHeight = screenHeight * 0.07;
              }

              // Optimize spacing for mobile
              final buttonSpacing = screenWidth * 0.04;

              return Column(
                children: [
                  // Progress bar with animation
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingValue,
                      vertical: paddingValue * 0.5,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'سوال ${testProvider.currentQuestionIndex + 1} از ${testProvider.currentQuestions.length}',
                              style: TextStyle(
                                fontSize: progressTextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: progressTextSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                              minHeight: progressHeight,
                              borderRadius: BorderRadius.circular(
                                progressHeight / 2,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Question card with animation
                  Expanded(
                    child: PageView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling
                      itemCount: testProvider.currentQuestions.length,
                      controller: _pageController,
                      onPageChanged: (index) {
                        // Update provider when page changes
                        if (index != testProvider.currentQuestionIndex &&
                            mounted) {
                          testProvider.goToQuestion(index);
                        }
                      },
                      itemBuilder: (context, index) {
                        // Only build the current question for performance
                        if (index != testProvider.currentQuestionIndex) {
                          return const SizedBox.shrink();
                        }

                        final question = testProvider.currentQuestions[index];
                        final isAnswered = testProvider.isQuestionAnswered(
                          index,
                        );
                        final selectedAnswer = testProvider.getSelectedAnswer(
                          index,
                        );

                        return AnimatedBuilder(
                          animation: _resultAnimation,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _resultAnimation,
                              child: QuestionCard(
                                key: ValueKey('question_$index'),
                                question: question,
                                isAnswered: isAnswered,
                                selectedAnswer: selectedAnswer,
                                showExplanation: testProvider.showExplanation,
                                onAnswerSelected: (answer) {
                                  testProvider.answerQuestion(answer);
                                },
                                onNextPressed: () {
                                  if (testProvider.currentQuestionIndex <
                                      testProvider.currentQuestions.length -
                                          1) {
                                    testProvider.nextQuestion();
                                  } else {
                                    // Test finished
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          if (mounted && !_isNavigating) {
                                            _finishTest(testProvider);
                                          }
                                        });
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Navigation buttons
                  if (testProvider.showExplanation)
                    Container(
                      padding: EdgeInsets.all(paddingValue),
                      child: Row(
                        children: [
                          if (testProvider.currentQuestionIndex > 0)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  testProvider.previousQuestion();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    vertical: buttonHeight * 0.3,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'سوال قبلی',
                                  style: TextStyle(fontSize: buttonFontSize),
                                ),
                              ),
                            ),
                          if (testProvider.currentQuestionIndex > 0)
                            SizedBox(width: buttonSpacing),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (testProvider.currentQuestionIndex <
                                    testProvider.currentQuestions.length - 1) {
                                  testProvider.nextQuestion();
                                } else {
                                  // Test finished
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (mounted && !_isNavigating) {
                                      _finishTest(testProvider);
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: buttonHeight * 0.3,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                testProvider.currentQuestionIndex <
                                        testProvider.currentQuestions.length - 1
                                    ? 'سوال بعدی'
                                    : 'پایان آزمون',
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
