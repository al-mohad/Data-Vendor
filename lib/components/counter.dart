import 'package:flutter/material.dart';

class CounterCard extends StatelessWidget {
  final Color colour;
  final Widget cardChild;
  final Function onTap;

  const CounterCard({@required this.colour, this.cardChild, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: cardChild,
        height: 330.0,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
