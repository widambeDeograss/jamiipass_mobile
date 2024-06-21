import 'package:flutter/material.dart';

class AppSmallText extends StatelessWidget {
  double size = 30;
  final String text;
  final Color color;
  AppSmallText(
      {Key? key,
      this.size = 16,
      required this.text,
      this.color = Colors.black54})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: size,
      ),
    );
  }
}
