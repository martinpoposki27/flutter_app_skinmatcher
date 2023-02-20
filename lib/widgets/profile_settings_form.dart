import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab193004/model/user.dart';
import 'package:lab193004/services/database.dart';
import 'package:lab193004/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../model/list_item.dart';
import 'constants.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> oiliness = ['Dry', 'Combined', 'Oily'];

  UserData currentUser = UserData("uid", "Loading...", "Dry", 100, false, false);

  Future<void> _getUserData() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    Future<UserData> currentUserData () async  {
      return await DatabaseService(userId).userData.first;
    }

    UserData userData = await currentUserData();

    currentUserData().then((value) {
      setState(() {
        currentUser = value;
      });
    });
  }

  // form values


  void initState() {
    _getUserData();
    super.initState();
  }

  late String _currentName = currentUser.name;
  late String _currentOiliness = currentUser.oiliness;
  late int _currentSensitiveness = currentUser.sensitiveness;
  late bool _currentAcne = currentUser.acne;
  late bool _currentSpots = currentUser.spots;

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
    //final user = Provider.of<User>(context);
    final String userId = FirebaseAuth.instance.currentUser!.uid;


    return StreamBuilder<UserData>(
      stream: DatabaseService(userId).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData? userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your profile settings.',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData?.name,
                  decoration: InputDecoration(labelText: "Enter your name"),
                  validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  value: _currentOiliness ?? userData?.oiliness,
                  decoration: textInputDecoration,
                  items: oiliness.map((oil) {
                    return DropdownMenuItem(
                      value: oil,
                      child: Text('$oil skin'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentOiliness = val! ),
                ),
                Slider(
                    value: (_currentSensitiveness ?? userData!.sensitiveness).toDouble(),
                    label: "Skin Sensitiveness",
                    min: 100,
                    max: 500,
                    divisions: 4,
                    activeColor: Colors.red[_currentSensitiveness ?? userData!.sensitiveness],
                    //inactiveColor: Colors.red[_currentSensitiveness ?? userData!.sensitiveness],
                    onChanged: (val) => setState(() {
                      _currentSensitiveness = val.round();
                    })
                ),
                SizedBox(height: 10.0),
                SwitchListTile( //switch at right side of label
                    value: _currentAcne,
                    onChanged: (bool state) {
                      setState(() {
                        _currentAcne = state;
                      });
                    },
                    title: Text("Do you have acne?")
                ),
                SizedBox(height: 10.0),
                SwitchListTile( //switch at right side of label
                    value: _currentSpots,
                    onChanged: (bool state) {
                      setState(() {
                        _currentSpots = state;
                      });
                    },
                    title: Text("Do you have spots?")
                ),
                ElevatedButton(
                  //color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){

                        await DatabaseService(userId).updateUserData(
                            _currentName ?? userData!.name,
                            _currentOiliness ?? userData!.oiliness,
                            _currentSensitiveness ?? userData!.sensitiveness,
                            _currentAcne ?? userData!.acne,
                            _currentSpots ?? userData!.spots,
                            //productList
                        );
                        Navigator.pop(context);
                      }
                    }
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}


