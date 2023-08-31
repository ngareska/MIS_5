import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LogInScreen extends StatefulWidget {
  static const String id = "loginScreen";

  @override
  LogInScreenState createState() => LogInScreenState();
}

class LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loginFail = false;
  bool passwordError = false;
  bool emailError = false;
  String loginErrorMessage = "test";

  Future _logIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        print("User logged in successfully");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR");
      print(e.message);
      loginFail = true;
      loginErrorMessage = e.message!;

      if (loginErrorMessage ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        emailError = true;
        loginErrorMessage = "User does not exist, please create new account";
      } else {
        passwordError = true;
        loginErrorMessage = "The password you entered is incorrect";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.1, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              const Text(
                "Welcome",
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: "Email",
                    errorText: emailError ? loginErrorMessage : null),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    labelText: "Password",
                    errorText: passwordError ? loginErrorMessage : null),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                child: const Text(
                  "Log In",
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: _logIn,
              ),
              const SizedBox(height: 20),
              RegisterOption()
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account yet?"),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          child: const Text(
            " Register now!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
