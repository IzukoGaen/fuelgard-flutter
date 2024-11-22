import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homescreen.dart'; // Importa HomeScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? accessToken = await _secureStorage.read(key: 'access_token');
    if (accessToken != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  Future<void> _loginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://fuelguardapi-production.up.railway.app/users/login/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _loginEmailController.text,
          'password': _loginPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        await _secureStorage.write(key: 'access_token', value: responseData['access']);
        await _secureStorage.write(key: 'refresh_token', value: responseData['refresh']);
        setState(() {
          _isLoggedIn = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inicio de sesión exitoso')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el inicio de sesión')),
        );
      }
    }
  }

  Future<void> _registerUser() async {
    if (_registerFormKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://fuelguardapi-production.up.railway.app/users/register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _registerUsernameController.text,
          'email': _registerEmailController.text,
          'password': _registerPasswordController.text,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        await _secureStorage.write(key: 'access_token', value: responseData['access']);
        await _secureStorage.write(key: 'refresh_token', value: responseData['refresh']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el registro')),
        );
      }
    }
  }

  Future<void> _logoutUser() async {
    String? refreshToken = await _secureStorage.read(key: 'refresh_token');
    final response = await http.post(
      Uri.parse('https://fuelguardapi-production.up.railway.app/users/logout/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'refresh': refreshToken!,
      }),
    );

    if (response.statusCode == 200) {
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      setState(() {
        _isLoggedIn = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cierre de sesión exitoso')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el cierre de sesión')),
      );
    }
  }

  Future<void> _refreshToken() async {
    String? refreshToken = await _secureStorage.read(key: 'refresh_token');
    final response = await http.post(
      Uri.parse('https://fuelguardapi-production.up.railway.app/users/token/refresh/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'refresh': refreshToken!,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      await _secureStorage.write(key: 'access_token', value: responseData['access']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token refrescado exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al refrescar el token')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión y Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoggedIn ? _buildLogoutForm() : _buildAuthForms(),
      ),
    );
  }

  Widget _buildAuthForms() {
    return Column(
      children: [
        _buildLoginForm(),
        SizedBox(height: 40),
        _buildRegisterForm(),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          Text('Inicio de Sesión', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: _loginEmailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un correo electrónico';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _loginPasswordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese una contraseña';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loginUser,
            child: Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: <Widget>[
          Text('Registro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: _registerUsernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un nombre de usuario';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _registerEmailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un correo electrónico';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _registerPasswordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese una contraseña';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _registerUser,
            child: Text('Registrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Bienvenido, has iniciado sesión.'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _logoutUser,
          child: Text('Cerrar Sesión'),
        ),
      ],
    );
  }
}
