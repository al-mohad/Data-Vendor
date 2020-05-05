import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ReusuableCard extends StatelessWidget {
  final Widget cardChild;
  final Function onTap;

  const ReusuableCard({this.cardChild, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: kLightBlack,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
