import 'package:datavendor/helpers/database_helper.dart';
import 'package:datavendor/models/profile_model.dart';
import 'package:datavendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _textEditingController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final db = DatabaseHelper();
  List<Profile> profileData = [];

  update(String new_pin, String id) async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      await db.updateUsername(new_pin, id);
      setupList();
      _textEditingController.clear();
    }
  }

  String username;
  setupList() async {
    var _profileData = await db.fetchProfile();
    setState(() {
      profileData = _profileData;
      username = _profileData[0].username;
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
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('EDIT PROFILE'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  child: Icon(
                    FontAwesomeIcons.userAlt,
                    size: 50,
                    color: kDarkPurple,
                  ),
                ),
              ),
            ),
            Text(
              username,
              style: Theme.of(context).textTheme.headline.copyWith(
                  fontFamily: 'Nunito-Black',
                  fontSize: 35,
                  color: kLightPurple),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Divider(
                color: kDarkPurple,
                thickness: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: TextFormField(
                  controller: _textEditingController,
                  onChanged: (value) => _textEditingController.text,
                  validator: (value) =>
                      value.trim().isEmpty || value.trim().length > 10
                          ? 'Invalid username (10 Characters max)'
                          : null,
                ),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.all(20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                color: kLightPurple,
                onPressed: () =>
                    update(_textEditingController.text, '${profileData[0].id}'),
                child: Text(
                  'UPDATE PROFILE',
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .copyWith(fontFamily: 'Nunito-Bold', fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
