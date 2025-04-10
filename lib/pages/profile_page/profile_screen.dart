import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkcloud/config/colors.dart';
import 'package:parkcloud/pages/LoginPage.dart';

class ImageController extends GetxController {
  Rx<File?> userImage = Rx<File?>(null);

  void setUserImage(File? image) {
    userImage.value = image;
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  late String _userId = '';
  late String _userName = '';
  late String _userEmail = '';
  late String _userPassword = '';
  late ImageController _imageController;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _imageController = Get.put(ImageController());
  }

  Future<void> _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        _userName = user.displayName ?? 'No name';
        _userEmail = user.email ?? 'No email';
        _userPassword = '********'; // Muestra asteriscos por seguridad
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageController.setUserImage(File(pickedFile.path));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: blueColor, // Cambia el color del app bar
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _getImageFromGallery,
              child: Obx(() => CircleAvatar(
                    radius: 120, // Cambia el tamaño de la imagen
                    backgroundImage: _imageController.userImage.value != null
                        ? FileImage(_imageController.userImage.value!)
                        : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                  )),
            ),
            const SizedBox(height: 20),
            itemProfile('Name', _userName, Icons.person),
            const SizedBox(height: 10),
            itemProfile('Email', _userEmail, Icons.mail),
            const SizedBox(height: 10),
            itemProfile('Contraseña', _userPassword, Icons.lock),
            const SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Cerrar sesión y redirigir al login
                  Get.offAll(() => LoginPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Cambia el color del botón
                  padding: const EdgeInsets.all(15),
                ),
                child: Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.deepOrange.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );
  }
}
