import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jit_food/Screens/AuthScreens/login_screen.dart';
import 'package:jit_food/Screens/AuthenticatedScreens/home_screen.dart';
import 'package:jit_food/global/global.dart';
import 'package:jit_food/utils/colors.dart';
import 'package:jit_food/widgets/error_dialog.dart';
import 'package:jit_food/widgets/loading_dialog.dart';
import 'package:jit_food/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // app's bg color

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

  Future<void> formValidation() async {
    if (passwordController.text == confirmPasswordController.text) {
      if (confirmPasswordController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty) {
        showDialog(
            context: context,
            builder: (c) {
              return LoadingDialog(
                message: "Registering Account",
              );
            });
        authenticateSellerAndSignUp();
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
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Password doesn't match.",
          );
        },
      );
    }
  }

  // authenticate the seller

  void authenticateSellerAndSignUp() async {
    User? currentUser;
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser =
          auth.user; // currentUser is going to saveDataToFirestore function
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

    // now save this currentUser to Firestore using saveDataToFirestore function

    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);

        // if everything works then we are authenticated and can use the app

        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  // to save the seller details on firestore

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("kitchens").doc(currentUser.uid).set({
      "kitchenUID": currentUser.uid,
      "kitchenEmail": currentUser.email,
      "kitchenName": nameController.text.trim(),
      "kitchenPhone": phoneController.text.trim(),
      "kitchenPassword": passwordController.text.trim(),
      "status": "approved",
      "earnings": 0.0,
    });

    // to save the data locally

    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Register",
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
                            "Name:",
                            style: TextStyle(
                                color: CColor.darkBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    TextFieldWidget(
                      controller: nameController,
                      hintText: "Name",
                      isObsecre: false,
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
                            "Phone:",
                            style: TextStyle(
                                color: CColor.darkBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    TextFieldWidget(
                      controller: phoneController,
                      hintText: "Phone",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Confirm Passwort:",
                            style: TextStyle(
                                color: CColor.darkBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    TextFieldWidget(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      isObsecre: true,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text(
                  "Register",
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
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  "Login?",
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
