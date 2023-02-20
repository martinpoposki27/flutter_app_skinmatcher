import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lab193004/model/user.dart';
import 'package:lab193004/widgets/product_detail.dart';

import '../model/list_item.dart';
import '../screens/maps/map_view.dart';
import '../services/database.dart';




class NoProductFound extends StatefulWidget {
  const NoProductFound({Key? key}) : super(key: key);

  @override
  State<NoProductFound> createState() => _NoProductFoundState();

}
class _NoProductFoundState extends State<NoProductFound> {

  String _barCode = "";

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

  void initState() {
    super.initState();
    //_getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showScannedProduct();
        },
        backgroundColor: Colors.red.shade200,
        child: const Icon(Icons.qr_code_scanner),
      ),
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 250,
              child: Text(
                '${"No such product found, please try again or add the product first!"}',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250,
              child: Text(
                '${"This can happen if your camera lens are dirty or you haven't aligned the barcode well."}',
                style: TextStyle(fontSize: 15, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              height: 50,
            ),
            // Text(
            //   '${"For the user ${user.name} this product got score of:"}',
            //   style: TextStyle(fontSize: 20),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // Text(
            //   '${_score()}',
            //   style: TextStyle(fontSize: 25),
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // SizedBox(
            //   width: 200,
            //   height: 200,
            //   child: CircularProgressIndicator(
            //     strokeWidth: 20,
            //     backgroundColor: Colors.red.shade100,
            //     valueColor: AlwaysStoppedAnimation(Colors.red.shade400),
            //     value: matchingPercent(),
            //     semanticsLabel: 'Circular progress indicator',
            //   ),
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // Text(
            //   '${matchingPercentGrade()}',
            //   style: TextStyle(fontSize: 30),
            // ),
          ],
        ),
      ),
      // floatingActionButton: widget.product.location.isEmpty ? Text("Not in stock") :
      // FloatingActionButton.extended(
      //   // onPressed: () async {
      //   //   Navigator.push( context, MaterialPageRoute(builder: (context) => MapSample()));
      //   //   },
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => MapSample(productName: widget.product.productName, location: widget.product.location,cameraPosition: widget.product.location),
      //       ),
      //     );
      //   },
      //   label: const Text('Show on map'),
      //   icon: const Icon(Icons.map),
      //   backgroundColor: Colors.red.shade400,
      // ),
    );
  }
}