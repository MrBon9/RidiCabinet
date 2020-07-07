import 'package:flutter/material.dart';
import 'package:RidiCabinet/src/ui/guest/login_screen.dart';
import 'package:toast/toast.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class SignupScreen extends StatelessWidget {
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
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: SafeArea(
                      child: Container(
                        height: deviceHeight * 0.12,
                        width: deviceWidth * 0.30,
                        child: Image.asset(
                          'images/Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 45.0,
                  ),
                  Container(
                    height: 390.0,
                    width: deviceWidth * 0.80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.12),
                          spreadRadius: 9.0,
                          blurRadius: 5.0,
                        )
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: deviceHeight * 0.01,
                        ),
                        Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 32.0,
                              fontFamily: 'Roboto-Black',
                              fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: InputBorder.none,
                            filled: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: InputBorder.none,
                            filled: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            filled: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          obscureText: true,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Comfirm your password',
                            border: InputBorder.none,
                            filled: true,
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: <Color>[Colors.red, Colors.white],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                  minWidth: 0.0,
                                  maxWidth: 160.0,
                                  minHeight:
                                      45.0), // min sizes for Material buttons
                              alignment: Alignment.center,
                              child: const Text(
                                'Signup',
                                style: TextStyle(fontSize: 22.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Toast.show(
                                'Create account successfully! ^-^', context,
                                backgroundColor: Colors.teal[400],
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          constraints: BoxConstraints(
              maxHeight: deviceHeight * 0.08, maxWidth: double.infinity),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.blue, Colors.teal[100]],
            ),
          ),
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 7.0),
                    child: Text(
                      "You're already a member?",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Roboto-Regular',
                          color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(9.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.white)),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                          fontSize: 18.0, fontFamily: 'Roboto-Regular'),
                    ),
                    color: Colors.blue[400],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
