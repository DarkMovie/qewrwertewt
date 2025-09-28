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
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _questionController;
  late Animation<double> _fadeAnimation;
  bool _isSavingResult = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers with optimized durations for mobile
    _progressController = AnimationController(
      duration: const Duration(
        milliseconds: 200,
      ), // Reduced for better performance
      vsync: this,
    );

    _questionController = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ), // Reduced for better performance
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _questionController, curve: Curves.easeIn),
    );

    // Start the test
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final testProvider = Provider.of<TestProvider>(context, listen: false);
      testProvider.startBookletTest(widget.bookletNumber);

      // Start animations
      _progressController.forward();
      _questionController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _finishTest(TestProvider testProvider) async {
    if (_isSavingResult) return;

    setState(() {
      _isSavingResult = true;
    });

    try {
      await testProvider.saveTestResult('booklet${widget.bookletNumber}');

      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Consumer<TestProvider>(
      builder: (context, testProvider, child) {
        if (testProvider.currentQuestions.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (testProvider.currentQuestionIndex >=
            testProvider.currentQuestions.length) {
          // Test finished
          if (!_isSavingResult) {
            _finishTest(testProvider);
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

        // Update progress animation
        if (_progressController.value != progress) {
          _progressController.animateTo(progress);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'دفترچه ${widget.bookletNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold),
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
                  buttonFontSize,
                  progressHeight,
                  progressTextSize,
                  scoreTextSize,
                  appBarTextSize;

              if (isSmallPhone) {
                paddingValue = 12.0;
                buttonFontSize = 14.0;
                progressHeight = 6.0;
                progressTextSize = 14.0;
                scoreTextSize = 14.0;
                appBarTextSize = 18.0;
              } else if (isLargePhone) {
                paddingValue = 16.0;
                buttonFontSize = 15.0;
                progressHeight = 8.0;
                progressTextSize = 15.0;
                scoreTextSize = 15.0;
                appBarTextSize = 20.0;
              } else {
                // isTablet
                paddingValue = 24.0;
                buttonFontSize = 18.0;
                progressHeight = 10.0;
                progressTextSize = 18.0;
                scoreTextSize = 16.0;
                appBarTextSize = 22.0;
              }

              // Optimize spacing for mobile
              final spacing = screenHeight * 0.01;
              final buttonSpacing = screenWidth * 0.04;
              final buttonHeight = screenHeight * 0.06;

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
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _progressAnimation.value,
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
                    child: AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 300,
                      ), // Reduced for better performance
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.2),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                      child: QuestionCard(
                        key: ValueKey(testProvider.currentQuestionIndex),
                        question: question,
                        isAnswered: isAnswered,
                        selectedAnswer: selectedAnswer,
                        showExplanation: testProvider.showExplanation,
                        onAnswerSelected: (answer) {
                          testProvider.answerQuestion(answer);
                          _questionController.reset();
                          _questionController.forward();
                        },
                        onNextPressed: () {
                          if (testProvider.currentQuestionIndex <
                              testProvider.currentQuestions.length - 1) {
                            testProvider.nextQuestion();
                            _questionController.reset();
                            _questionController.forward();
                          } else {
                            // Test finished
                            _finishTest(testProvider);
                          }
                        },
                      ),
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
                                  _questionController.reset();
                                  _questionController.forward();
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
                                  _questionController.reset();
                                  _questionController.forward();
                                } else {
                                  // Test finished
                                  _finishTest(testProvider);
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
