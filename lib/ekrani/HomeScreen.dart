import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:password_generator_seminarski/ekrani/PasswordManagerScreen.dart';
import 'package:password_generator_seminarski/ekrani/SettingsScreen.dart';
import 'package:password_generator_seminarski/ekrani/ukrasniEkrani/AboutUsScreen.dart';
import 'package:password_generator_seminarski/ekrani/ukrasniEkrani/FAQScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? trenutniKorisnik;
  String? korisnikId;

  TextEditingController lozinkaController = TextEditingController();

  int selectedIndex = 0;
  String generisanaLozinka = '';
  String imeAplikacije = '';
  String korisnickoIme = '';

  @override
  void dispose() {
    lozinkaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dohvatiTrenutnogKorisnika();
    _inicijalizujFCM();
  }

  void _inicijalizujFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Dobijanje tokena
    String? token = await messaging.getToken();
    print("FirebaseMessaging token: $token");

    // cUVANJE u firestoru
    if (token != null) {
      _sacuvajFCMToken(token);
    }

    // listen na promene
    messaging.onTokenRefresh.listen(_sacuvajFCMToken);
  }

  void _sacuvajFCMToken(String token) async {
    if (korisnikId != null) {
      await FirebaseFirestore.instance
          .collection('korisnici')
          .doc(korisnikId)
          .set({'fcmToken': token}, SetOptions(merge: true));
    }
  }

  void _dohvatiTrenutnogKorisnika() async {
    trenutniKorisnik = FirebaseAuth.instance.currentUser;
    korisnikId = trenutniKorisnik?.uid;

    setState(() {});
  }

  String generisiNasumicnuLozinku(int duzina) {
    const karakteri =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`~!@#%^&*()_+|}]{[":;?/>.<,';
    final random = Random.secure();
    return List.generate(
        duzina, (index) => karakteri[random.nextInt(karakteri.length)]).join();
  }

  void sacuvajLozinku(
      String lozinka, String imeAplikacije, String korisnickoIme) async {
    try {
      await FirebaseFirestore.instance
          .collection('korisnici')
          .doc(korisnikId)
          .collection('lozinke')
          .add({
        'lozinka': lozinka,
        'imeAplikacije': imeAplikacije,
        'korisnickoIme': korisnickoIme,
        'vremeGenerisanja': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Lozinka nije sačuvana, desila se greška sa serverom!')),
      );
    }
  }

  void generisiLozinku() async {
    final novaLozinka = generisiNasumicnuLozinku(16);
    setState(() {
      generisanaLozinka = novaLozinka;
      lozinkaController.text = novaLozinka;
    });

    sacuvajLozinku(generisanaLozinka, imeAplikacije, korisnickoIme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PupinCrypt - Seminarski rad'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text(trenutniKorisnik != null ? 'PupinCrypt: \n${trenutniKorisnik!.email}' : 'PupinCrypt'),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(image: AssetImage('aseti/android/logo/PupinCrypt-logos_transparent.png'), fit: BoxFit.contain),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.key_rounded),
                    title: const Text('Generator'),
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.psychology_rounded),
                    title: const Text('Menadžer Lozinki'),
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            // Anchorovani deo na dnu
            Column(
              children: <Widget>[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.emoji_emotions_rounded),
                  title: const Text('O nama'),
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.question_mark_rounded),
                  title: const Text('FAQ'),
                  onTap: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_rounded),
                  title: const Text('Postavke'),
                  onTap: () {
                    setState(() {
                      selectedIndex = 4;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Logout'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: getDrawerItemWidget(selectedIndex),
    );
  }

  Widget getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return buildGeneratorScreen();
      case 1:
        return PasswordManagerScreen();
      case 2:
        return AboutUsScreen();
      case 3:
        return FAQScreen();
      case 4:
        return SettingsScreen();
      default:
        return const Text('Nepoznata opcija');
    }
  }

  Widget buildGeneratorScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: lozinkaController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Generisana Lozinka',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: generisanaLozinka));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lozinka kopirana u klipbord!')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            onChanged: (value) => imeAplikacije = value,
            decoration: const InputDecoration(
              labelText: 'Ime Aplikacije',
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            onChanged: (value) => korisnickoIme = value,
            decoration: const InputDecoration(
              labelText: 'Korisničko Ime',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              generisiLozinku();
              setState(() {
                generisanaLozinka = '';
              });
            },
            child: const Text('Generiši Lozinku'),
          ),
        ],
      ),
    );
  }
}
