import 'dart:io';

import 'package:contact_picker/contact_picker.dart';
import 'package:datavendor/components/counter.dart';
import 'package:datavendor/components/icon_content.dart';
import 'package:datavendor/components/reusuable_card.dart';
import 'package:datavendor/helpers/data_database_helper.dart';
import 'package:datavendor/models/data.dart';
import 'package:datavendor/screens/records_page.dart';
import 'package:datavendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';

enum DataType { MegaBytes, GigaBytes }

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
//  DatabaseHelper _databaseHelper = DatabaseHelper();
  final db = DataHelper();
  Color megaBytesCardColor = kInactiveCardColor;
  Color gigaBytesCardColor = kActiveCardColor;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String dataType;
  bool isMBSelected = false;
  DataType selectedData;
  TextEditingController dataAmountController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  int mbAmount = 100;
  int gbAmount = 1;
  int newID;

  String _today = DateFormat.yMMMd().format(DateTime.now());
  final ContactPicker _contactPicker = ContactPicker();
  //Contact _contact;
  selectContact() async {
    Contact contact = await _contactPicker.selectContact();
    setState(() {
      // _contact = contact;
      phoneNumberController.text = contact.phoneNumber.number.toString();
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
    print('The time is: $_currentTime');
    await db.addRecord(Data(
        phone_number: phoneNumberController.text,
        data_amount: dataAmountController.text,
        date_sent: _today,
        time_sent: _currentTime));
  }

  // String address = phoneNumberController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('DATA VENDOR'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Expanded(
                  child: ReusuableCard(
                    colour: kActiveCardColor,
                    height: 200,
                    cardChild: Text('ID: $newID'),
                  ),
                ),
                Expanded(
                  child: CounterCard(
                    colour: kActiveCardColor,
                    cardChild: Form(
                      key: _formKey,
                      //autovalidate: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (value) =>
                                        value.trim().length < 11 ||
                                                value.isEmpty
                                            ? 'Invalid Phone Number'
                                            : null,
                                    controller: phoneNumberController,
                                    decoration: InputDecoration(
                                        labelText: 'Phone number',
                                        hintText: '08036508999'),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      icon: Icon(FontAwesomeIcons.userAlt),
                                      onPressed: () => selectContact()),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(height: 10.0),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    validator: (value) =>
                                        value.isEmpty || value.length < 3
                                            ? 'Invalid Amount'
                                            : null,
                                    keyboardType: TextInputType.number,
                                    controller: dataAmountController,
                                    decoration: InputDecoration(
                                        labelText: 'Enter Data Amount',
                                        hintText: '100'),
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Expanded(
                                    flex: 1,
                                    child: RaisedButton.icon(
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.swatchbook),
                                        label: Text('Use Slider')))
                              ],
                            ),
                          ),
                          Divider(),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: ReusuableCard(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RecordsPage())),
                                  colour: kActiveCardColor,
                                  cardChild: IconContents(
                                    title: 'Records',
                                    icon: FontAwesomeIcons.history,
                                  ),
                                  height: 70,
                                )),
                                Expanded(
                                    child: ReusuableCard(
                                  onTap: () => exit(0),
                                  height: 70,
                                  colour: kActiveCardColor,
                                  cardChild: IconContents(
                                    title: 'Exit',
                                    icon: FontAwesomeIcons.signOutAlt,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _saveToDatabase(),
            child: Container(
              padding: EdgeInsets.only(bottom: 20.0),
              color: kBottomContainerColour,
              margin: EdgeInsets.only(top: 10.0),
              width: double.infinity,
              height: kBottomContainerHeight,
              child: Center(
                  child: Text(
                'SEND DATA',
                style: kLargeButtonTextStyle,
              )),
            ),
          )
        ],
      ),
    );
  }
}

class IconContent extends StatelessWidget {
  const IconContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          FontAwesomeIcons.star,
          size: 80.0,
        ),
        SizedBox(height: 15.0),
        Text(
          'MEGA BYTES',
          style: TextStyle(fontSize: 18.0, color: Color(0xff8d8e98)),
        )
      ],
    );
  }
}
