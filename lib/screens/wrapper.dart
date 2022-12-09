import 'package:flutter/material.dart';
import 'package:lab193004/model/user.dart';
import 'package:lab193004/screens/authenticate/authenticate.dart';
import 'package:lab193004/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //Firebase.initializeApp();

    final user = Provider.of<CustomUser?>(context);
    print(user);

    if(user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}