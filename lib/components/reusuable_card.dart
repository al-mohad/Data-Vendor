import 'package:flutter/material.dart';

class ReusuableCard extends StatelessWidget {
  final Color colour;
  final Widget cardChild;
  final Function onTap;
  final int height;

  const ReusuableCard(
      {@required this.colour, this.cardChild, this.onTap, this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height.toDouble(),
        child: cardChild,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
