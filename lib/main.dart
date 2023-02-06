import 'package:flutter/material.dart';
import 'package:lab193004/model/user.dart';
import 'package:lab193004/screens/maps/map_view.dart';
import 'package:lab193004/screens/wrapper.dart';
import 'package:lab193004/services/auth.dart';
import 'package:lab193004/widgets/nov_element.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/list_item.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'Lab 3 193004',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Wrapper(),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           print("Something went wrong!!!");
//           return Wrapper();
//         }
//
//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Wrapper();
//         }
//
//         return Wrapper();
//       },
//     );
//   }
// }