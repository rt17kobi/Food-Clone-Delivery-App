import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jit_food/Screens/AuthenticatedScreens/parcel_delivering_screen.dart';
import 'package:jit_food/Screens/SplashScreen/splash_screen.dart';

class ParcelPickingScreen extends StatefulWidget {
  String? purchaserId;
  String? sellerId;
  String? getOrderID;
  String? purchaserAddress;

  ParcelPickingScreen({
    this.purchaserId,
    this.sellerId,
    this.getOrderID,
    this.purchaserAddress,
  });

  @override
  _ParcelPickingScreenState createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
  confirmParcelHasBeenPicked(
      getOrderId, sellerId, purchaserId, purchaserAddress) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "delivering",
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => ParcelDeliveringScreen(
          purchaserId: purchaserId,
          purchaserAddress: purchaserAddress,
          sellerId: sellerId,
          getOrderId: getOrderId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/png/no_image.png",
              width: 350,
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/png/no_image.png",
                    width: 30,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Column(
                    children: const [
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Show Cafe/Restaurant Location",
                        style: TextStyle(
                          fontFamily: "Signatra",
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) =>  SplashScreen()));
                    confirmParcelHasBeenPicked(
                      widget.getOrderID,
                      widget.sellerId,
                      widget.purchaserId,
                      widget.purchaserAddress,
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.amber,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )),
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    child: const Center(
                      child: Text(
                        "Order has been Picked",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
