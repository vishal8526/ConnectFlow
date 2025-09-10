import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceInsightsScreen extends StatefulWidget {
  const PerformanceInsightsScreen({super.key});

  @override
  State<PerformanceInsightsScreen> createState() =>
      _PerformanceInsightsScreenState();
}

class _PerformanceInsightsScreenState extends State<PerformanceInsightsScreen> {
  // Mock data for demonstration
  final Map<String, dynamic> _stats = {
    'totalCalls': 45,
    'successRate': 78.5,
    'avgDuration': 4.2,
    'totalTalkTime': 189.0,
  };

  final List<Map<String, dynamic>> _dailyCalls = [
    {'day': 'Mon', 'calls': 8},
    {'day': 'Tue', 'calls': 12},
    {'day': 'Wed', 'calls': 6},
    {'day': 'Thu', 'calls': 15},
    {'day': 'Fri', 'calls': 4},
  ];

  final List<Map<String, dynamic>> _outcomes = [
    {'outcome': 'Success', 'count': 35, 'color': Colors.green},
    {'outcome': 'No Answer', 'count': 6, 'color': Colors.orange},
    {'outcome': 'Busy', 'count': 3, 'color': Colors.red},
    {'outcome': 'Not Interested', 'count': 1, 'color': Colors.grey},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Insights')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 24), // Adjusted padding
          child: Column(
            children: [
              // Stats cards
              _buildStatsGrid(),
              const SizedBox(height: 12), // Reduced spacing
              // Daily calls chart
              _buildDailyCallsChart(),
              const SizedBox(height: 12), // Reduced spacing
              // Outcomes pie chart
              _buildOutcomesChart(),
              const SizedBox(height: 12), // Reduced spacing
              // Performance trends
              _buildTrendsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: constraints.maxWidth < 600 ? 2 : 4,
          childAspectRatio: 1.7, // Increased from 1.5 to 1.7
          crossAxisSpacing: 8, // Reduced from 12 to 8
          mainAxisSpacing: 8, // Reduced from 12 to 8
          children: [
            _buildStatCard(
              'Total Calls',
              _stats['totalCalls'].toString(),
              Icons.phone,
              Colors.blue,
            ),
            _buildStatCard(
              'Success Rate',
              '${_stats['successRate']}%',
              Icons.trending_up,
              Colors.green,
            ),
            _buildStatCard(
              'Avg Duration',
              '${_stats['avgDuration']}m',
              Icons.timer,
              Colors.orange,
            ),
            _buildStatCard(
              'Talk Time',
              '${_stats['totalTalkTime']}m',
              Icons.schedule,
              Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8), // Reduced from 16 to 8
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24), // Reduced from 40 to 32
            const SizedBox(height: 0                                                                                                                                                                                                                             ), // Reduced from 8 to 4
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                // Changed from headlineSmall
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2), // Reduced from 4 to 2
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCallsChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calls This Week',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height *
                  0.3, // Make height responsive
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(_dailyCalls[value.toInt()]['day']);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _dailyCalls.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value['calls'].toDouble(),
                          color: Colors.blue,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomesChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Call Outcomes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height *
                  0.3, // Make height responsive
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _outcomes.map((outcome) {
                    return PieChartSectionData(
                      color: outcome['color'],
                      value: outcome['count'].toDouble(),
                      title: '${outcome['count']}',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ..._outcomes.map(
              (outcome) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(width: 16, height: 16, color: outcome['color']),
                    const SizedBox(width: 8),
                    Text('${outcome['outcome']}: ${outcome['count']}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Trends',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.trending_up, color: Colors.green),
              title: Text('Success rate improved by 12% this week'),
              subtitle: Text('Great job on follow-up calls!'),
            ),
            const ListTile(
              leading: Icon(Icons.timer, color: Colors.blue),
              title: Text('Average call duration decreased'),
              subtitle: Text('More efficient conversations'),
            ),
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.orange),
              title: Text('Call volume increased'),
              subtitle: Text('Busy week ahead!'),
            ),
          ],
        ),
      ),
    );
  }
}
