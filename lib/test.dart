import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FaIcon(FontAwesomeIcons.facebook),
            FaIcon(FontAwesomeIcons.instagram),
            FaIcon(FontAwesomeIcons.telegram),
            FaIcon(FontAwesomeIcons.twitter),
            FaIcon(FontAwesomeIcons.github),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: IconRow(),
      ),
    );
  }
}
