import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_generator_seminarski/ekrani/RecoverPasswordScreen.dart';
import 'package:password_generator_seminarski/ekrani/SignupScreen.dart';

import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showError = false;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Nakon uspesnog logina, preusmeri na HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        showError = true;
      });
      animationController?.forward(from: 0.0);
    }
  }


  Widget buildTextField(String label, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          errorText: showError ? "Pogrešan email ili lozinka" : null,
        ),
        obscureText: obscureText,
        keyboardType: obscureText ? TextInputType.text : TextInputType.emailAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: <Widget>[
          // Direktno koristim buildAnimatedTextField
          buildAnimatedTextField("Email", emailController, false),
          buildAnimatedTextField("Lozinka", passwordController, true),
          ElevatedButton(
            onPressed: loginUser,
            child: Text('Uloguj se'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()),
              );
            },
            child: Text('Nemate nalog? Registrujte se'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecoverPasswordScreen()),
              );
            },
            child: Text('Zaboravili ste lozinku?'),
          )
        ],
      ),
    );
  }


  Widget buildAnimatedTextField(String label, TextEditingController controller, bool obscureText) {
    // Provera da li je animationController null
    if (animationController == null) {
      // Ako jeste, samo prikazi obično tekstualno polje
      return buildTextField(label, controller, obscureText);
    }

    // Ako nije, koristi AnimatedBuilder
    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, child) {
        final double offset = showError ? animationController!.value * 20.0 : 0.0;
        return Transform.translate(
          offset: Offset(offset, 0.0),
          child: child,
        );
      },
      child: buildTextField(label, controller, obscureText),
    );
  }

}
