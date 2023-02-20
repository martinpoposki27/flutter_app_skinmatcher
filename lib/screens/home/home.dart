
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab193004/model/user.dart';
import 'package:lab193004/screens/maps/map_view.dart';
import 'package:lab193004/services/auth.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/list_item.dart';
import '../../services/notification_service.dart';
import '../../widgets/profile_settings_form.dart';
import 'exams_calendar.dart';
import '../../widgets/nov_element.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'products_list.dart';

class Home extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {

  late final LocalNotificationsService notificationsService;

  final AuthService _auth = AuthService();

  List<ListItem> productList = [];

  @override
  void initState() {
    notificationsService = LocalNotificationsService();
    notificationsService.initialize();
    super.initState();
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
      return await DatabaseService(userId).users.first;
    }

    // Future<UserData> currentUserData () async  {
    //   return await DatabaseService(userId).userData.first;
    // }

    productList = await currentList();
    //UserData userData = await currentUserData();


    print(productList);
    setState(() {
      productList.add(item);
    });
    await DatabaseService(userId).updateUserProducts(
      convertListItemsToMap(productList)
      // userData.name,
      // userData.oiliness,
      // userData.sensitiveness,
      // userData.acne,
      // userData.spots
    );
  }

  @override
  Widget build(BuildContext context) {

    void _showSettingPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: SettingsForm(),
        );
      });
    }
    
    return StreamProvider<List<ListItem>>.value(
      value: DatabaseService(FirebaseAuth.instance.currentUser!.uid).users,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text("SkinMatcher"),
          actions: <Widget>[
            IconButton(onPressed: () => _showSettingPanel(), icon: Icon(Icons.person)),
            // IconButton(
            //     onPressed: () async { Navigator.push( context, MaterialPageRoute(builder: (context) => MapSample(cameraPosition: "Skopje",)));},
            //     icon: Icon(Icons.map)
            // ),
            IconButton(onPressed: () => _addItemFunction(context), icon: Icon(Icons.add)),
            IconButton(onPressed: () async { await _auth.singOut(); },
                icon: Icon(Icons.logout)),
          ],
        ),
         body: Column (
           children:[
             //ExamsCalendar(),
             Expanded(child: ProductsList())
          ]
         ),
      ),
    );
  }
}