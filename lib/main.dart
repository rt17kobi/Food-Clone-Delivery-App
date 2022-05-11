import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jit_food/Screens/AuthScreens/login_screen.dart';
import 'package:jit_food/Screens/SplashScreen/splash_screen.dart';
import 'package:jit_food/Screens/AuthScreens/register_screen.dart';
import 'package:jit_food/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Asynchronous operations let your program complete work while waiting for another operation to finish.
  // To perform asynchronous operations in Dart, you can use the Future class and the async and await keywords.
  // A future represents the result of an asynchronous operation

  WidgetsFlutterBinding.ensureInitialized();

  // this makes sure that you have an instance of the WidgetsBinding, which is required to use platform channels to call the native code.

  // initialize the SharedPreferences for the local storage

  sharedPreferences = await SharedPreferences.getInstance();

  // initialize the firebase

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitchen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
