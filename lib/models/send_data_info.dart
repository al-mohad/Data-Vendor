class SentDataInfo {
  int _id;
  String _phone_number;
  String _data_amount;
  String _date;
  String _time_sent;

  SentDataInfo(
      this._phone_number, this._data_amount, this._date, this._time_sent);
  SentDataInfo.withId(this._id, this._phone_number, this._data_amount,
      this._date, this._time_sent);
  int get id => _id;
  String get phone_number => _phone_number;
  String get data_amount => _data_amount;
  String get date => _date;
  String get time => _time_sent;

  set phone_number(String newPhoneNumber) {
    if (newPhoneNumber.length == 11) {
      this._phone_number = newPhoneNumber;
    }
  }

  set data_amount(String newDataAmount) {
    this.data_amount = newDataAmount;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set time(String newTime) {
    this._time_sent = newTime;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['phone_number'] = _phone_number;
    map['data_amount'] = _data_amount;
    map['date'] = _date;
    map['time_sent'] = _time_sent;
    return map;
  }

  SentDataInfo.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._phone_number = map['phone_number'];
    this._data_amount = map['data_amount'];
    this._date = map['date'];
    this._time_sent = map['time_sent'];
  }
}
