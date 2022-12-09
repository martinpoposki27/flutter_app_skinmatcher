import 'package:flutter/material.dart';
import 'package:lab193004/services/notifications_api.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import '../model/list_item.dart';
import 'package:lab193004/services/notifications_api.dart';

class NovElement extends StatefulWidget{

  final Function addItem;

  NovElement(this.addItem);

  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {

  final NotificationAPI notificationService = NotificationAPI();

  @override
  void initState() {
    notificationService.initialize();
    super.initState();
  }

  final _subjectController = TextEditingController();
  final _dateTimeController = TextEditingController();

  String subject = "";
  DateTime dateTime = DateTime.now();

  static List<Map> convertListItemsToMap(List<ListItem>? listItems) {
    List<Map> items = [];
    listItems!.forEach((ListItem listItem) {
      Map item = listItem.toMap();
      items.add(item);
    });
    return items;
  }

  void _submitData() {
    if(_subjectController.text.isEmpty) {
      return;
    }
    final enteredSubject = _subjectController.text;
    // final enteredDateTime = DateTime.parse(_dateTimeController.text);
    // print(enteredDateTime);
    final newItem = ListItem(nanoid(5), enteredSubject, dateTime);
    widget.addItem(newItem);
    Navigator.of(context).pop();

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

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(8),
      child: Column( children: [
        TextField(
          controller: _subjectController,
          decoration: InputDecoration(labelText: "Name of the subject"),
          onSubmitted: (_) => _submitData(),
        ),
        TextField(
          controller: _dateTimeController,
          decoration: InputDecoration(labelText: "Choose a date", helperText: "Chosen date: " + dateTime.day.toString() + "." + dateTime.month.toString() + "." + dateTime.year.toString()),
          onSubmitted: (_) => _submitData(),
          onTap: _showDatePicker,
        ),
        TextField(
          controller: _dateTimeController,
          decoration: InputDecoration(labelText: "Choose a time", helperText: "Chosen time: " + dateTime.hour.toString() + ":" + dateTime.minute.toString()),
          onSubmitted: (_) => _submitData(),
          onTap: _showTimePicker,
        ),
        FloatingActionButton(
          onPressed: () async {
            await notificationService.showNotification(
              id: 0,
              title: "Title",
              body: "This event is starting now!"
            );
            _submitData;
          },
          child: Icon(Icons.add),
        )
      ],
      ),
    );
  }

}