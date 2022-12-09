import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab193004/model/list_item.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
import '../../services/database.dart';

class ExamsList extends StatefulWidget {
  const ExamsList({Key? key}) : super(key: key);

  @override
  State<ExamsList> createState() => _ExamsListState();
}

class _ExamsListState extends State<ExamsList> {

  static List<Map> convertListItemsToMap(List<ListItem>? listItems) {
    List<Map> items = [];
    listItems!.forEach((ListItem listItem) {
      Map item = listItem.toMap();
      items.add(item);
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {

    final AuthService _auth = AuthService();

    final examList = Provider.of<List<ListItem>>(context);

    void _deleteListItem(String id) async {
      setState(() {
        examList.removeWhere((element) => element.id == id);
      });
      print(examList);
      await DatabaseService(FirebaseAuth.instance.currentUser!.uid).updateUserData(convertListItemsToMap(examList), " name");
    }

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

    return Center(
      child: examList.isEmpty ? Text("No exams.") :
      ListView.builder(itemBuilder: (ctx, index) {
        return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: ListTile(
              title: Text(examList[index].subject),
              subtitle: Text("Date: " + examList[index].dateTime.day.toString() + "." + examList[index].dateTime.month.toString() + "." + examList[index].dateTime.year.toString() + "     Time: " + examList[index].dateTime.hour.toString() + ":" + examList[index].dateTime.minute.toString()),
              trailing: IconButton(
                  onPressed: () => _deleteListItem(examList[index].id),
                  icon: Icon(Icons.delete)),
            )
        );
      },
        itemCount: examList.length,
      ),
    );
  }
}
