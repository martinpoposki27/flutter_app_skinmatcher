
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab193004/services/auth.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/list_item.dart';
import 'exams_calendar.dart';
import '../../widgets/nov_element.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'exams_list.dart';

class Home extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {

  final AuthService _auth = AuthService();

  List<ListItem> examList = [];

  // @override
  // void initState() {
  //   examList = [];
  // }

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(context: ct, builder: (_) {
      return GestureDetector(
        onTap: () {},
        child: NovElement(_addNewItemToList),
        behavior: HitTestBehavior.opaque,
      );
    });
  }

  static List<Map> convertListItemsToMap(List<ListItem>? listItems) {
    List<Map> items = [];
    listItems!.forEach((ListItem listItem) {
      Map item = listItem.toMap();
      items.add(item);
    });
    return items;
  }

  void _addNewItemToList(ListItem item) async {

    final String userId = FirebaseAuth.instance.currentUser!.uid;

    Future<List<ListItem>> currentList () async  {
      return await DatabaseService(userId).exams.first;
    }

    examList = await currentList();

    print(examList);
    setState(() {
      examList.add(item);
    });
    await DatabaseService(userId).updateUserData(convertListItemsToMap(examList), " name");
  }

  @override
  Widget build(BuildContext context) {
    
    return StreamProvider<List<ListItem>>.value(
      value: DatabaseService(FirebaseAuth.instance.currentUser!.uid).exams,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Student Planner"),
          actions: <Widget>[
            IconButton(onPressed: () => _addItemFunction(context), icon: Icon(Icons.add)),
            IconButton(onPressed: () async { await _auth.singOut(); },
                icon: Icon(Icons.logout)),
          ],
        ),
         body: Column (
           children:[
             ExamsCalendar(),
             Expanded(child: ExamsList()),
          ]
         ),
      ),
    );
  }
}