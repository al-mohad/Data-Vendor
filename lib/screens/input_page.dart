import 'dart:async';
import 'dart:io';

import 'package:contact_picker/contact_picker.dart';
import 'package:datavendor/components/counter.dart';
import 'package:datavendor/components/icon_content.dart';
import 'package:datavendor/components/reusuable_card.dart';
import 'package:datavendor/helpers/database_helper.dart';
import 'package:datavendor/models/data.dart';
import 'package:datavendor/models/profile_model.dart';
import 'package:datavendor/models/settings_model.dart';
import 'package:datavendor/screens/records_page.dart';
import 'package:datavendor/screens/settings_page.dart';
import 'package:datavendor/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';

import '../utils/constants.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final db = DatabaseHelper();
  Color megaBytesCardColor = kInactiveCardColor;
  Color gigaBytesCardColor = kActiveCardColor;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String dataType;
  String username;
  String vendor = 'VENDOR';

  TextEditingController dataAmountController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  int mbAmount = 100;
  int gbAmount = 1;
  int newID;

  String _today = DateFormat.yMMMd().format(DateTime.now());
  final ContactPicker _contactPicker = ContactPicker();
  Contact _contact;
  _selectContact() async {
    Contact contact = await _contactPicker.selectContact();
    setState(() {
      _contact = contact;
      phoneNumberController.text = contact.phoneNumber.toString();
    });
  }

  SmsSender sender = SmsSender();
  String _address = '131';
  String _pin = '1234';
  SnackBar invalidDataAmountSnackBar = SnackBar(
    content: Text('Error: You can\'t send less than 250MB!!!'),
    duration: Duration(seconds: 5),
    elevation: 2.0,
    behavior: SnackBarBehavior.floating,
  );
  SnackBar dataSentSnacbar = SnackBar(
    content: Text(
      'Data Sent Successfully',
      textAlign: TextAlign.center,
    ),
    duration: Duration(seconds: 2),
    elevation: 2.0,
    behavior: SnackBarBehavior.floating,
  );

  sendSMS() async {
    final form = _formKey.currentState;
    int newDataValue = int.parse(dataAmountController.text);
    if (form.validate()) form.save();
    if (newDataValue >= 250) {
      dataType = 'SMEA';
    } else if (newDataValue >= 500) {
      dataType = 'SMEB';
    } else if (newDataValue >= 1000) {
      dataType = 'SMEC';
    } else if (newDataValue >= 2000) {
      dataType = 'SMED';
    } else if (newDataValue >= 5000) {
      dataType = 'SME';
    } else {
      _scaffoldkey.currentState.showSnackBar(invalidDataAmountSnackBar);
    }

    await sender.sendSms(SmsMessage(_address,
        '$dataType ${phoneNumberController.text.trim()} ${dataAmountController.text} $_pin'));
  }

  _saveToDatabase() async {
    print(phoneNumberController.text);
    String _currentTime = await DateFormat.jms().format(DateTime.now());
    await db.addRecord(
      Data(
          phone_number: phoneNumberController.text,
          data_amount: dataAmountController.text,
          date_sent: _today,
          time_sent: _currentTime),
    );
    setState(() {
      vendor = 'SENT';
    });

    Timer(
        Duration(milliseconds: 1500),
        () => setState(() {
              vendor = 'VENDOR';
            }));
  }

  int _radioGroupValue = 1;
  void handleConfiguration(int value) {
    setState(() {
      _radioGroupValue = value;
    });

    switch (_radioGroupValue) {
      case 1:
        print('Airtle Selected');
        isp_pin = settingsData[0].isp_pin;
        isp_number = settingsData[0].isp_number;
        break;
      case 2:
        print('Etisalat Selected');
        isp_pin = settingsData[1].isp_pin;
        isp_number = settingsData[1].isp_number;
        break;
      case 3:
        print('Glo Selected');
        isp_pin = settingsData[2].isp_pin;
        isp_number = settingsData[2].isp_number;
        break;
      case 4:
        print('MTN Selected');
        isp_pin = settingsData[3].isp_pin;
        isp_number = settingsData[3].isp_number;
        break;
    }
  }

  List<Data> recordsData = [];
  List<Profile> profileData = [];
  List<Settings> settingsData = [];
  String isp_pin;
  String isp_number;
  void loadConfigurations() async {
    var _recordsData = await db.fetchAll();
    var _profileData = await db.fetchProfile();
    var _settingsData = await db.fetchSettings();
    setState(() {
      recordsData = _recordsData;
      profileData = _profileData;
      settingsData = _settingsData;
      username = _profileData[0].username;
      isp_pin = _settingsData[0].isp_pin;
      isp_number = _settingsData[0].isp_number;
    });
  }

  @override
  void initState() {
    super.initState();
    loadConfigurations();
  }

  @override
  Widget build(BuildContext context) {
    loadConfigurations();
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (ctx) => SettingsPage(),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('DATA '),
            Text(
              vendor,
              style: TextStyle(
                  color: vendor == 'VENDOR' ? Colors.white : kLightPurple),
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(vendor == 'VENDOR' ? Icons.info : Icons.check_circle),
              onPressed: () {})
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                ReusuableCard(
                  height: 200,
                  cardChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Text(
                              'Hello $username',
                              style: Theme.of(context).textTheme.headline,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 60,
                            width: 60,
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: kLightPurple,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Icon(
                              FontAwesomeIcons.userAlt,
                              size: 30,
                              color: kDarkBlack,
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Text(
                          'Select Network',
                          style: Theme.of(context).textTheme.body1.copyWith(
                              fontSize: 20, fontFamily: 'Nunito-Bold'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Airtle',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(fontSize: 10),
                            ),
                            Radio(
                                activeColor: kDarkPurple,
                                value: 1,
                                groupValue: _radioGroupValue,
                                onChanged: (d) => handleConfiguration(d)),
                            Text(
                              'Etisalat',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(fontSize: 10),
                            ),
                            Radio(
                                activeColor: kDarkPurple,
                                value: 2,
                                groupValue: _radioGroupValue,
                                onChanged: (d) => handleConfiguration(d)),
                            Text(
                              'GLO',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(fontSize: 10),
                            ),
                            Radio(
                                activeColor: kDarkPurple,
                                value: 3,
                                groupValue: _radioGroupValue,
                                onChanged: (d) => handleConfiguration(d)),
                            Text(
                              'MTN',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(fontSize: 10),
                            ),
                            Radio(
                                activeColor: kDarkPurple,
                                value: 4,
                                groupValue: _radioGroupValue,
                                onChanged: (d) => handleConfiguration(d))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CounterCard(
                  cardChild: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value.trim().length < 11 || value.isEmpty
                                          ? 'Invalid Phone Number'
                                          : null,
                                  controller: phoneNumberController,
                                  decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      hintText: '08036508999'),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.contact_phone,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    _selectContact();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            textBaseline: TextBaseline.alphabetic,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  validator: (value) =>
                                      value.isEmpty || value.length < 3
                                          ? 'Invalid Amount'
                                          : null,
                                  keyboardType: TextInputType.number,
                                  controller: dataAmountController,
                                  decoration: InputDecoration(
                                      labelText: 'Data Amount',
                                      hintText: '100'),
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    'MEGA BYTES',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(
                                            fontFamily: 'Nunito-Bold',
                                            color: kDarkPurple),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ReusuableCard(
                                  onTap: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => RecordsPage(),
                                    ),
                                  ),
                                  cardChild: IconContents(
                                    title: 'Records',
                                    icon: FontAwesomeIcons.history,
                                  ),
                                  height: 70,
                                ),
                              ),
                              Expanded(
                                child: ReusuableCard(
                                  onTap: () => exit(0),
                                  height: 70,
                                  cardChild: IconContents(
                                    title: 'Exit',
                                    icon: FontAwesomeIcons.signOutAlt,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _saveToDatabase(),
            child: Container(
              decoration: BoxDecoration(
                color: kDarkPurple,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              margin: EdgeInsets.only(
                  top: 10.0, bottom: 20.0, left: 15.0, right: 15.0),
              width: double.infinity,
              height: kBottomContainerHeight,
              child: Center(
                child: Text(
                  'SEND DATA',
                  style: Theme.of(context).textTheme.body1.copyWith(
                      fontFamily: 'Nunito-Black',
                      color: Colors.white,
                      fontSize: 30),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
