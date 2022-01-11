import 'package:flutter/material.dart';

class Dividerwidget extends StatelessWidget {
  const Dividerwidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.0,
      color: Colors.black,
      thickness: 1.0,
    );
  }
}
