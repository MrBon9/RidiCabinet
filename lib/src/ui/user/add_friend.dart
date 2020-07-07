import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:RidiCabinet/src/ui/guest/login_screen.dart';
import 'package:toast/toast.dart';

class AddFriend extends StatelessWidget {
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
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  maxWidth: double.infinity,
                  minWidth: 0.0,
                  maxHeight: deviceHeight * 0.33333,
                  minHeight: 0.0,
                ),
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [Colors.blue, Colors.teal[100]],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30.0,
                    ),
                    SafeArea(
                      child: Container(
                        height: deviceHeight * 0.12,
                        width: deviceWidth * 0.30,
                        child: Image.asset(
                          'images/Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                    ),
                    Container(
                      width: deviceWidth * 0.9,
                      height: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.12),
                            spreadRadius: 9.0,
                            blurRadius: 5.0,
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                            width: deviceWidth * 0.8,
                            child: Text('Enter your friend number/email',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Roboto-Regular',
                                ),
                                textAlign: TextAlign.left),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 50.0,
                            width: deviceWidth * 0.8,
                            child: TextField(
                              autofocus: true,
                              // keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.perm_contact_calendar,
                                  color: Colors.grey,
                                ),
                                hintText: 'Number/Email',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          _buildSubmitBtn(context),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavigationBar(),
      ),
    );
  }
}
