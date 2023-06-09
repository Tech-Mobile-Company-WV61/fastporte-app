import 'dart:convert';
import 'package:fastporte_app/vehicle/model/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class VehicleService extends ChangeNotifier {
  final String _baseUrlBack = 'fastporte-backend.azurewebsites.net';
  // final String _baseUrlBack = '192.168.0.112:8080'; // no me lo borren xd
  bool isSaving = false;
  final storage = FlutterSecureStorage();

  Future<dynamic> getVehicleByDriverId(String driverId) async {
    final Uri url = Uri.https(_baseUrlBack, '/api/vehicle/driver/$driverId');
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
      final user = Vehicle.fromMap(userJson[0]);

      return user;
    } else {
      return null;
    }
  }

  Future<List<Vehicle>> getVehicleByCategoryAndQuantity(String category, int quantity) async {
    final Uri url = Uri.https(_baseUrlBack, '/api/vehicle/find/$category/$quantity');
    final token = await storage.read(key: 'token');

    final resp = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final carsJson = jsonDecode(utf8.decode(resp.bodyBytes));
      // cars json to cars list
      final cars = convertList(carsJson);
      return cars;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getAllVehicles() async {
    final Uri url = Uri.https(_baseUrlBack, '/api/vehicle');
    final token = await storage.read(key: 'token');

    final resp = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final vehicleJson = jsonDecode(utf8.decode(resp.bodyBytes));
      //print(userJson);
      final vehicles = convertList(vehicleJson);
      //print(contracts);
      return vehicles;
    } else {
      throw Exception('Error al obtener vehiculos ${resp.statusCode}');
    }
  }

  static List<Vehicle> convertList<T>(List<dynamic> json) {
    List<Vehicle> objects = [];
    for (var item in json) {
      objects.add(Vehicle.fromMap(item));
    }
    return objects;
  }
}
