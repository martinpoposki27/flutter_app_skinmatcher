import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab193004/model/user.dart';

import '../model/list_item.dart';
import '../screens/maps/map_view.dart';
import '../services/database.dart';




class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.product}) : super(key: key);
  final ListItem product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();

}
class _ProductDetailState extends State<ProductDetail> {

  UserData user = UserData("uid", "Loading...", "Dry", 100, false, false);

  Future<void> _getUserData() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    Future<UserData> currentUserData () async  {
      return await DatabaseService(userId).userData.first;
    }

    UserData userData = await currentUserData();

    currentUserData().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  void initState() {
    super.initState();
    _getUserData();
  }

  String _score() {
    int score = 0;
    //min -400
    //max 330
    if(user.acne) {
      if(widget.product.retinoid){
        score += 20;
      }
      if(widget.product.citricAcid){
        score += 5;
      }
      if(widget.product.glycerin){
        score += 10;
      }
      if(widget.product.methyl){
        score += 5;
      }
      if(widget.product.parfum){
        score -= 50;
      }
      if(widget.product.urea){
        score -= 20;
      }
      if(widget.product.vitaminC){
        score += 5;
      }
      if(widget.product.antibacterial){
        score += 20;
      }
    }
    if(user.spots) {
      if(widget.product.retinoid){
        score -= 10;
      }
      if(widget.product.citricAcid){
        score += 10;
      }
      if(widget.product.glycerin){
        score += 10;
      }
      if(widget.product.methyl){
        score -= 20;
      }
      if(widget.product.niacinamide){
        score += 20;
      }
      if(widget.product.parfum){
        score -= 50;
      }
      if(widget.product.urea){
        score += 5;
      }
      if(widget.product.vitaminC){
        score += 15;
      }
      if(widget.product.aqua){
        score += 5;
      }
    }
    if(user.sensitiveness >= 300) {
      if(widget.product.retinoid){
        score -= 20;
      }
      if(widget.product.citricAcid){
        score -= 5;
      }
      if(widget.product.glycerin){
        score += 15;
      }
      if(widget.product.methyl){
        score -= 50;
      }
      if(widget.product.niacinamide){
        score += 20;
      }
      if(widget.product.parfum){
        score -= 50;
      }
      if(widget.product.urea){
        score += 20;
      }
      if(widget.product.vitaminC){
        score += 5;
      }
      if(widget.product.aqua){
        score += 10;
      }
      if(widget.product.antibacterial){
        score -= 5;
      }
    }
    if(user.oiliness == "Dry") {
      if(widget.product.retinoid){
        score -= 15;
      }
      if(widget.product.citricAcid){
        score -= 5;
      }
      if(widget.product.glycerin){
        score += 15;
      }
      if(widget.product.methyl){
        score -= 50;
      }
      if(widget.product.niacinamide){
        score += 5;
      }
      if(widget.product.parfum){
        score -= 50;
      }
      if(widget.product.urea){
        score += 30;
      }
      if(widget.product.aqua){
        score += 20;
      }
    }
    if(user.oiliness == "Combined") {
      if(widget.product.retinoid){
        score += 10;
      }
      if(widget.product.citricAcid){
        score += 5;
      }
      if(widget.product.glycerin){
        score += 10;
      }
      if(widget.product.methyl){
        score -= 20;
      }
      if(widget.product.urea){
        score -= 5;
      }
      if(widget.product.vitaminC){
        score += 30;
      }
      if(widget.product.aqua){
        score += 30;
      }
    }
    if(user.oiliness == "Oily") {
      if(widget.product.retinoid){
        score += 30;
      }
      if(widget.product.citricAcid){
        score += 20;
      }
      if(widget.product.glycerin){
        score += 10;
      }
      if(widget.product.methyl){
        score += 10;
      }
      if(widget.product.niacinamide){
        score += 0;
      }
      if(widget.product.parfum){
        score -= 20;
      }
      if(widget.product.urea){
        score -= 50;
      }
      if(widget.product.vitaminC){
        score += 10;
      }
      if(widget.product.aqua){
        score += 20;
      }
      if(widget.product.antibacterial){
        score += 30;
      }
    }

    return score.toString();
  }

  double matchingPercent() {
    double score = double.parse(_score());
    if(score < -100.00){
      return 0.02;
    }
    if(score >= -100.00 && score < 0){
      return 0.1;
    }
    if(score >= 0 && score < 50){
      return 0.5;
    }
    if(score >= 50 && score < 100){
      return 0.75;
    }
    else {
      return 0.95;
    }
  }

  String matchingPercentGrade() {
    double score = double.parse(_score());
    if(score < -100.00){
      return "Very Bad";
    }
    if(score >= -100.00 && score < 0){
      return "Bad";
    }
    if(score >= 0 && score < 50){
      return "Okay";
    }
    if(score >= 50 && score < 100){
      return "Good";
    }
    else {
      return "Excellent";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              '${widget.product.productName}',
              style: TextStyle(fontSize: 30),
            ),
            Divider(
              height: 50,
            ),
            Text(
              '${"For the user ${user.name} this product got score of:"}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              '${_score()}',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                strokeWidth: 20,
                backgroundColor: Colors.red.shade100,
                valueColor: AlwaysStoppedAnimation(Colors.red.shade400),
                value: matchingPercent(),
                semanticsLabel: 'Circular progress indicator',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              '${matchingPercentGrade()}',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.product.location.isEmpty ? Text("Not in stock") :
      FloatingActionButton.extended(
        // onPressed: () async {
        //   Navigator.push( context, MaterialPageRoute(builder: (context) => MapSample()));
        //   },
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapSample(productName: widget.product.productName, location: widget.product.location,cameraPosition: widget.product.location),
            ),
          );
        },
        label: const Text('Show on map'),
        icon: const Icon(Icons.map),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }
}