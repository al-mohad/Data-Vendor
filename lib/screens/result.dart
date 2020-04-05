import 'package:datavendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResultPage extends StatelessWidget {
  final String phoneNumber;
  final String dataAmountSent;
  final String date;
  final String time;
  ResultPage({
    this.phoneNumber,
    this.date,
    this.dataAmountSent,
    this.time,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DATA VENDOR',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  'Data Sent successfully!',
                  style: kResultTextStyle,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff1d1e33),
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10.0),
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Row(
                      children: <Widget>[
                        Text(
                          'RECORD',
                          style: kTitleTextStyle,
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          FontAwesomeIcons.solidStickyNote,
                          size: 35,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  Divider(
                    height: 0,
                    indent: 0,
                    color: Color(0xffeb1555),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        'TO : ',
                        style: kLabelTextStyle,
                      ),
                      Text(
                        '08078433223',
                        style: kTitleTextStyle.copyWith(fontSize: 25.0),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        'AMOUNT : ',
                        style: kLabelTextStyle,
                      ),
                      Text(
                        '11000',
                        style: kTitleTextStyle.copyWith(fontSize: 25.0),
                      ),
                      Text(
                        'MB',
                        style: kLabelTextStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        'Date : ',
                        style: kLabelTextStyle,
                      ),
                      Text(
                        '${DateTime.now().weekday}',
                        style: kTitleTextStyle.copyWith(fontSize: 25.0),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        'Time : ',
                        style: kLabelTextStyle,
                      ),
                      Text(
                        '${TimeOfDay.now()}',
                        style: kTitleTextStyle.copyWith(fontSize: 25.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //ButtomButton()
        ],
      ),
    );
  }
}
