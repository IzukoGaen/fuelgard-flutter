import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PantallaDatos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficos de Nivel de Combustible'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: _buildFuelLevelChart(),
            ),
            Expanded(
              child: _buildEventTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuelLevelChart() {
    // Datos de ejemplo
    final data = [
      FuelLevel(DateTime.now().subtract(Duration(days: 7)), 50),
      FuelLevel(DateTime.now().subtract(Duration(days: 6)), 55),
      FuelLevel(DateTime.now().subtract(Duration(days: 5)), 45),
      FuelLevel(DateTime.now().subtract(Duration(days: 4)), 60),
      FuelLevel(DateTime.now().subtract(Duration(days: 3)), 70),
      FuelLevel(DateTime.now().subtract(Duration(days: 2)), 65),
      FuelLevel(DateTime.now().subtract(Duration(days: 1)), 75),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: data.map((e) => FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.level.toDouble())).toList(),
            isCurved: true,
            color: Colors.blue, // Correct usage of color
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.3), // Correct usage of colors
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTable() {
    // Datos de ejemplo
    final events = [
      FuelEvent(DateTime.now().subtract(Duration(days: 1)), 'Carga', 50, 75, 'Ubicación A'),
      FuelEvent(DateTime.now().subtract(Duration(days: 2)), 'Descarga', 75, 65, 'Ubicación B'),
    ];

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text('${event.type} - ${event.date}'),
          subtitle: Text('Nivel: ${event.initialLevel} -> ${event.finalLevel}, Ubicación: ${event.location}'),
        );
      },
    );
  }
}

class FuelLevel {
  final DateTime time;
  final int level;

  FuelLevel(this.time, this.level);
}

class FuelEvent {
  final DateTime date;
  final String type;
  final int initialLevel;
  final int finalLevel;
  final String location;

  FuelEvent(this.date, this.type, this.initialLevel, this.finalLevel, this.location);
}