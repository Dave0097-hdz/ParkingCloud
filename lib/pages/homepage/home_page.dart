import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:parkcloud/config/colors.dart';
import 'package:parkcloud/pages/booking_page/booking_page.dart';

class HomePage extends StatefulWidget {
  final String? slotId; // Cambiado a String?
  final String slotName;

  HomePage({required this.slotId, required this.slotName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {}); // Actualiza la UI cada segundo
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela el temporizador al salir de la página
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20),
            Text(
              "PARKING CLOUD",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // parkingController.timeCounter();
              Get.toNamed("/edit-profile");
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
              size: 30, // Tamaño del icono aumentado
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('parking').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Parking Slots",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 60),
                  // Parking slots
                  Column(
                    children: snapshot.data!.docs.map((document) {
                      final Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      final String slotName = document.id;
                      final int estado = data['estado'];
                      final Timestamp? fechaInicio = data['fecha_inicio'] as Timestamp?;
                      final Timestamp? fechaTerminar = data['fecha_terminar'] as Timestamp?;

                      final DateTime now = DateTime.now();
                      final bool isBooked = estado == 1 && fechaTerminar != null && fechaTerminar.toDate().isAfter(now);

                      // Calcular tiempo restante en horas y minutos
                      final Duration remainingTime = fechaTerminar!.toDate().difference(now);
                      final int hours = remainingTime.inHours;
                      final int minutes = remainingTime.inMinutes.remainder(60);

                      String remainingTimeString = '';
                      if (hours > 0) {
                        remainingTimeString = '${hours}h ${minutes}m';
                      } else {
                        remainingTimeString = '${minutes}m';
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            leading: estado == 1
                                ? Image.asset(
                                    'assets/images/car.png',
                                    width: 80, // Ajusta el ancho de la imagen aquí
                                    height: 80, // Ajusta el alto de la imagen aquí
                                  )
                                : null,
                            title: Text(slotName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Estado: ${estado == 1 ? 'Ocupado' : 'Disponible'}'),
                                if (estado == 1) // Mostrar solo cuando el estado es 1 (ocupado)
                                  Text('Tiempo restante: $remainingTimeString'),
                              ],
                            ),
                            trailing: estado == 0 // Mostrar el botón solo cuando el estado es 0 (disponible)
                              ? ElevatedButton(
                                  onPressed: () {
                                    // Navegar a la vista de reserva
                                    if (widget.slotId != null) {
                                      Get.to(() => BookingPage(slotId: widget.slotId!, slotName: slotName));
                                    } else {
                                      print('Error: slotId es nulo');
                                    }
                                  },
                                  child: Text('Reservar'),
                                )
                              : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
