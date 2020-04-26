import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ReusuableCard extends StatelessWidget {
  final Widget cardChild;
  final Function onTap;
  final int height;

  const ReusuableCard({this.cardChild, this.onTap, this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height.toDouble(),
        child: cardChild,
        margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        decoration: BoxDecoration(
          color: kLightBlack,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
