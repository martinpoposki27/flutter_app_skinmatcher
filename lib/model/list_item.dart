
import 'package:flutter/foundation.dart';

class ListItem {
  final String id;
  final String productName;
  final String barCode;
  final DateTime dateTime;
  final String location;
  final bool aqua;
  final bool glycerin;
  final bool citricAcid;
  final bool niacinamide;
  final bool parfum;
  final bool urea;
  final bool methyl;
  final bool vitaminC;
  final bool retinoid;
  final bool antibacterial;

  ListItem(@required this.id, @required this.productName, @required this.barCode, @required this.dateTime, this.location,
      this.antibacterial, this.aqua, this.citricAcid, this.glycerin,
      this.methyl, this.niacinamide, this.parfum,
      this.retinoid, this.urea, this.vitaminC);


  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'barCode': barCode,
      'dateTime': dateTime,
      'location': location,
      'antibacterial': antibacterial,
      'aqua': aqua,
      'citricAcid': citricAcid,
      'glycerin': glycerin,
      'methyl': methyl,
      'niacinamide': niacinamide,
      'parfum': parfum,
      'retinoid': retinoid,
      'urea': urea,
      'vitaminC': vitaminC
    };
  }

}