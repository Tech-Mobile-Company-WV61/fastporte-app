import 'dart:convert';
import 'package:fastporte_app/globals.dart' as globals;
import 'package:fastporte_app/auth/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  final String _baseUrlBack = 'fastporte-backend.azurewebsites.net';
  // final String _baseUrlBack = '192.168.0.112:8080'; // no me lo borren xd
  final storage = FlutterSecureStorage();
  late User selectedUser;

  bool isSaving = false;

  Future<User> getUserById(String userId) async {
    final Uri url;

    if (globals.role == 'transportista') {
      url = Uri.https(_baseUrlBack, '/api/drivers/$userId');
    } else {
      url = Uri.https(_baseUrlBack, '/api/clients/$userId');
    }

    final token = await storage.read(key: 'token');
    final resp = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final userJson = jsonDecode(utf8.decode(resp.bodyBytes));
      final user = User.fromMap(userJson);

      return user;
    } else {
      throw Exception('Error al obtener el usuario ${resp.statusCode}');
    }
  }

  Future<String> updateUser(User user) async {
    final Uri url;
    if (globals.role == 'transportista') {
      url = Uri.https(_baseUrlBack, '/api/drivers/${user.id}');
    } else {
      url = Uri.https(_baseUrlBack, '/api/clients/${user.id}');
    }
    final token = await storage.read(key: 'token');
    final resp = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: user.toJson(),
    );
    if (resp.statusCode == 200) {
      return user.id;
    } else {
      throw Exception('Error al obtener el usuario');
    }
  }

}
