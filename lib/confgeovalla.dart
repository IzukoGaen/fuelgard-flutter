import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfGeovalla extends StatefulWidget {
  @override
  _ConfGeovallaState createState() => _ConfGeovallaState();
}

class _ConfGeovallaState extends State<ConfGeovalla> {
  GoogleMapController? mapController;
  final Set<Circle> _circles = {};
  final Set<Polygon> _polygons = {};
  final List<Geofence> _geofences = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de Geovalla'),
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
              circles: _circles,
              polygons: _polygons,
            ),
          ),
          _buildGeofenceList(),
          _buildGeofenceForm(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createGeofence,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget _buildGeofenceList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _geofences.length,
        itemBuilder: (context, index) {
          final geofence = _geofences[index];
          return ListTile(
            title: Text(geofence.name),
            subtitle: Text('Radio: ${geofence.radius} metros'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteGeofence(index),
            ),
            onTap: () => _editGeofence(index),
          );
        },
      ),
    );
  }

  Widget _buildGeofenceForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Nombre de la Geovalla'),
            onChanged: (value) {
              // Guardar el nombre de la geovalla
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Radio (metros)'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Guardar el radio de la geovalla
            },
          ),
          ElevatedButton(
            onPressed: _saveGeofence,
            child: Text('Guardar Geovalla'),
          ),
        ],
      ),
    );
  }

  void _createGeofence() {
    // Lógica para crear una nueva geovalla
  }

  void _editGeofence(int index) {
    // Lógica para editar una geovalla existente
  }

  void _deleteGeofence(int index) {
    setState(() {
      _geofences.removeAt(index);
    });
  }

  void _saveGeofence() {
    // Lógica para guardar la geovalla
  }
}

class Geofence {
  final String name;
  final double radius;
  final LatLng center;

  Geofence(this.name, this.radius, this.center);
}