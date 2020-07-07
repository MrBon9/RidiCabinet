import 'package:flutter/material.dart';

import 'hero_test.dart';

class IconHeroTestScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen2'),
      ),
      body: Center(
        child: Hero(
          tag: "testing",
          child: FlutterLogo(
            size: 300.0,
          ),
        ),
      ),
    );
  }
}
