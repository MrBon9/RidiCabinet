import 'package:flutter/material.dart';

class EditUserData extends StatefulWidget {
  @override
  _EditUserDataState createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData> {
  double screenWidth, screenHeight;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
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
        title: Text('Update your profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.12),
                spreadRadius: 9.0,
                blurRadius: 5.0,
              )
            ],
            color: Colors.white,
          ),
          width: screenWidth * 0.9,
          height: screenHeight * 0.75,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 160.0,
                    height: 160.0,
                    // color: Colors.blue,
                    child: CircleAvatar(
                      radius: 45.0,
                      backgroundImage: AssetImage("images/Zoe.jpg"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
