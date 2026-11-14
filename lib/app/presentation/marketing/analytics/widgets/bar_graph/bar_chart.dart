import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarChartGraph extends StatelessWidget {
  const BarChartGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 2.0,
        child: Container(
          margin: EdgeInsets.all(10),
          child: BarChart(
            BarChartData(
              barGroups: [
                BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1)]),
                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3)]),
              ],
              alignment: BarChartAlignment.center,
              groupsSpace: 40,
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                show: true,

                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
