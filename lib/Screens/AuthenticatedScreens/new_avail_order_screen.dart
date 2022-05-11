import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jit_food/widgets/order_card.dart';

import '../../widgets/progress_bar.dart';



class NewOrdersScreen extends StatefulWidget
{
  @override
  _NewOrdersScreenState createState() => _NewOrdersScreenState();
}



class _NewOrdersScreenState extends State<NewOrdersScreen>
{
  seperateOrderItemIDs(orderIDs) {
    List<String> seperateItemIDsList = [], defaultItemList = [];
    int i = 0;
    defaultItemList = List<String>.from(orderIDs);

    for (i; i < defaultItemList.length; i++) {
      // id:count
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(":");

      // only id left
      String getItemId = (pos != -1) ? item.substring(0, pos) : item;
      print("\n This is itemID now= " + getItemId);

      seperateItemIDsList.add(getItemId);
    }

    print("\n This is Items List now=");
    print(seperateItemIDsList);
    return seperateItemIDsList;
  }
  separateOrderItemQuantities(orderIDs) {
    List<String> seperateItemQuantityList = [];
    List<String> defaultItemList = [];
    int i = 1;

    defaultItemList = List<String>.from(orderIDs);

    for (i; i < defaultItemList.length; i++) {
      // id:count
      String item = defaultItemList[i].toString();

      // : & count is left
      List<String> listItemCharacters = item.split(":").toList();

      // only 1st index count is left
      var quanNumber = int.parse(listItemCharacters[1].toString());

      print("\n This is Quantity No= " + quanNumber.toString());

      seperateItemQuantityList.add(quanNumber.toString());
    }

    print("\n This is Items Quantity List now=");
    print(seperateItemQuantityList);
    return seperateItemQuantityList;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("status", isEqualTo: "normal")
              .orderBy("orderTime", descending: true)
              .snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, index)
                    {
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("itemID", whereIn: seperateOrderItemIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>) ["productIDs"]))
                            .where("orderBy", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                            .orderBy("publishedDate", descending: true)
                            .get(),
                        builder: (c, snap)
                        {
                          return snap.hasData
                              ? OrderCard(
                            itemCount: snap.data!.docs.length,
                            data: snap.data!.docs,
                            orderID: snapshot.data!.docs[index].id,
                            seperateQuantitiesList: separateOrderItemQuantities((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]),
                          )
                              : Center(child: circularProgress());
                        },
                      );
                    },
                  )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}