import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PantallaTiempoReal extends StatefulWidget {
  @override
  _PantallaTiempoRealState createState() => _PantallaTiempoRealState();
}

class _PantallaTiempoRealState extends State<PantallaTiempoReal> {
  GoogleMapController? mapController;
  final List<Truck> trucks = [
    Truck('Camión 1', LatLng(37.7749, -122.4194), 75, 'Normal'),
    Truck('Camión 2', LatLng(37.7849, -122.4094), 50, 'Advertencia'),
    Truck('Camión 3', LatLng(37.7949, -122.4294), 25, 'Alerta'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estado de la Flota en Tiempo Real'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194), // Coordenadas iniciales
                zoom: 10,
              ),
              markers: _createMarkers(),
            ),
          ),
          _buildTruckList(),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> _createMarkers() {
    return trucks.map((truck) {
      return Marker(
        markerId: MarkerId(truck.name),
        position: truck.location,
        infoWindow: InfoWindow(
          title: truck.name,
          snippet: 'Nivel de combustible: ${truck.fuelLevel}%',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          truck.status == 'Normal'
              ? BitmapDescriptor.hueGreen
              : truck.status == 'Advertencia'
                  ? BitmapDescriptor.hueYellow
                  : BitmapDescriptor.hueRed,
        ),
      );
    }).toSet();
  }

  Widget _buildTruckList() {
    return Expanded(
      child: ListView.builder(
        itemCount: trucks.length,
        itemBuilder: (context, index) {
          final truck = trucks[index];
          return ListTile(
            leading: Icon(
              Icons.local_shipping,
              color: truck.status == 'Normal'
                  ? Colors.green
                  : truck.status == 'Advertencia'
                      ? Colors.yellow
                      : Colors.red,
            ),
            title: Text(truck.name),
            subtitle: Text('Nivel de combustible: ${truck.fuelLevel}%'),
            trailing: Text(truck.status),
            onTap: () {
              _showTruckDetails(truck);
            },
          );
        },
      ),
    );
  }

  void _showTruckDetails(Truck truck) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(truck.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nivel de combustible: ${truck.fuelLevel}%'),
              Text('Ubicación: ${truck.location.latitude}, ${truck.location.longitude}'),
              // Aquí puedes agregar un mapa ampliado y alertas recientes
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

class Truck {
  final String name;
  final LatLng location;
  final int fuelLevel;
  final String status;

  Truck(this.name, this.location, this.fuelLevel, this.status);
}