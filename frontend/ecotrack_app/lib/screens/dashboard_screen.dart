import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/insight_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).fetchData();
    });
  }

  String _calculateEcoLevel(double total) {
    if (total == 0) return 'Seedling';
    if (total < 15) return 'Eco-Warrior';
    if (total < 30) return 'Green Defender';
    if (total < 50) return 'Sprout';
    return 'Carbon Heavy';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.summary == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null && provider.summary == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final summary = provider.summary;
        final insights = provider.insights;

        if (summary == null) {
          return const Center(child: Text('No data available.'));
        }

        final ecoLevel = _calculateEcoLevel(summary.totalCo2eKg);

        return RefreshIndicator(
          onRefresh: provider.fetchData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting and Eco Level
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green.shade300,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.eco, color: Colors.green, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            'Pts: ${summary.ecoPoints} | Level: $ecoLevel',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Total Emissions Card with TweenAnimation
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Colors.green.shade800,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Emissions',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: provider.selectedPeriod,
                              dropdownColor: Colors.green.shade800,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'week',
                                  child: Text('This Week'),
                                ),
                                DropdownMenuItem(
                                  value: 'month',
                                  child: Text('This Month'),
                                ),
                                DropdownMenuItem(
                                  value: 'all',
                                  child: Text('All Time'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) provider.setPeriod(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: summary.totalCo2eKg,
                        ),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Text(
                            '${value.toStringAsFixed(1)} kg',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Breakdown',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Animated Breakdown bars
                ...summary.categoryBreakdown.entries.map((entry) {
                  final fraction = summary.totalCo2eKg > 0
                      ? entry.value / summary.totalCo2eKg
                      : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text('${entry.value.toStringAsFixed(1)} kg'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: fraction),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          builder: (context, val, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: val,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade200,
                                color: _getColorForCategory(entry.key),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),

                const Text(
                  'Insights & Recommendations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (insights.isEmpty)
                  const Text('Log more activities to see insights!')
                else
                  ...insights.map((insight) => InsightCard(insight: insight)),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Transport':
        return Colors.orange;
      case 'Energy':
        return Colors.blue;
      case 'Food':
        return Colors.green;
      case 'Waste':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
