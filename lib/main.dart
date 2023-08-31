// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mis_lab3/screens/login_screen.dart';
import 'package:mis_lab3/screens/register_screen.dart';

import 'screens/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        initialRoute: LogInScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LogInScreen.id: (context) => LogInScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
        });
  }
}
