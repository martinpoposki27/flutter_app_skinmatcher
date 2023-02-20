import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab193004/model/user.dart';
import 'package:lab193004/services/database.dart';

import '../model/list_item.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ListItem> exams = [
     ListItem("T0", "Melem cream", "3856007901409", DateTime.now(), "Super Tinex, Ohrid",
         true, true, true, true, false, false, false, false, true, true),
    ListItem("T1", "Spirulina cream", "5234554456548", DateTime.now(), "Alfa Lab, Skopje",
        true, false, true, false, false, false, false, true, false, true),
  ];

  Future<String?> getUID() async {
    try {
      final User? user = await _auth.currentUser;
      return user?.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  CustomUser? _customUserWrapper (User? user) {
    return user != null ? CustomUser(user.uid) : null;
  }

  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map((User? user) => _customUserWrapper(user));
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _customUserWrapper(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future singOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static List<Map> convertListItemsToMap(List<ListItem>? listItems) {
    List<Map> items = [];
    listItems!.forEach((ListItem listItem) {
      Map item = listItem.toMap();
      items.add(item);
    });
    return items;
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      print(convertListItemsToMap(exams));

      await DatabaseService(user!.uid).updateUserProducts(convertListItemsToMap(exams)
          //, "No name entered", "Dry", 100, false, false
      );

      return _customUserWrapper(user);
    }catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // await DatabaseService(user!.uid).updateUserData(convertListItemsToMap(exams), " nafmdfe");

      return _customUserWrapper(user);
    }catch (e) {
      print(e.toString());
      return null;
    }
  }

}