import 'package:datavendor/screens/input_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils/constants.dart';

void main() {
  runApp(DataVendor());
}

class DataVendor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: kLightPurple,
        scaffoldBackgroundColor: kDarkBlack,
        iconTheme: IconThemeData(color: kDarkPurple),
        appBarTheme: AppBarTheme(
          color: kLightBlack,
          textTheme: TextTheme(
            headline1: TextStyle(
              fontFamily: 'Nunito-Black',
              fontSize: 25.0,
            ),
          ),
          iconTheme: IconThemeData(color: kDarkPurple),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
              color: kLightGrey, fontFamily: 'Nunito-Regular', fontSize: 20),
          hintStyle: TextStyle(
              color: kLightGrey, fontFamily: 'Nunito-Light', fontSize: 20),
        ),
        textTheme: TextTheme(
          overline: TextStyle(color: kDarkPurple),
          subtitle1: TextStyle(fontFamily: 'Nunito-Bold', fontSize: 18.0),
          bodyText1: TextStyle(
              fontFamily: 'Nunito-Light', fontSize: 18.0, color: kDarkGrey),
        ),
      ),
      home: InputPage(),
    );
  }
}
