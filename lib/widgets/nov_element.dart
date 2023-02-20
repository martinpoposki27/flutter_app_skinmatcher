import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lab193004/services/notifications_api.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import '../model/list_item.dart';
import 'package:lab193004/services/notifications_api.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class NovElement extends StatefulWidget{

  final Function addItem;

  NovElement(this.addItem);

  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {

  final _formKey = GlobalKey<FormState>();

  //final NotificationAPI notificationService = NotificationAPI();

  @override
  void initState() {
    //notificationService.initialize();
    super.initState();
  }

  String _barCode = "";

  final _subjectController = TextEditingController();
  final _barCodeController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateTimeController = TextEditingController();

  String productName = "";
  DateTime dateTime = DateTime.now();

  bool antibacterial = false;
  bool aqua = false;
  bool glycerin = false;
  bool citricAcid = false;
  bool niacinamide = false;
  bool parfum = false;
  bool urea = false;
  bool methyl = false;
  bool vitaminC = false;
  bool retinoid = false;

  static List<Map> convertListItemsToMap(List<ListItem>? listItems) {
    List<Map> items = [];
    listItems!.forEach((ListItem listItem) {
      Map item = listItem.toMap();
      items.add(item);
    });
    return items;
  }

  void _submitData() async {
    print("SUBMIT DATA!!!");
    setState(() {
    if(_subjectController.text.isEmpty) {
      return;
    }
    final enteredSubject = _subjectController.text;

    if(_barCodeController.text.isEmpty) {
      return;
    }
    final enteredBarCode = _barCodeController.text;

    final enteredLocation = _locationController.text;


    final newItem = ListItem(nanoid(5), enteredSubject, enteredBarCode, dateTime, enteredLocation,
        antibacterial, aqua, citricAcid, glycerin, methyl, niacinamide, parfum, retinoid, urea, vitaminC);
    widget.addItem(newItem);
    Navigator.of(context).pop();
    });
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((value) {
      dateTime = value!;
    });
  }

  void _showTimePicker() {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
    ).then((value) => {
          dateTime = new DateTime(dateTime.year, dateTime.month, dateTime.day, value!.hour, value.minute)
    });
  }

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _barCodeController.text = value));
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        Column( children: <Widget>[
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(labelText: "Product name"),
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(labelText: "Store location"),
            onSubmitted: (_) => _submitData(),
          ),
          Row(
            children: [
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _barCodeController,
                  decoration: InputDecoration(labelText: "Type barcode or scan"),
                  onSubmitted: (_) => _submitData(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.qr_code_scanner),
                onPressed: () {
                  _scan();
                },
              ),
            ],
          ),
          SwitchListTile( //switch at right side of label
              value: antibacterial,
              onChanged: (bool state) {
                setState(() {
                  antibacterial = state;
                  });
                },
              title: Text("Antibacterial")
          ),
          SwitchListTile( //switch at right side of label
              value: aqua,
              onChanged: (bool state) {
                setState(() {
                  aqua = state;
                });
              },
              title: Text("Aqua")
          ),
          SwitchListTile( //switch at right side of label
              value: citricAcid,
              onChanged: (bool state) {
                setState(() {
                  citricAcid = state;
                });
              },
              title: Text("Citric Acid")
          ),
          SwitchListTile( //switch at right side of label
              value: glycerin,
              onChanged: (bool state) {
                setState(() {
                  glycerin = state;
                });
              },
              title: Text("Glycerin")
          ),
          SwitchListTile( //switch at right side of label
              value: methyl,
              onChanged: (bool state) {
                setState(() {
                  methyl = state;
                });
              },
              title: Text("Methyl")
          ),
          SwitchListTile( //switch at right side of label
              value: niacinamide,
              onChanged: (bool state) {
                setState(() {
                  niacinamide = state;
                });
              },
              title: Text("Niacinamide")
          ),
          SwitchListTile( //switch at right side of label
              value: parfum,
              onChanged: (bool state) {
                setState(() {
                  parfum = state;
                });
              },
              title: Text("Parfum")
          ),
          SwitchListTile( //switch at right side of label
              value: retinoid,
              onChanged: (bool state) {
                setState(() {
                  retinoid = state;
                });
              },
              title: Text("Retinoid")
          ),
          SwitchListTile( //switch at right side of label
              value: urea,
              onChanged: (bool state) {
                setState(() {
                  urea = state;
                });
              },
              title: Text("Urea")
          ),
          SwitchListTile( //switch at right side of label
              value: vitaminC,
              onChanged: (bool state) {
                setState(() {
                  vitaminC = state;
                });
              },
              title: Text("Vitamin C")
          ),

          // TextField(
          //   controller: _dateTimeController,
          //   decoration: InputDecoration(labelText: "Choose a date", helperText: "Chosen date: " + dateTime.day.toString() + "." + dateTime.month.toString() + "." + dateTime.year.toString()),
          //   onSubmitted: (_) => _submitData(),
          //   onTap: _showDatePicker,
          // ),
          // TextField(
          //   controller: _dateTimeController,
          //   decoration: InputDecoration(labelText: "Choose a time", helperText: "Chosen time: " + dateTime.hour.toString() + ":" + dateTime.minute.toString()),
          //   onSubmitted: (_) => _submitData(),
          //   onTap: _showTimePicker,
          // ),
          Divider(),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () async {
              //await _submitData;
              setState(() {
                if(_subjectController.text.isEmpty) {
                  return;
                }
                final enteredSubject = _subjectController.text;

                if(_barCodeController.text.isEmpty) {
                  return;
                }
                final enteredBarCode = _barCodeController.text;

                final enteredLocation = _locationController.text;


                final newItem = ListItem(nanoid(5), enteredSubject, enteredBarCode, dateTime, enteredLocation,
                    antibacterial, aqua, citricAcid, glycerin, methyl, niacinamide, parfum, retinoid, urea, vitaminC);
                widget.addItem(newItem);
                Navigator.of(context).pop();
              });
            },
          ),
          // Text(
          //   'If the "Add" button is not working, please use the',
          //   textAlign: TextAlign.center,
          //   overflow: TextOverflow.ellipsis,
          //   style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.deepOrange),
          // ),
          // Text('"Done" button from your keyboard!',
          //   textAlign: TextAlign.center,
          //   overflow: TextOverflow.ellipsis,
          //   style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.deepOrange),
          // ),
        ],
        ),
      ],
    );
  }

}