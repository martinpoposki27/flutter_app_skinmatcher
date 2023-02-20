import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab193004/model/list_item.dart';
import 'package:lab193004/widgets/product_detail.dart';
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../../services/notification_service.dart';
import '../../services/notifications_service.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../widgets/no_product_found.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {

  late final LocalNotificationsService notificationsService;
  String _barCode = "";

  @override
  void initState() {
    notificationsService = LocalNotificationsService();
    notificationsService.initialize();
    super.initState();
  }

  static List<Map> convertListItemsToMap(List<ListItem>? listItems) {
    List<Map> items = [];
    listItems!.forEach((ListItem listItem) {
      Map item = listItem.toMap();
      items.add(item);
    });
    return items;
  }

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _barCode = value));
  }

  void _showScannedProduct() async {
    await _scan();
    ListItem product = await DatabaseService(
        FirebaseAuth.instance.currentUser!.uid).getItemByBarcode(_barCode);

    if (product.id == "searching") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoProductFound(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetail(product: product),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final userList = Provider.of<List<ListItem>>(context) ?? [];

    void _deleteListItem(String id) async {

      // final String userId = FirebaseAuth.instance.currentUser!.uid;
      //
      // Future<UserData> currentUserData () async  {
      //   return await DatabaseService(userId).userData.first;
      // }
      //
      // UserData userData = await currentUserData();

      setState(() {
        userList.removeWhere((element) => element.id == id);
      });
      print(userList);
      await DatabaseService(FirebaseAuth.instance.currentUser!.uid).updateUserProducts(convertListItemsToMap(userList)
          // userData.name,
          // userData.oiliness,
          // userData.sensitiveness,
          // userData.acne,
          // userData.spots
      );
    }

    // void notificationScheduler(int index) async {
    //   ListItem item = userList[index];
    //   DateTime dateTime = item.dateTime;
    //   WidgetsFlutterBinding.ensureInitialized();
    //   NotificationsService().initializeNotification();
    //   NotificationsService().showNotification(1, item.productName, item.productName, dateTime);
    //   //notificationsService.showScheduledNotification(id: 0, title: item.subject, body: item.subject, seconds: 5);
    //   await DatabaseService(FirebaseAuth.instance.currentUser!.uid).updateUserProducts(convertListItemsToMap(userList));
    // }

    // exams.forEach((exam) {
    //   print(exam.subject);
    //   print(exam.dateTime);
    // });

    // for(var doc in exams!.docs) {
    //   //if doc.id == uid
    //   var categories = (doc.get('exams'));
    //   for(var item in categories) {
    //     print(item["dateTime"]);
    //   }
    // }

    // List<ListItem> list = [];
    //   for(var doc in exams!.docs) {
    //     if (doc.id == FirebaseAuth.instance.currentUser?.uid) {
    //       for (var arg in doc.get("exams")) {
    //         print((arg["dateTime"] as Timestamp).toDate());
    //         ListItem listItem = ListItem(arg["id"], arg["subject"],
    //             (arg["dateTime"] as Timestamp).toDate());
    //         list.add(listItem);
    //       }
    //     }
    //   }
    //   print(list);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showScannedProduct();
        },
        backgroundColor: Colors.red.shade200,
        child: const Icon(Icons.qr_code_scanner),
      ),
      body: userList.isEmpty ? Text("No products.") :
      ListView.builder(itemBuilder: (ctx, index) {
        return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: ListTile(
              title: Text(userList[index].productName),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetail(product: userList[index]),
                  ),
                );
              },
                subtitle: Text(userList[index]!.location),
              //subtitle: Text("Date: " + userList[index].dateTime.day.toString() + "." + userList[index].dateTime.month.toString() + "." + userList[index].dateTime.year.toString() + "     Time: " + userList[index].dateTime.hour.toString() + ":" + userList[index].dateTime.minute.toString()),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IconButton(
                    //     onPressed: () => notificationScheduler(index),
                    //     icon: Icon(Icons.notifications_active)
                    // ),
                    // IconButton(
                    //     onPressed: () {
                    //       // Step 3 <-- SEE HERE
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => ProductDetail(title: userList[index].barCode),
                    //         ),
                    //       );
                    //     },
                    //     icon: Icon(Icons.info)
                    //),
                    IconButton(
                      onPressed: () => _deleteListItem(userList[index].id),
                      icon: Icon(Icons.delete)
                      ),
                  ]
              )
           )
        );
      },
        itemCount: userList.length,
      ),
    );
  }
}
