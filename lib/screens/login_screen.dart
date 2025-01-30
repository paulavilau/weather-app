import 'package:clima/screens/loading_screen.dart';
import 'package:clima/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instanță Firebase pentru autentificare
  String email = '';
  String password = '';
  String errorMessage = '';

  Future<void> loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Daca autentificarea este reușită, este afișat ecranul de încărcare
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(55.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) => email = value,
                style: TextStyle(fontSize: 18, color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) => password = value,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: loginUser,
                child: const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Login", style: TextStyle(fontSize: 35)),
                ),
              ),
              TextButton(
                style: const ButtonStyle(alignment: Alignment.center),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Center(
                  child: Text(
                    "Don't have an account? Register here",
                    style: TextStyle(fontSize: 26, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
