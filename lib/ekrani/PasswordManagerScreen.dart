import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class PasswordManagerScreen extends StatefulWidget {
  @override
  _PasswordManagerScreenState createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  int _expandedIndex = -1;
  User? trenutniKorisnik;
  String? korisnikId;

  void _dohvatiTrenutnogKorisnika() async {
    trenutniKorisnik = FirebaseAuth.instance.currentUser;
    korisnikId = trenutniKorisnik?.uid;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _dohvatiTrenutnogKorisnika();
  }

  void _urediLozinku(DocumentSnapshot lozinkaData) {
    final _lozinkaController = TextEditingController(text: lozinkaData['lozinka']);
    final _korisnickoImeController = TextEditingController(text: lozinkaData['korisnickoIme']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uredi Lozinku'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _lozinkaController,
                decoration: const InputDecoration(labelText: 'Lozinka'),
              ),
              TextField(
                controller: _korisnickoImeController,
                decoration: const InputDecoration(labelText: 'Korisničko Ime'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sačuvaj'),
              onPressed: () {
                _sacuvajLozinku(
                  lozinkaData,
                  _lozinkaController.text,
                  _korisnickoImeController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sacuvajLozinku(DocumentSnapshot lozinkaData, String novaLozinka, String novoKorisnickoIme) {
    FirebaseFirestore.instance.collection('lozinke').doc(lozinkaData.id).update({
      'lozinka': novaLozinka,
      'korisnickoIme': novoKorisnickoIme
    });
  }

  void _obrisiLozinku(DocumentSnapshot lozinkaData) {
    try {
      FirebaseFirestore.instance
          .collection('korisnici')
          .doc(korisnikId)
          .collection('lozinke')
          .doc(lozinkaData.id) // Koristi ID iz DocumentSnapshot-a
          .delete()
          .then((_) {
        print('Lozinka uspešno obrisana');
      })
          .catchError((error) {
        // Obrada greške
        print('Došlo je do greške: $error');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Došlo je do greške prilikom brisanja lozinke!')
            )
        );
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Došlo je do greške prilikom brisanja lozinke!')
          )
      );
    }
  }


  void _kopirajNaKlipbord(String lozinka) {
    Clipboard.setData(ClipboardData(text: lozinka));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lozinka je kopirana na klipbord.'),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    User? trenutniKorisnik = FirebaseAuth.instance.currentUser;
    String? korisnikId = trenutniKorisnik?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menadžer Lozinki'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('korisnici')
            .doc(korisnikId)
            .collection('lozinke')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var lozinkaData = snapshot.data!.docs[index];
              return ExpansionPanelList(
                expansionCallback: (int panelIndex, bool isExpanded) {
                  setState(() {
                    _expandedIndex = _expandedIndex == index ? -1 : index;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Text(lozinkaData['imeAplikacije']),
                      );
                    },
                    body: ListTile(
                      title: Text('Generisani Pasvord: ${lozinkaData['lozinka']}'),
                      subtitle: Text('Korisničko Ime: ${lozinkaData['korisnickoIme']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () => _kopirajNaKlipbord(lozinkaData['lozinka']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _urediLozinku(lozinkaData),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _obrisiLozinku(lozinkaData),
                          ),
                        ],
                      ),
                    ),

                    isExpanded: _expandedIndex == index,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }


}
