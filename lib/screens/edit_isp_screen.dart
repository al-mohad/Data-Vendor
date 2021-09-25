import 'dart:async';

import 'package:datavendor/helpers/database_helper.dart';
import 'package:datavendor/models/settings_model.dart';
import 'package:datavendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EditISP extends StatefulWidget {
  final int id;
  EditISP({this.id});
  @override
  _EditISPState createState() => _EditISPState();
}

class _EditISPState extends State<EditISP> {
  TextEditingController _pinTextEditingController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final db = DatabaseHelper();
  List<Settings> settingsData = [];
  String appBarText = 'ISP Settings';
  update() async {
    await db.updateISP(_pinTextEditingController.text, '${widget.id + 1}');
    setState(() {
      appBarText = 'Settings UPDATED !!!';
    });
    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        appBarText = 'ISP Settings';
      });
    });

    print('New Pin is : ${_pinTextEditingController.text}');
    setupList();
    _pinTextEditingController.clear();
  }

  String isp_name;
  String isp_number;
  String isp_pin;
  setupList() async {
    var _settingsData = await db.fetchSettings();
    setState(() {
      settingsData = _settingsData;
      isp_name = _settingsData[widget.id].isp_name;
      isp_number = _settingsData[widget.id].isp_number;
      isp_pin = _settingsData[widget.id].isp_pin;
    });
  }

  @override
  void initState() {
    super.initState();
    setupList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarText,
          style: TextStyle(
              color: appBarText == 'ISP Settings' ? Colors.white : kDarkPurple),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  isp_name,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Form(
                  child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'ISP NUMBER : ',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Container(
                        width: 50,
                        child: Text(
                          settingsData[widget.id].isp_number,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 25, fontFamily: 'Nunito-Black'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Enter New Pin : ',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Container(
                        width: 50,
                        child: TextFormField(
                          onChanged: (value) =>
                              _pinTextEditingController.text = value,
                          initialValue: settingsData[widget.id].isp_pin,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ),
            RaisedButton(
              color: kDarkPurple,
              onPressed: () => update(),
              child: Text(
                'UPDATE',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontFamily: 'Nunito-Regular'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
