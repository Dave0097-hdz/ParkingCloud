// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkcloud/components/form_container.dart';
import 'package:parkcloud/components/toast.dart';
import 'package:parkcloud/pages/MapPage.dart';
import 'package:parkcloud/pages/Reset_passwprd_page.dart';
import 'package:parkcloud/pages/SignUpPage.dart';
import '../service/service/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigning = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
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
                "Iniciar sesion",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(height: 30),
              _buildLoginButton(),
              SizedBox(height: 10),
              _buildGoogleSignInButton(),
              SizedBox(height: 20),
              _buildSignUpLink(),
              _buildResetPasswordLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _isSigning ? null : _signInWithEmailPassword,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _isSigning
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return GestureDetector(
      onTap: _isSigning ? null : _signInWithGoogle,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.google, color: Colors.white),
              SizedBox(width: 5),
              Text(
                "Sign in with Google",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?"),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () => Get.to(SignUpPage()),
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetPasswordLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Forgot your password? "),
        GestureDetector(
          onTap: () => Get.to(ResetPassword()),
          child: Text(
            "Reset here",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _signInWithEmailPassword() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showToast(message: 'Fields cannot be empty');
      setState(() {
        _isSigning = false;
      });
      return;
    }

    User? user = await _authService.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "Signed in successfully");
      Get.offAll(() => MapPage());
      //Navigator.pushNamed(context, "/homepage");
    } else {
      print("Error signing in");
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();

      if (googleSignInAccount != null) {
        await _googleSignIn.signOut();

        final GoogleSignInAccount? newGoogleSignInAccount = await _googleSignIn
            .signIn();

        if (newGoogleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication = await newGoogleSignInAccount
              .authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          final UserCredential authResult = await FirebaseAuth.instance
              .signInWithCredential(credential);
          final User? user = authResult.user;

          if (user != null) {
            showToast(message: "Signed in with Google successfully");
            Get.offAll(() => MapPage());
          } else {
            showToast(message: "Error signing in with Google");
          }
        }
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }

}
