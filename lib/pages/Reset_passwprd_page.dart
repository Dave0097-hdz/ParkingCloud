// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkcloud/components/form_container.dart';
import 'package:parkcloud/pages/LoginPage.dart';
import 'package:parkcloud/pages/MapPage.dart';
import '../service/service/auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();

  @override

  void dispose(){
    _emailController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Restablecer Contraseña",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText:  "Email",
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: (){
                  PasswordReset();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Enviar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Regresar al "),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap:() {
                        Get.offAll(() => LoginPage());
                      //Navigator.pushNamed(context, "/loginpage");
                    },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
  void PasswordReset() async{

  String email = _emailController.text;
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text ("Se ha enviado un link para restablecer tu contraseña a tu correo"),
        );
      }
    );
  } on FirebaseAuthException catch (e) {
    print(e); 
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text (e.message.toString()),
        );
      }
    );
  }
}
}