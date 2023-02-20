import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab193004/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/list_item.dart';
import 'auth.dart';

class DatabaseService {

  final String uid;

  DatabaseService(this.uid);

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("usersCollection");

  static List<Map> convertListItemsToMap(List<ListItem>? listItems) {
    List<Map> items = [];
    listItems!.forEach((ListItem listItem) {
      Map item = listItem.toMap();
      items.add(item);
    });
    return items;
  }

  Future updateUserData(String name, String oiliness, int sensitiveness, bool acne, bool spots) async {

    Future<List<ListItem>> currentList () async  {
      return await this.users.first;
    }

    List<ListItem> productList = await currentList();

    return await usersCollection.doc(uid).set({
      'products': convertListItemsToMap(productList),
      'name': name,
      'oiliness': oiliness,
      'sensitiveness': sensitiveness,
      'acne': acne,
      'spots': spots,
    });
  }

  Future updateUserProducts(List<Map<dynamic, dynamic>> products) async {

    //final String userId = FirebaseAuth.instance.currentUser!.uid;

    Future<UserData> currentUserData () async  {
      return usersCollection.snapshots().map(_userDataFromSnapshot).first;
    }

    UserData userData = await currentUserData();

    return await usersCollection.doc(uid).set({
      'products': products,
      'name': userData.name,
      'oiliness': userData.oiliness,
      'sensitiveness': userData.sensitiveness,
      'acne': userData.acne,
      'spots': userData.spots,
    });
  }

  // 'id': id,
  // 'productName': productName,
  // 'barCode': barCode,
  // 'dateTime': dateTime,
  // 'location': location,
  // 'antibacterial': antibacterial,
  // 'aqua': aqua,
  // 'citricAcid': citricAcid,
  // 'glycerin': glycerin,
  // 'methyl': methyl,
  // 'niacinamide': niacinamide,
  // 'parfum': parfum,
  // 'retinoid': retinoid,
  // 'urea': urea,
  // 'vitaminC': vitaminC

  List<ListItem> _usersFromSnapshot(QuerySnapshot snapshot) {
    List<ListItem> list = [];
    for(var doc in snapshot.docs) {
      if (doc.id == FirebaseAuth.instance.currentUser?.uid) {
        for (var arg in doc.get("products")) {
          ListItem listItem = ListItem(arg["id"], arg["productName"], arg["barCode"],
                                      (arg["dateTime"] as Timestamp).toDate(), arg["location"],
                                      arg["antibacterial"], arg["aqua"], arg["citricAcid"],
                                      arg["glycerin"], arg["methyl"], arg["niacinamide"],
                                      arg["parfum"], arg["retinoid"], arg["urea"], arg["vitaminC"]);
          list.add(listItem);
        }
      }
    }
    return list;
  }

  UserData _userDataFromSnapshot(QuerySnapshot snapshot) {
    List<ListItem> list = [];
    list.add(new ListItem("1", "productName", "barCode", DateTime.now(), "location",
      true, true, true, true, true, true, true, true, true, true));
    UserData userData = new UserData(uid, "(no name entered)", "Dry", 100, false, false);
    for(var doc in snapshot.docs) {
      if (doc.id == FirebaseAuth.instance.currentUser?.uid) {
        userData = new UserData(
            uid,
            doc.get("name"),
            doc.get("oiliness"),
            doc.get("sensitiveness"),
            doc.get("acne"),
            doc.get("spots"));
            //doc.get("products"));
      }
    }
    return userData;
  }

  Future<ListItem> getItemByBarcode(String barCode) async {

    ListItem listItem = ListItem("searching", "No such product found!", "123", DateTime.now(), "Skopje",
        false, false, false, false, false, false, false, false, false, false);

    Future<List<ListItem>> currentList () async  {
      return await this.users.first;
    }
    List<ListItem> productList = await currentList();

    productList.forEach((product) {
      if(product.barCode == barCode) {
        listItem = product;
      }
    });

    return listItem;

  }

  Stream<List<ListItem>> get users {
    return usersCollection.snapshots().map(_usersFromSnapshot);
  }

  Stream<UserData> get userData {
    return usersCollection.snapshots().map(_userDataFromSnapshot);
  }

}