import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "registerScreen";

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future _register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        print("Created new account");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR");
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.1, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Enter Email"),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: "Enter Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                icon: const Icon(
                  Icons.lock_open,
                  size: 32,
                ),
                label: const Text(
                  "Register",
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
