import 'package:clima/screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String errorMessage = '';

  Future<void> registerUser() async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
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
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(55.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              obscureText: true,
              onChanged: (value) => password = value,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 10),
            Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: registerUser,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Register", style: TextStyle(fontSize: 30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
