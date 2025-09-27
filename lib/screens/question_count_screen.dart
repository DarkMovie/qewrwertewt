// lib/screens/question_count_screen.dart
import 'package:flutter/material.dart';
import 'package:azmonrahnamayi/screens/question_screen.dart';

class QuestionCountScreen extends StatefulWidget {
  const QuestionCountScreen({super.key});

  @override
  State<QuestionCountScreen> createState() => _QuestionCountScreenState();
}

class _QuestionCountScreenState extends State<QuestionCountScreen> {
  int selectedQuestionCount = 20;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = selectedQuestionCount.toString();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعداد سوالات'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'تعداد سوالات مورد نظر را انتخاب کنید',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // کارت انتخاب تعداد سوالات
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'تعداد سوالات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // اسلایدر انتخاب تعداد سوالات
                      Slider(
                        value: selectedQuestionCount.toDouble(),
                        min: 1,
                        max: 300,
                        divisions: 299,
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Colors.grey.shade300,
                        onChanged: (value) {
                          setState(() {
                            selectedQuestionCount = value.toInt();
                            _textController.text = selectedQuestionCount
                                .toString();
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // نمایش تعداد انتخاب شده
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$selectedQuestionCount سوال',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ورودی متنی برای تعداد سوالات
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'تعداد سوالات (1-300)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  int? num = int.tryParse(value);
                                  if (num != null && num >= 1 && num <= 300) {
                                    setState(() {
                                      selectedQuestionCount = num;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // دکمه شروع آزمون
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionScreen(
                          testType: 'random',
                          questionCount: selectedQuestionCount,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'شروع آزمون',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 20),

                // پیشنهادات سریع
                Text(
                  'پیشنهادات سریع:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildQuickSelectButton(10),
                    _buildQuickSelectButton(20),
                    _buildQuickSelectButton(30),
                    _buildQuickSelectButton(50),
                    _buildQuickSelectButton(100),
                    _buildQuickSelectButton(150),
                    _buildQuickSelectButton(200),
                    _buildQuickSelectButton(300),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSelectButton(int count) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedQuestionCount = count;
          _textController.text = count.toString();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text('$count'),
    );
  }
}
