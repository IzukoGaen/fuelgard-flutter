import 'package:flutter/material.dart';
import 'package:fuel_gardv/pantalladatos.dart';
import 'package:fuel_gardv/pantallalertas.dart';
import 'package:fuel_gardv/confgeovalla.dart';
import 'package:fuel_gardv/pantallatiemporeal.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal de Monitoreo'),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              _buildPage(
                context,
                'Gráfico de Datos del Sensor Ultrasónico',
                _buildFuelLevelChart(),
              ),
              _buildPage(
                context,
                'Nivel de Combustible en Tiempo Real',
                _buildFuelLevelIndicator(),
              ),
              _buildPage(
                context,
                'Ubicación Actual del Camión en un Mapa Integrado',
                _buildMap(),
              ),
              _buildPage(
                context,
                'Indicadores Visuales para Alertas Activas',
                _buildAlertIndicators(),
              ),
            ],
          ),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, String title, Widget content) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildFuelLevelChart() {
    // Implementa tu gráfico de nivel de combustible aquí
    return Center(child: Text('Gráfico de Nivel de Combustible'));
  }

  Widget _buildFuelLevelIndicator() {
    // Implementa tu indicador de nivel de combustible aquí
    return Center(child: Text('Indicador de Nivel de Combustible'));
  }

  Widget _buildMap() {
    // Implementa tu mapa aquí
    return Center(child: Text('Mapa Integrado'));
  }

  Widget _buildAlertIndicators() {
    // Implementa tus indicadores de alertas aquí
    return Center(child: Text('Indicadores de Alertas Activas'));
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white,
          child: ListView(
            controller: scrollController,
            children: [
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Historial de Datos'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PantallaDatos()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.warning),
                title: Text('Alertas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PantallaAlertas()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuración de Geovalla'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfGeovalla()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_car),
                title: Text('Estado de la Flota en Tiempo Real'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PantallaTiempoReal()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}