import 'package:flutter/material.dart';

class MyTextWidget extends StatelessWidget {
  final text;
  final size;
  final color;
  final fontWeight;
  const MyTextWidget(
      {Key? key, @required this.text, this.size, this.color, this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
        color: color ?? Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
