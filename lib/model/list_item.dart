
import 'package:flutter/foundation.dart';

class ListItem {
  final String id;
  final String subject;
  final DateTime dateTime;
  final String location;

  ListItem(@required this.id, @required this.subject, @required this.dateTime, this.location);


  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'dateTime': dateTime,
      'location': location
    };
  }

}