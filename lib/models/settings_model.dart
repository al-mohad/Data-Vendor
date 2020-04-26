import 'package:flutter/foundation.dart';

class Settings {
  @required
  final int id;
  @required
  final String isp_name;
  @required
  final String isp_number;
  @required
  final String isp_pin;

  Settings({
    this.id,
    this.isp_name,
    this.isp_number,
    this.isp_pin,
  });

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['phone_number'] = isp_name;
    map['data_amount'] = isp_number;
    map['date_sent'] = isp_pin;

    return map;
  }

  Settings.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        isp_name = map['isp_name'],
        isp_number = map['isp_number'],
        isp_pin = map['isp_pin'];
}
