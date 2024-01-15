import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:password_generator_seminarski/firebase_options.dart';
import 'package:provider/provider.dart';
import 'provider/ThemeProvider.dart';
import 'ekrani/HomeScreen.dart';
import 'ekrani/LoginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  String? token = await messaging.getToken();
  print("FirebaseMessaging token: $token");
  print("FirebaseAnalytics token: $observer");

  // Obrada notifikacija u pozadini
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Obrada notifikacija u prvom planu
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message clicked! Navigating to HomeScreen');
    if (message.data.containsKey('some_key')) {
      String value = message.data['some_key'];
    }
    runApp(
      MaterialApp(
        home: HomeScreen(), // Navigacija na HomeScreen
      ),
    );
  });

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'PupinCrypt',
            theme: themeProvider.themeData,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return HomeScreen();
                }
                return LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
