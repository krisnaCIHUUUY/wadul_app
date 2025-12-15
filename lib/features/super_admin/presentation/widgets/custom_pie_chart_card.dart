import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomPieChartCard extends StatelessWidget {
  final String title;
  final List<PieChartSectionData> data;
  final String type;
  final String fontFamily;
  final Map<String, int>? dynamicLabels;
  const CustomPieChartCard({
    super.key,
    required this.title,
    required this.data,
    required this.type,
    this.fontFamily = "Poppins",
    this.dynamicLabels,
  });

  Widget _buildLegend() {
    List<Widget> items = [];

    if (type == 'Kategori' && dynamicLabels != null) {
      int colorIndex = 0;
      const List<Color> colorPalette = [
        Colors.blueAccent,
        Colors.pinkAccent,
        Colors.red,
        Colors.purple,
        Colors.green,
      ];

      dynamicLabels!.forEach((categoryName, count) {
        final color = colorPalette[colorIndex % colorPalette.length];
        items.add(_buildLegendItem(color, '$count $categoryName'));
        colorIndex++;
      });
    } else if (type == 'Status') {
      items = [];
      final Map<Color, String> statusLabels = {
        Colors.blue: 'Menverifikasi',
        Colors.orange: 'In Progress',
        Colors.lightGreen: 'Disetujui',
        Colors.red: 'Ditolak',
      };

      int index = 0;
      for (var section in data) {
        Color sectionColor = section.color;
        String label = statusLabels[sectionColor] ?? 'Status Lain';

        items.add(
          _buildLegendItem(sectionColor, '${section.value.toInt()} $label'),
        );
        index++;
      }
    } else {
      items = [];
    }

    return Wrap(spacing: 8.0, runSpacing: 4.0, children: items);
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
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
  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: data,
                      centerSpaceRadius: 40,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2, 
                      
                    ),
                  ),
                  Text(
                    total.toInt().toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildLegend(),
          ],
        ),
      ),
    );
  }
}
