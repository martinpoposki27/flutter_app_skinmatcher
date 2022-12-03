import 'package:flutter/material.dart';
import 'package:lab193004/widgets/nov_element.dart';

import 'model/list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3 193004',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<ListItem> _userItems = [
    ListItem("T0", "Mobile Information Systems", DateTime.now()),
    ListItem("T1", "Management Information Systems", DateTime.now()),
  ];

  void _incrementCounter() {
    setState(() {
    });
  }

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(context: ct, builder: (_) {
      return GestureDetector(
        onTap: () {},
        child: NovElement(_addNewItemToList),
        behavior: HitTestBehavior.opaque,
      );
    });
  }

  void _addNewItemToList(ListItem item) {
    setState(() {
      _userItems.add(item);
    });
  }

  void _deleteListItem(String id) {
    setState(() {
      _userItems.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Time Planner"),
        actions: <Widget>[
          IconButton(onPressed: () => _addItemFunction(context), icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: _userItems.isEmpty ? Text("No exams.") :
        ListView.builder(itemBuilder: (ctx, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: ListTile(
              title: Text(_userItems[index].subject),
              subtitle: Text("Date: " + _userItems[index].dateTime.day.toString() + "." + _userItems[index].dateTime.month.toString() + "." + _userItems[index].dateTime.year.toString() + "     Time: " + _userItems[index].dateTime.hour.toString() + ":" + _userItems[index].dateTime.minute.toString()),
              trailing: IconButton(
                  onPressed: () => _deleteListItem(_userItems[index].id),
                  icon: Icon(Icons.delete)),
            )
          );
        },
        itemCount: _userItems.length,
        ),

        ),
    );
  }
}
