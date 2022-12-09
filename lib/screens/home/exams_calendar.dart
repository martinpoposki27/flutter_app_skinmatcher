import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/list_item.dart';
import '../../services/database.dart';

class ExamsCalendar extends StatefulWidget {
  const ExamsCalendar({Key? key}) : super(key: key);

  @override
  State<ExamsCalendar> createState() => _ExamsCalendarState();
}

class _ExamsCalendarState extends State<ExamsCalendar> {

  DateTime today = DateTime.now();

  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> _selectedEvents = [];

  static List<Map> convertListItemsToMap(List<ListItem>? listItems) {
    List<Map> items = [];
    listItems!.forEach((ListItem listItem) {
      Map item = listItem.toMap();
      items.add(item);
    });
    return items;
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<ListItem> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(event.dateTime.year, event.dateTime.month, event.dateTime.day, event.dateTime.hour);
      if(data[date] == null) {
        data[date] = [];
      }
      data[date]?.add(event);
    });
    return data;
  }

  List<dynamic> _groupEventsList(List<ListItem> events) {
    List<dynamic> data = [];
    events.forEach((event) {
      DateTime date = DateTime(event.dateTime.year, event.dateTime.month, event.dateTime.day, event.dateTime.hour);
      data.add(date);
    });
    return data;
  }


  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final examList = Provider.of<List<ListItem>>(context) ?? [];

    List<ListItem> groupEventsByDay(DateTime day) {
      List<ListItem> dayEvents = [];
      examList.forEach((exam) {
        //print(exam.dateTime.day.toString() + "   " + day.day.toString());
        if (exam.dateTime.day == day.day) {
          dayEvents.add(exam);
        }
      });
      return dayEvents;
    }

    return TableCalendar<ListItem>(
      eventLoader: (day) {
        return groupEventsByDay(day);
      },
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      selectedDayPredicate: (day) => isSameDay(day, today),
      focusedDay: today,
      rowHeight: 40,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      onDaySelected: _onDaySelected,
    );
  }
}
