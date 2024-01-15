import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;
  String _fontName = 'Roboto';
  double _fontSize = 14.0;
  bool _isDarkTheme = false;

  ThemeProvider() {
    // Inicijalizacija sa osnovnim temama
    _themeData = ThemeData(
      brightness: Brightness.light,
      textTheme: GoogleFonts.getTextTheme(
        'Roboto',
        TextTheme(bodyText1: TextStyle(fontSize: 14.0)),
      ),
    );
    _loadPreferences();
  }

  ThemeData get themeData => _themeData;
  String get fontName => _fontName;
  double get fontSize => _fontSize;

  void _applyPreferences() {
    _themeData = ThemeData(
      brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
      textTheme: GoogleFonts.getTextTheme(
        _fontName,
        TextTheme(
          headline1: TextStyle(fontSize: _fontSize * 2.5), // Naslov 1
          headline2: TextStyle(fontSize: _fontSize * 2.0), // Naslov 2
          headline3: TextStyle(fontSize: _fontSize * 1.75), // Naslov 3
          headline4: TextStyle(fontSize: _fontSize * 1.5), // Naslov 4
          headline5: TextStyle(fontSize: _fontSize * 1.25), // Naslov 5
          headline6: TextStyle(fontSize: _fontSize * 1.15), // Naslov 6
          subtitle1: TextStyle(fontSize: _fontSize * 1.0), // Podnaslov 1
          subtitle2: TextStyle(fontSize: _fontSize * 0.85), // Podnaslov 2
          bodyText1: TextStyle(fontSize: _fontSize), // Osnovni tekst 1
          bodyText2: TextStyle(fontSize: _fontSize * 0.85), // Osnovni tekst 2
          caption: TextStyle(fontSize: _fontSize * 0.7), // Natpis
          button: TextStyle(fontSize: _fontSize * 0.85), // Dugme
          overline: TextStyle(fontSize: _fontSize * 0.7), // Preko reda
        ),
      ),
    );
    notifyListeners();
  }

  setTheme(bool isDark) async {
    _isDarkTheme = isDark;
    _applyPreferences();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
  }

  setFont(String fontName) async {
    _fontName = fontName;
    _applyPreferences();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontName', _fontName);
  }

  setFontSize(double fontSize) async {
    _fontSize = fontSize;
    _applyPreferences();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fontName = prefs.getString('fontName') ?? 'Roboto';

    // Dodajte proveru da li font postoji u vašoj listi
    if (!['Roboto', 'Open Sans', 'Instrument Serif', 'Montserrat', 'Noto Sans', 'Raleway', 'Bungee Spice'].contains(fontName)) {
      fontName = 'Roboto'; // Ako ne postoji, postavi na podrazumevani font
    }

    _fontName = fontName;
    _fontSize = prefs.getDouble('fontSize') ?? 14.0;
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;

    _applyPreferences();
  }


}
