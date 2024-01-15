import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_generator_seminarski/provider/ThemeProvider.dart';
import 'package:provider/provider.dart';

import 'LoginScreen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkTheme = false;
  String selectedFont = 'Roboto';
  double fontSize = 14;

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    isDarkTheme = themeProvider.themeData.brightness ==
        Brightness.dark;
    selectedFont = themeProvider.fontName;
    fontSize = themeProvider.fontSize;
  }

    @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Postavke'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Tamna tema'),
            value: isDarkTheme,
            onChanged: (bool value) {
              setState(() {
                isDarkTheme = value;
                themeProvider.setTheme(isDarkTheme); // Ispravljeno
              });
            },
          ),

          ListTile(
            title: Text('Font'),
            trailing: Container(
              width: 150, // Ogranicava sirinu dropdown-a
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedFont,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFont = newValue!;
                    });
                    themeProvider.setFont(selectedFont);
                  },
                  items: <String>['Roboto', 'Open Sans', 'Instrument Serif', 'Montserrat', 'Noto Sans', 'Raleway', 'Bungee Spice']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          ListTile(
            title: Text('Veličina fonta'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(fontSize.round().toString()),
                Slider(
                  value: fontSize,
                  min: 10,
                  max: 24,
                  divisions: 14,
                  onChanged: (double value) {
                    setState(() {
                      fontSize = value;
                    });
                    Provider.of<ThemeProvider>(context, listen: false).setFontSize(fontSize);
                  },
                ),
              ],
            ),
          ),

          ListTile(
            title: Text('Obriši nalog'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _obrisiNalog();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _obrisiNalog() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Došlo je do greške prilikom brisanja naloga.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
