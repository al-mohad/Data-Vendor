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

  update(String new_isp_pin, String id) async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      await db.updateISP(new_isp_pin, id);
      setupList();
      _pinTextEditingController.clear();
    }
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
        title: Text('ISP Settings'),
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
                  style: Theme.of(context).textTheme.headline,
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
                        style: Theme.of(context).textTheme.title,
                      ),
                      Container(
                        width: 50,
                        child: TextFormField(
                          initialValue: settingsData[widget.id].isp_number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'YOUR PIN : ',
                        style: Theme.of(context).textTheme.title,
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
              onPressed: () =>
                  update(_pinTextEditingController.text, widget.id.toString()),
              child: Text(
                'UPDATE',
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontFamily: 'Nunito-Regular'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
