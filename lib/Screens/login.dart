import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  final _refreshTokenFormKey = GlobalKey<FormState>();
  final _logoutFormKey = GlobalKey<FormState>();
  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _refreshTokenController = TextEditingController();
  final TextEditingController _logoutTokenController = TextEditingController();

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
        // Registro exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso')),
        );
      } else {
        // Error en el registro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el registro')),
        );
      }
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
        // Inicio de sesión exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inicio de sesión exitoso')),
        );
      } else {
        // Error en el inicio de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el inicio de sesión')),
        );
      }
    }
  }

  Future<void> _refreshToken() async {
    if (_refreshTokenFormKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://fuelguardapi-production.up.railway.app/users/token/refresh/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'refresh': _refreshTokenController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Token refrescado exitosamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token refrescado exitosamente')),
        );
      } else {
        // Error al refrescar el token
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al refrescar el token')),
        );
      }
    }
  }

  Future<void> _logoutUser() async {
    if (_logoutFormKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://fuelguardapi-production.up.railway.app/users/logout/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'refresh': _logoutTokenController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Cierre de sesión exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cierre de sesión exitoso')),
        );
      } else {
        // Error en el cierre de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el cierre de sesión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro, Inicio de Sesión y Cierre de Sesión'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Form(
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
              ),
              SizedBox(height: 40),
              Form(
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
              ),
              SizedBox(height: 40),
              Form(
                key: _refreshTokenFormKey,
                child: Column(
                  children: <Widget>[
                    Text('Refrescar Token', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _refreshTokenController,
                      decoration: InputDecoration(labelText: 'Refresh Token'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el token de refresco';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _refreshToken,
                      child: Text('Refrescar Token'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _logoutFormKey,
                child: Column(
                  children: <Widget>[
                    Text('Cierre de Sesión', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _logoutTokenController,
                      decoration: InputDecoration(labelText: 'Refresh Token'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el token de refresco';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _logoutUser,
                      child: Text('Cerrar Sesión'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}