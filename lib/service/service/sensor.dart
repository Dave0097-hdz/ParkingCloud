import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Sensores extends ChangeNotifier {
  final String _baseUrl = 'appparkingcloud-default-rtdb.firebaseio.com';

  Future<Map<String, int>> loadSensor() async {
    print('Iniciando carga de datos desde la base de datos...');
    final url = Uri.https(_baseUrl, 'obstacle.json');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final Map<String, dynamic> sensorMap = jsonDecode(resp.body);
      print('Datos recibidos de la base de datos: $sensorMap');

      // Convertimos el mapa a un mapa de sensores con valores enteros
      Map<String, int> Sensor_Auto= {};
      sensorMap.forEach((key, value) {
        Sensor_Auto[key] = value as int;
      });
      print('Datos cargados correctamente: $Sensor_Auto');
      return Sensor_Auto;
    } else {
      print('Error al cargar los datos desde la base de datos: ${resp.statusCode}');
      throw Exception('Error al cargar los datos desde la base de datos: ${resp.statusCode}');
    }
  }
  
}

