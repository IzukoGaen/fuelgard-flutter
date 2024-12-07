import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfGeovalla extends StatefulWidget {
  @override
  _ConfGeovallaState createState() => _ConfGeovallaState();
}

class _ConfGeovallaState extends State<ConfGeovalla> {
  GoogleMapController? mapController;
  LatLng? _selectedLocation;
  double _radius = 100.0; // Radio inicial en metros
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _radiusController.text = _radius.toString();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _circles = {
        Circle(
          circleId: CircleId('geofence'),
          center: _selectedLocation!,
          radius: _radius,
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ),
      };
    });
  }

  void _updateRadius(String value) {
    setState(() {
      _radius = double.tryParse(value) ?? 100.0;
      if (_selectedLocation != null) {
        _circles = {
          Circle(
            circleId: CircleId('geofence'),
            center: _selectedLocation!,
            radius: _radius,
            fillColor: Colors.blue.withOpacity(0.5),
            strokeColor: Colors.blue,
            strokeWidth: 2,
          ),
        };
      }
    });
  }

  Future<void> _saveGeofence() async {
    if (_selectedLocation != null && _radius > 0 && _nameController.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('https://yourapi.com/geofences'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _nameController.text,
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
          'radius': _radius,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geovalla guardada exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la geovalla')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor seleccione una ubicación, ingrese un nombre y un radio válido')),
      );
    }
  }

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
                target: LatLng(25.6866, -100.3161), // Coordenadas iniciales actualizadas
                zoom: 10,
              ),
              onTap: _onTap,
              markers: _selectedLocation != null
                  ? {
                      Marker(
                        markerId: MarkerId('selectedLocation'),
                        position: _selectedLocation!,
                      ),
                    }
                  : {},
              circles: _circles,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre de la Geovalla'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _radiusController,
                  decoration: InputDecoration(labelText: 'Radio (metros)'),
                  keyboardType: TextInputType.number,
                  onChanged: _updateRadius,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _saveGeofence,
                  child: Text('Guardar Geovalla'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Geofence {
  final String name;
  final double radius;
  final LatLng center;

  Geofence(this.name, this.radius, this.center);
}