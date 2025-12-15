// File: lib/widgets/custom_bar_chart_card.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomBarChartCard extends StatelessWidget {
  final String title;
  final List<BarChartGroupData> barGroups;
  final List<String>? bottomLabels; // <-- penting untuk statistik
  final String fontFamily;

  const CustomBarChartCard({
    super.key,
    required this.title,
    required this.barGroups,
    this.bottomLabels,
    this.fontFamily = "Poppins",
  });

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontFamily: fontFamily,
          ),
        ),
      ],
    );
  }

  double _calculateMaxY() {
    double max = 0;
    for (final group in barGroups) {
      for (final rod in group.barRods) {
        if (rod.toY > max) max = rod.toY;
      }
    }
    return max == 0 ? 5 : max + 2; // buffer visual
  }

  @override
  Widget build(BuildContext context) {
    if (barGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxY = _calculateMaxY();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
              ),
            ),

            const SizedBox(height: 6),

            // =====================
            // LEGEND
            // =====================
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                _buildLegendItem(Colors.deepPurple, 'Pagi'),
                _buildLegendItem(Colors.orange, 'Siang'),
                _buildLegendItem(Colors.red, 'Malam'),
              ],
            ),

            const SizedBox(height: 12),

            // =====================
            // BAR CHART
            // =====================
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  baselineY: 0,

                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),

                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    // 🔥 INI PENTING
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: bottomLabels != null,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (bottomLabels == null ||
                              index < 0 ||
                              index >= bottomLabels!.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              bottomLabels![index],
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: fontFamily,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
