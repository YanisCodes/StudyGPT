import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/study_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyProvider>(context);
    final sessions = provider.sessions;

    // Aggregate data
    Map<String, int> moduleTime = {};
    for (var session in sessions) {
      moduleTime[session.moduleName] = (moduleTime[session.moduleName] ?? 0) + session.durationInSeconds;
    }

    final List<BarChartGroupData> barGroups = [];
    int index = 0;
    moduleTime.forEach((key, value) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: (value / 60).toDouble(), // Minutes
              color: Colors.deepPurpleAccent,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
      index++;
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Statistiques", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Temps d'étude par module (min)",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: moduleTime.isEmpty
                  ? Center(child: Text("Pas encore de données", style: GoogleFonts.poppins(color: Colors.grey)))
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (moduleTime.values.isEmpty ? 0 : moduleTime.values.reduce((a, b) => a > b ? a : b) / 60) * 1.2,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => Colors.white10,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String moduleName = moduleTime.keys.elementAt(group.x.toInt());
                              return BarTooltipItem(
                                '$moduleName\n',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${rod.toY.round()} min',
                                    style: const TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value.toInt() >= moduleTime.keys.length) return const Text('');
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    moduleTime.keys.elementAt(value.toInt()).substring(0, 1).toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white10,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: barGroups,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: moduleTime.keys.map((module) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(module, style: GoogleFonts.poppins(color: Colors.white70)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
