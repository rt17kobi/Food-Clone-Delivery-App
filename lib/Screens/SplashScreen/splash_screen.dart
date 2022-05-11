import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jit_food/Screens/AuthScreens/login_screen.dart';
import 'package:jit_food/Screens/AuthenticatedScreens/home_screen.dart';
import 'package:jit_food/global/global.dart';
import 'package:jit_food/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color.fromRGBO(176, 201, 217, 1),
      const Color.fromRGBO(192, 206, 214, 1),
      const Color.fromRGBO(242, 250, 255, 1),
    ],
    stops: [0, 0.2, 1],
  );

  startTimer() {
    Timer(Duration(seconds: 2), () async {
      if (firebaseAuth.currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/img/png/jit-logo.png",
                width: MediaQuery.of(context).size.width * 0.4,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Just In Time Food",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CColor.darkBlue,
                  fontSize: 20,
                  fontFamily: "Hind-Bold",
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Kitchen",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CColor.darkBlue,
                  fontSize: 20,
                  fontFamily: "Hind-Bold",
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
