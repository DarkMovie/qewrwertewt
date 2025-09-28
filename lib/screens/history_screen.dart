// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azmonrahnamayi/providers/test_provider.dart';
import 'package:azmonrahnamayi/models/test_result.dart';
import 'package:intl/intl.dart' as intl;
import 'package:percent_indicator/percent_indicator.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  String _sortBy = 'date'; // date, score, percentage
  String _filterType = 'all'; // all, random, booklet

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
      body: Column(
        children: [
          _buildSearchAndFilterBar(),
          Expanded(
            child: Consumer<TestProvider>(
              builder: (context, testProvider, child) {
                // فیلتر کردن نتایج بر اساس جستجو و نوع
                var filteredResults = testProvider.testResults.where((result) {
                  final matchesSearch = result.type.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
                  final matchesType =
                      _filterType == 'all' ||
                      result.type.toLowerCase() == _filterType;
                  return matchesSearch && matchesType;
                }).toList();

                // مرتب‌سازی نتایج
                filteredResults.sort((a, b) {
                  switch (_sortBy) {
                    case 'date':
                      return b.date.compareTo(a.date);
                    case 'score':
                      return b.score.compareTo(a.score);
                    case 'percentage':
                      final percentageA = (a.score / a.totalQuestions) * 100;
                      final percentageB = (b.score / b.totalQuestions) * 100;
                      return percentageB.compareTo(percentageA);
                    default:
                      return 0;
                  }
                });

                if (filteredResults.isEmpty) {
                  return _buildEmptyState(context);
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final screenHeight = constraints.maxHeight;
                    final screenWidth = constraints.maxWidth;
                    final isSmallPhone =
                        screenWidth < 360 || screenHeight < 600;
                    final isLargePhone =
                        (screenWidth >= 360 && screenWidth < 600) ||
                        (screenHeight >= 600 && screenHeight < 800);
                    final isTablet = screenWidth >= 600;

                    return ListView.builder(
                      padding: EdgeInsets.all(
                        isSmallPhone
                            ? 12.0
                            : isLargePhone
                            ? 16.0
                            : 24.0,
                      ),
                      itemCount: filteredResults.length,
                      itemBuilder: (context, index) {
                        final result = filteredResults[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: _buildResultCard(
                            context,
                            result,
                            isSmallPhone,
                            isLargePhone,
                            isTablet,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // نوار جستجو
          TextField(
            decoration: InputDecoration(
              hintText: 'جستجو در تاریخچه...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 8),
          // دکمه‌های فیلتر و مرتب‌سازی
          Row(
            children: [
              // فیلتر نوع آزمون
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _filterType,
                    isExpanded: true,
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('همه آزمون‌ها'),
                      ),
                      DropdownMenuItem(
                        value: 'random',
                        child: Text('آزمون تصادفی'),
                      ),
                      DropdownMenuItem(
                        value: 'booklet',
                        child: Text('دفترچه‌ها'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filterType = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // مرتب‌سازی
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _sortBy,
                    isExpanded: true,
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'date', child: Text('تاریخ')),
                      DropdownMenuItem(value: 'score', child: Text('نمره')),
                      DropdownMenuItem(
                        value: 'percentage',
                        child: Text('درصد'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;
        final isSmallPhone = screenWidth < 360 || screenHeight < 600;
        final isLargePhone =
            (screenWidth >= 360 && screenWidth < 600) ||
            (screenHeight >= 600 && screenHeight < 800);
        final isTablet = screenWidth >= 600;

        // Calculate responsive sizes
        double iconSize, titleSize, subtitleSize, spacingFactor;

        if (isSmallPhone) {
          iconSize = 40.0;
          titleSize = 16.0;
          subtitleSize = 13.0;
          spacingFactor = 0.025;
        } else if (isLargePhone) {
          iconSize = 45.0;
          titleSize = 17.0;
          subtitleSize = 14.0;
          spacingFactor = 0.03;
        } else {
          // isTablet
          iconSize = 60.0;
          titleSize = 22.0;
          subtitleSize = 16.0;
          spacingFactor = 0.03;
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: iconSize * 2,
                height: iconSize * 2,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  size: iconSize,
                  color: Colors.grey.shade400,
                ),
              ),
              SizedBox(height: screenHeight * spacingFactor),
              Text(
                'هیچ نتیجه‌ای یافت نشد',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: screenHeight * spacingFactor * 0.5),
              Text(
                'پس از انجام آزمون، نتایج اینجا نمایش داده می‌شوند',
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * spacingFactor),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // بازگشت به صفحه اصلی
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('شروع آزمون'),
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
    bool isSmallPhone,
    bool isLargePhone,
    bool isTablet,
  ) {
    final percentage = (result.score / result.totalQuestions) * 100;
    final date = intl.DateFormat('yyyy/MM/dd HH:mm').format(result.date);

    // Calculate responsive sizes
    double titleFontSize,
        dateFontSize,
        scoreFontSize,
        percentageFontSize,
        containerSize,
        cardPadding,
        cardMargin,
        subtitleFontSize;

    if (isSmallPhone) {
      titleFontSize = 16.0;
      dateFontSize = 11.0;
      scoreFontSize = 18.0;
      percentageFontSize = 16.0;
      containerSize = 50.0;
      cardPadding = 12.0;
      cardMargin = 8.0;
      subtitleFontSize = 13.0;
    } else if (isLargePhone) {
      titleFontSize = 17.0;
      dateFontSize = 12.0;
      scoreFontSize = 19.0;
      percentageFontSize = 17.0;
      containerSize = 55.0;
      cardPadding = 14.0;
      cardMargin = 10.0;
      subtitleFontSize = 14.0;
    } else {
      // isTablet
      titleFontSize = 20.0;
      dateFontSize = 14.0;
      scoreFontSize = 24.0;
      percentageFontSize = 22.0;
      containerSize = 70.0;
      cardPadding = 20.0;
      cardMargin = 16.0;
      subtitleFontSize = 16.0;
    }

    return Card(
      elevation: isSmallPhone ? 2 : 3,
      margin: EdgeInsets.only(bottom: cardMargin),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallPhone ? 12 : 16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(isSmallPhone ? 12 : 16),
        onTap: () {
          // نمایش جزئیات آزمون
          _showTestDetailsDialog(context, result);
        },
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // آیکون نوع آزمون
                        Icon(
                          result.type == 'random' ? Icons.shuffle : Icons.book,
                          size: titleFontSize + 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
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
                      ],
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
              SizedBox(height: cardPadding * 0.7),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نمره:',
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: cardPadding * 0.3),
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
                  // نمایش درصد با استفاده از CircularPercentIndicator
                  CircularPercentIndicator(
                    radius: containerSize / 2,
                    lineWidth: 5.0,
                    percent: percentage / 100,
                    center: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: percentageFontSize,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(percentage),
                      ),
                    ),
                    progressColor: _getScoreColor(percentage),
                    backgroundColor: _getScoreColor(
                      percentage,
                    ).withOpacity(0.2),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTestDetailsDialog(BuildContext context, TestResult result) {
    final percentage = (result.score / result.totalQuestions) * 100;
    final date = intl.DateFormat('yyyy/MM/dd HH:mm').format(result.date);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'جزئیات آزمون ${result.type == 'random' ? 'تصادفی' : result.type}',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('تاریخ آزمون', date),
            _buildDetailRow(
              'نمره',
              '${result.score} از ${result.totalQuestions}',
            ),
            _buildDetailRow('درصد موفقیت', '${percentage.toStringAsFixed(1)}%'),
            _buildDetailRow('وضعیت', percentage >= 70 ? 'قبول' : 'مردود'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
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
                SnackBar(
                  content: const Text('تاریخچه آزمون‌ها با موفقیت پاک شد'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
