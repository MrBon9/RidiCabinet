import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:toast/toast.dart';

class SettingScreen extends StatelessWidget {
  Widget _buildSubmitBtn(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.green, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(
              minWidth: 0.0,
              maxWidth: 200.0,
              minHeight: 45.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: const Text(
            'Add',
            style: TextStyle(
              fontSize: 22.0,
              fontFamily: 'Roboto-Regular',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onPressed: () {
        Toast.show(
            'Your friend had been added! Check your friend list', context,
            backgroundColor: Colors.blue[400],
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return KeyboardAvoider(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.blue, Colors.teal[100]],
              ),
            ),
          ),
          title: Center(
            child: Text('Settings'),
          ),
        ),
        body: Container(),
        bottomNavigationBar: AppBottomNavigationBar(),
      ),
    );
  }
}
