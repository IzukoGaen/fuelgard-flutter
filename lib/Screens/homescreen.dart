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
  int _currentPage = 0;

  final List<String> _titles = [
    'Gráfico de Datos del Sensor Ultrasónico',
    'Nivel de Combustible en Tiempo Real',
    'Ubicación Actual del Camión en un Mapa Integrado',
    'Indicadores Visuales para Alertas Activas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal de Monitoreo'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple, Colors.white],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildPage(
                  context,
                  _buildFuelLevelChart(),
                ),
                _buildPage(
                  context,
                  _buildFuelLevelIndicator(),
                ),
                _buildPage(
                  context,
                  _buildMap(),
                ),
                _buildPage(
                  context,
                  _buildAlertIndicators(),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15, // Posiciona el título a mediados de la pantalla
            left: 16.0,
            right: 16.0,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Text(
                _titles[_currentPage],
                key: ValueKey<int>(_currentPage),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 32, // Tamaño de letra grande
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, Widget content) {
    return Column(
      children: [
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
