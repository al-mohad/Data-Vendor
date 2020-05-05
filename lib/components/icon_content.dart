import 'package:datavendor/utils/constants.dart';
import 'package:flutter/material.dart';

class IconContents extends StatelessWidget {
  final String title;
  final IconData icon;
  IconContents({this.title, this.icon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 50.0,
          ),
          SizedBox(height: 15.0),
          Text(title, style: kLabelTextStyle)
        ],
      ),
    );
  }
}
