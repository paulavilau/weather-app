import 'package:clima/screens/loading_screen.dart';
import 'package:clima/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  // Ne asigurăm că toate legăturile Flutter cu SO au fost inițializate
  WidgetsFlutterBinding.ensureInitialized();

  // Inițializare Firebase folosind opțiunile specifice platformei
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Rularea propriu zisă a aplicației
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Ascultarea modificărilor legate de autentificare
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return LoadingScreen(); // Daca userul este logat, afișăm ecranul de încărcare
        } else {
          return LoginScreen(); // Daca nu, afisăm ecranul de autentificare
        }
      },
    );
  }
}
