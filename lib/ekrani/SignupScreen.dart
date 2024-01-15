import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Kontroleri za unos teksta
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Funkcija za registraciju korisnika
  Future<void> signupUser() async {
    try {
      // Koristim FirebaseAuth za kreiranje novog korisnika
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigacija na ekran za login nakon uspešne registracije
      Navigator.pop(context); // Ovo ce vratiti korisnika na prethodni ekran (pretpostavljajući da je to Login ekran)
    } catch (e) {
      // Obradjujem greške koje se mogu javiti pri registraciji
      print('Došlo je do greške pri registraciji: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registracija'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Lozinka',
              ),
              obscureText: true,
            ),
          ),
          ElevatedButton(
            onPressed: signupUser,
            child: Text('Registruj se'),
          ),
        ],
      ),
    );
  }
}
