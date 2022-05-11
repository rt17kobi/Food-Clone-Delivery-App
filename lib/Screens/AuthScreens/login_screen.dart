import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jit_food/Screens/AuthScreens/register_screen.dart';
import 'package:jit_food/Screens/AuthenticatedScreens/home_screen.dart';
import 'package:jit_food/global/global.dart';
import 'package:jit_food/utils/colors.dart';
import 'package:jit_food/widgets/error_dialog.dart';
import 'package:jit_food/widgets/loading_dialog.dart';
import 'package:jit_food/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  //  vildation of the textfields

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      loginNow();
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Fill all the fields.",
          );
        },
      );
    }
  }

  // function to allow the user to login sucessfully

  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: "Checking Credentials.",
        );
      },
    );

    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser =
          auth.user!; // currentUser is going to saveDataToFirestore function
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    // now get this currentUser to Firestore using readDataAndSetDataLocally function

    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!);
    }
  }

  // function to check data on firebase and set it locally as well

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("kitchens")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!
            .setString("email", snapshot.data()!["kitchenEmail"]);
        await sharedPreferences!
            .setString("name", snapshot.data()!["kitchenName"]);

        // if everything works then we are authenticated and can use the app

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "kitchen account doesn't exist",
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.greenAccent,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.6,
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: SvgPicture.asset(
                      'assets/img/svg/jit-logo.svg',
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      child: Text("Herzlich Willkommen",
                          style: TextStyle(
                              color: CColor.darkBlue,
                              fontSize: 40,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: CColor.darkBlue,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Email:",
                            style: TextStyle(
                                color: CColor.darkBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    TextFieldWidget(
                      controller: emailController,
                      hintText: "Email",
                      isObsecre: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Passwort:",
                            style: TextStyle(
                                color: CColor.darkBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    TextFieldWidget(
                      controller: passwordController,
                      hintText: "Password",
                      isObsecre: true,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                onPressed: () {
                  formValidation();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: Text(
                  "Register?",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
