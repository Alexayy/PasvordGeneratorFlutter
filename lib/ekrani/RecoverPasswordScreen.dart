import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecoverPasswordScreen extends StatefulWidget {
  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String message = '';
  bool isSuccessful = false;

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      setState(() {
        message = 'Link za resetovanje lozinke je poslat na vaš email.';
        isSuccessful = true;
      });
    } catch (e) {
      setState(() {
        message = 'Došlo je do greške: $e';
        isSuccessful = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oporavak Lozinke'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            ElevatedButton(
              onPressed: resetPassword,
              child: Text('Pošalji zahtev za resetovanje'),
            ),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: isSuccessful ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
