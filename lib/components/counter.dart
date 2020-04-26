import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CounterCard extends StatelessWidget {
  final Widget cardChild;
  final Function onTap;

  const CounterCard({this.cardChild, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: cardChild,
        height: 330.0,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: kLightBlack,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
