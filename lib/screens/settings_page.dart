import 'package:datavendor/helpers/database_helper.dart';
import 'package:datavendor/models/profile_model.dart';
import 'package:datavendor/models/settings_model.dart';
import 'package:datavendor/screens/edit_isp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'edit_profile_screen.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _textEditingController = TextEditingController();
  final db = DatabaseHelper();
  List<Settings> datas = [];
  List<Profile> profileData = [];
  int count = 0;
  update(String new_pin, String id) async {
    await db.updatePINCODE(new_pin, id);
    setupList();
  }

  setupList() async {
    var _datas = await db.fetchSettings();
    var _profileData = await db.fetchProfile();
    setState(() {
      datas = _datas;
      profileData = _profileData;
      count = _datas.length;
    });
  }

  @override
  void initState() {
    super.initState();
    setupList();
  }

  @override
  Widget build(BuildContext context) {
    setupList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  child: Icon(FontAwesomeIcons.userAlt),
                ),
                title: Text(
                  'Profile',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 30, fontFamily: 'Nunito-Black'),
                ),
                trailing: IconButton(
                  icon: Icon(FontAwesomeIcons.userEdit),
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (ctx) => EditProfileScreen(),
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (ctx) => EditProfileScreen(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: datas.length,
                  itemBuilder: (ctx, index) => Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (ctx) => EditISP(
                                      id: datas[index].id - 1,
                                    ))),
                        leading: CircleAvatar(
                          radius: 35,
                          child: FittedBox(
                              child: Text(
                            '${datas[index].isp_name}',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          )),
                        ),
                        title: Text('PIN CODE : ${datas[index].isp_pin}'),
                        subtitle: Text('ISP NUMBER ${datas[index].isp_number}'),
                        trailing: Icon(FontAwesomeIcons.cog),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
