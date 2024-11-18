import 'package:flutter/material.dart';

class PantallaAlertas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Alertas'),
      ),
      body: AlertList(),
    );
  }
}

class AlertList extends StatelessWidget {
  final List<Alert> alerts = [
    Alert('Descarga inesperada', DateTime.now(), 'Ubicación A', 75, 50, 'Rojo'),
    Alert('Nivel crítico de combustible', DateTime.now().subtract(Duration(hours: 1)), 'Ubicación B', 10, 5, 'Rojo'),
    Alert('Extracción fuera de geovalla', DateTime.now().subtract(Duration(hours: 2)), 'Ubicación C', 60, 30, 'Amarillo'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return ListTile(
          leading: Icon(
            Icons.warning,
            color: alert.priority == 'Rojo' ? Colors.red : alert.priority == 'Amarillo' ? Colors.yellow : Colors.green,
          ),
          title: Text(alert.type),
          subtitle: Text('${alert.date} - ${alert.location}'),
          trailing: Text('Nivel: ${alert.initialLevel} -> ${alert.finalLevel}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlertDetail(alert: alert)),
            );
          },
        );
      },
    );
  }
}

class AlertDetail extends StatelessWidget {
  final Alert alert;

  AlertDetail({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Alerta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo de Alerta: ${alert.type}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Fecha y Hora: ${alert.date}'),
            Text('Ubicación: ${alert.location}'),
            Text('Nivel de Combustible: ${alert.initialLevel} -> ${alert.finalLevel}'),
            SizedBox(height: 20),
            Text('Gráfico de Cambios Relacionados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // Aquí puedes agregar un gráfico usando una biblioteca como charts_flutter
            SizedBox(height: 20),
            Text('Estado de Resolución: No resuelto'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de historial
              },
              child: Text('Ver Historial Completo'),
            ),
          ],
        ),
      ),
    );
  }
}

class Alert {
  final String type;
  final DateTime date;
  final String location;
  final int initialLevel;
  final int finalLevel;
  final String priority;

  Alert(this.type, this.date, this.location, this.initialLevel, this.finalLevel, this.priority);
}