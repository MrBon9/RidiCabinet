import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'dart:math' as math;

class AnimationFirst extends StatefulWidget {
  @override
  _AnimationFirstState createState() => _AnimationFirstState();
}

class _AnimationFirstState extends State<AnimationFirst>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    final curvedAnimation = CurvedAnimation(
        parent: animController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);
    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animController.forward();
            }
          });
    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Transform.rotate(
        angle: animation.value,
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(30.0),
            child: Image.asset('images/Logo.png')),
      ),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}
