import 'package:flutter/foundation.dart';

class Data {
  @required
  final int id;
  @required
  final String phone_number;
  @required
  final String data_amount;
  @required
  final String date_sent;
  @required
  final String time_sent;

  Data(
      {this.id,
      this.phone_number,
      this.data_amount,
      this.date_sent,
      this.time_sent});

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['phone_number'] = phone_number;
    map['data_amount'] = data_amount;
    map['date_sent'] = date_sent;
    map['time_sent'] = time_sent;

    return map;
  }

  Data.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        phone_number = map['phone_number'],
        data_amount = map['data_amount'],
        date_sent = map['date_sent'],
        time_sent = map['time_sent'];
}
