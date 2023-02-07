import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/list_item.dart';
import 'auth.dart';

class DatabaseService {

  final String uid;

  DatabaseService(this.uid);

  final CollectionReference examsCollection = FirebaseFirestore.instance.collection("examsCollection");

  Future updateUserData(List<Map<dynamic, dynamic>> exams, String name) async {
    return await examsCollection.doc(uid).set({
      'exams': exams,
      'name': name,
    });
  }

  // for(var doc in exams!.docs) {
  //  //if doc.id == uid
  //  var categories = (doc.get('exams'));
  //  for(var item in categories) {
  //    print(item["dateTime"]);
  //  }
  // }

  List<ListItem> _examsFromSnapshot(QuerySnapshot snapshot) {
    List<ListItem> list = [];
    for(var doc in snapshot.docs) {
      if (doc.id == FirebaseAuth.instance.currentUser?.uid) {
        for (var arg in doc.get("exams")) {
          ListItem listItem = ListItem(arg["id"], arg["subject"], (arg["dateTime"] as Timestamp).toDate(), arg["location"]);
          list.add(listItem);
        }
      }
    }
    return list;
  }

  Stream<List<ListItem>> get exams {
    return examsCollection.snapshots().map(_examsFromSnapshot);
  }

}