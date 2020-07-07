import 'package:flutter/material.dart';

import 'hero_test2.dart';

class IconHeroTestScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Hihi'),
      ),
      body: Hero(
        // height: 300.0,
        // width: 300.0,
        tag: 'testing',
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => IconHeroTestScreen2()));
          },
          child: FlutterLogo(
            size: 100.0,
          ),
        ),
      ),
    );
    // child: Image.asset('images/Cab_images/Cab1.jpg'));
  }
}
