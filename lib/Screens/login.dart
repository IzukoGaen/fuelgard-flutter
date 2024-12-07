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

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool _isLoggedIn = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoggedIn ? _buildLogoutForm() : _buildAuthForms(),
        ),
      ),
    );
  }

  Widget _buildAuthForms() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _animation,
          child: Icon(
            Icons.lock,
            size: 100,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 40),
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
          Text('Inicio de Sesión', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          TextFormField(
            controller: _loginEmailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un correo electrónico';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _loginPasswordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, // Color del botón
            ),
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
          Text('Registro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          TextFormField(
            controller: _registerUsernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un nombre de usuario';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _registerEmailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un correo electrónico';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _registerPasswordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, // Color del botón
            ),
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
        Text('Bienvenido, has iniciado sesión.', style: TextStyle(color: Colors.white)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _logoutUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Color del botón
          ),
          child: Text('Cerrar Sesión'),
        ),
      ],
    );
  }
}
