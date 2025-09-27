// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azmonrahnamayi/providers/test_provider.dart';
import 'package:azmonrahnamayi/models/test_result.dart';
import 'package:intl/intl.dart' as intl;

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تاریخچه آزمون‌ها'),
        centerTitle: true,
        actions: [
          Consumer<TestProvider>(
            builder: (context, testProvider, child) {
              if (testProvider.testResults.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () =>
                      _showClearHistoryDialog(context, testProvider),
                  tooltip: 'پاک کردن تاریخچه',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<TestProvider>(
        builder: (context, testProvider, child) {
          if (testProvider.testResults.isEmpty) {
            return _buildEmptyState(context);
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isTablet = screenWidth > 600;

              return ListView.builder(
                padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                itemCount: testProvider.testResults.length,
                itemBuilder: (context, index) {
                  final result = testProvider.testResults[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _buildResultCard(context, result, isTablet),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth > 600;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isTablet ? 120 : 100,
                height: isTablet ? 120 : 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  size: isTablet ? 60 : 50,
                  color: Colors.grey.shade400,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                'هیچ نتیجه‌ای یافت نشد',
                style: TextStyle(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'پس از انجام آزمون، نتایج اینجا نمایش داده می‌شوند',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    TestResult result,
    bool isTablet,
  ) {
    final percentage = (result.score / result.totalQuestions) * 100;
    final date = intl.DateFormat('yyyy/MM/dd HH:mm').format(result.date);

    // تنظیم اندازه‌های واکنش‌گرا
    final titleFontSize = isTablet ? 20.0 : 18.0;
    final dateFontSize = isTablet ? 14.0 : 12.0;
    final scoreFontSize = isTablet ? 24.0 : 20.0;
    final percentageFontSize = isTablet ? 22.0 : 18.0;
    final containerSize = isTablet ? 70.0 : 60.0;

    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: isTablet ? 16.0 : 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'آزمون ${result.type == 'random' ? 'تصادفی' : result.type}',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: dateFontSize,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 16.0 : 12.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نمره:',
                        style: TextStyle(
                          fontSize: isTablet ? 16.0 : 14.0,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: isTablet ? 8.0 : 4.0),
                      Text(
                        '${result.score} از ${result.totalQuestions}',
                        style: TextStyle(
                          fontSize: scoreFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(
                    color: _getScoreColor(percentage).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: percentageFontSize,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(percentage),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return Colors.blue;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  void _showClearHistoryDialog(
    BuildContext context,
    TestProvider testProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('پاک کردن تاریخچه'),
        content: const Text('آیا از پاک کردن تاریخچه آزمون‌ها اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              testProvider.clearTestResults();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تاریخچه آزمون‌ها با موفقیت پاک شد'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('پاک کردن'),
          ),
        ],
      ),
    );
  }
}
