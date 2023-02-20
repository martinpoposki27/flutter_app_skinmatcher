import 'list_item.dart';

class CustomUser {
  final String uid;
  CustomUser(this.uid);
}

class UserData {
  final String uid;
  final String name;
  final String oiliness;
  final int sensitiveness;
  final bool acne;
  final bool spots;
  //final List<ListItem> products;

  UserData(this.uid, this.name, this.oiliness, this.sensitiveness, this.acne,
      this.spots);
}