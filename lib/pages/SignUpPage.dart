// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkcloud/components/form_container.dart';
import 'package:parkcloud/components/toast.dart';
import 'package:parkcloud/pages/LoginPage.dart';
import '../service/service/auth.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Crear cuenta"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Crear cuenta",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Nombre de usuario",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Correo electronico",
                isPasswordField: false,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Contraseña",
                isPasswordField: true,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap:(){
                  _signUp();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: isSigningUp ? CircularProgressIndicator(color: Colors.white,):Text(
                        "Crear cuenta",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ya tienes una cuentaa?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap:() {
                        Get.offAll(() => LoginPage());
                      //Navigator.pushNamed(context, "/LoginPage");
                    },
                      child: Text(
                        "iniciar sesion",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //metodo para registra un usuario

  void _signUp() async {

    setState(() {
      isSigningUp = true;
    });
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty || username.isEmpty){
      showToast(message: 'Por favor rellene todos los campos');
      setState(() {
      isSigningUp = false;
    });
    }else{

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      
      _createUser(UserModel(
        username: username, 
        email: email, 
        password: password
        ));
        
      showToast(message: "Usuario creado correctamente");
      Get.offAll(() => LoginPage());
      //Navigator.pushNamed(context, "/loginpage");
    }else{
      print("Ocurrio un error");
    }
    }
  }
  
  //crea el usuario en Firestore Database
  void _createUser(UserModel userModel) { 

    final userCollection = FirebaseFirestore.instance.collection("usuarios");

    String id = userCollection.doc().id;

    final newUser = UserModel(
      username: userModel.username, 
      email: userModel.email, 
      password: userModel.password,
      id: id,
      ).toJson();

      userCollection.doc(id).set(newUser);
  }
}

  class UserModel{
    final String? username;
    final String? email;
    final String? password;
    final String? id;

  UserModel({this.id, required this.username, required this.email, required this.password});

  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>>snapshot){
    return UserModel(
      username: snapshot['username'], 
      email: snapshot['email'], 
      password: snapshot['password']
      );
  }

  Map<String, dynamic> toJson(){
    return{
      "username": username,
      "email": email,
      "password": password,
      "id": id,
    };
  }
}