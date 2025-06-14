import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MultiLineChartWidget extends StatelessWidget {
  final List<List<dynamic>> latencyGraph;

  MultiLineChartWidget({required this.latencyGraph});

  @override
  Widget build(BuildContext context) {
    // Extracting data for plotting
    List<FlSpot> serial123Data = [];
    List<FlSpot> serial456Data = [];
    List<FlSpot> tcpData = [];
    List<FlSpot> websocketData = [];
    
    for (int i = 0; i < latencyGraph.length; i++) {
      final entry = latencyGraph[i];
      // Convert timestamp to seconds since epoch (for the x-axis)
      DateTime timestamp = DateTime.parse(entry[1]);
      double xValue = timestamp.millisecondsSinceEpoch / 1000; // Convert to seconds
      
      serial123Data.add(FlSpot(xValue, entry[2])); // serial123
      serial456Data.add(FlSpot(xValue, entry[3])); // serial456
      tcpData.add(FlSpot(xValue, entry[4])); // tcp
      websocketData.add(FlSpot(xValue, entry[5])); // websocket
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  DateTime timestamp = DateTime.fromMillisecondsSinceEpoch((value * 1000).toInt());
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '${timestamp.hour}:${timestamp.minute}:${timestamp.second}', // Display time
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            // Serial123
            LineChartBarData(
              spots: serial123Data,
              isCurved: true,
              barWidth: 3,
              color: Colors.blue,
              dotData: FlDotData(show: false),
            ),
            // Serial456
            LineChartBarData(
              spots: serial456Data,
              isCurved: true,
              barWidth: 3,
              color: Colors.red,
              dotData: FlDotData(show: false),
            ),
            // TCP
            LineChartBarData(
              spots: tcpData,
              isCurved: true,
              barWidth: 3,
              color: Colors.green,
              dotData: FlDotData(show: false),
            ),
            // WebSocket
            LineChartBarData(
              spots: websocketData,
              isCurved: true,
              barWidth: 3,
              color: Colors.orange,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
