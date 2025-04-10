// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkcloud/config/colors.dart';
import 'package:parkcloud/pages/homepage/home_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> controller = Completer();
    const LatLng center = LatLng(17.2042, -93.0157);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/white_logo.png",
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 20),
            const Text(
              "CAR PARKING CLOUD",
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
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              )),
        ],
        centerTitle: true,
      ),
      body: GoogleMap(
        buildingsEnabled: true,
        compassEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: center,
          zoom: 18.0,
        ),
        markers: {
          Marker(
            visible: true,
            onTap: () {
              String slotId = 'A-1'; // ID del slot seleccionado
              String slotName = 'A-1'; // Nombre del slot seleccionado
              Get.to(() => HomePage(slotId: slotId, slotName: slotName));
            },
            markerId: MarkerId('parking_1'),
            position: LatLng(17.2042, -93.0157),
          ),
          Marker(
            visible: true,
            onTap: () {
              String slotId = 'A-2'; // ID del slot seleccionado
              String slotName = 'A-2'; // Nombre del slot seleccionado
              Get.to(() => HomePage(slotId: slotId, slotName: slotName));
            },
            markerId: MarkerId('parking_2'),
            position: LatLng(17.1970, -93.0089),
          ),
          Marker(
            visible: true,
            onTap: () {
              String slotId = 'A-3'; // ID del slot seleccionado
              String slotName = 'A-3'; // Nombre del slot seleccionado
              Get.to(() => HomePage(slotId: slotId, slotName: slotName));
            },
            markerId: MarkerId('parking_3'),
            position: LatLng(17.2462,  -93.01765),
          ),
          Marker(
            visible: true,
            onTap: () {
              String slotId = 'A-4'; // ID del slot seleccionado
              String slotName = 'A-4'; // Nombre del slot seleccionado
              Get.to(() => HomePage(slotId: slotId, slotName: slotName));
            },
            markerId: MarkerId('parking_4'),
            position: LatLng(17.2042, -93.0157),
          ),
          Marker(
            visible: true,
            onTap: () {
              String slotId = 'A-5'; // ID del slot seleccionado
              String slotName = 'A-5'; // Nombre del slot seleccionado
              Get.to(() => HomePage(slotId: slotId, slotName: slotName));
            },
            markerId: MarkerId('parking_5'),
            position: LatLng(17.2042, -93.0157),
          ),
        },
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {},
      ),
    );
  }
}
