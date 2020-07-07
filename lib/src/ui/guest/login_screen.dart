import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:RidiCabinet/src/models/station_data_models.dart';
import 'package:RidiCabinet/src/models/user_infor_models.dart';
import 'package:RidiCabinet/src/resources/station_data.dart';
import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:RidiCabinet/src/ui/user/station_location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'package:flutter/services.dart';
import 'package:loading_animations/loading_animations.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key key,
  });
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {});
    passController.addListener(() {});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Widget _buildLoginBtn(String email, String pass) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.blue, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(
              minWidth: 0.0,
              maxWidth: 160.0,
              minHeight: 45.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: const Text(
            'Login',
            style: TextStyle(
              fontSize: 22.0,
              fontFamily: 'Roboto-Regular',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return LoadingBouncingGrid.square(
                backgroundColor: Colors.lightBlue,
                borderColor: Colors.lightBlue,
                size: 45.0,
                duration: Duration(milliseconds: 2500),
              );
            });

        if (email.isEmpty) {
          Toast.show(
            "Enter email!",
            context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          );
          return;
        }
        if (pass.isEmpty) {
          Toast.show("Enter password!", context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER,
              backgroundColor: Colors.blue,
              textColor: Colors.white);
          return;
        }

        Response response = await post(NetworkConnect.api + 'login',
            body: {'email': email, 'password': pass});

        if (response.body.contains('Email not exists') ||
            response.body.contains('Wrong password')) {
          Toast.show(response.body, context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM,

              // timeInSecForIos: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white);
        } else {
          Toast.show("ok", context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM,
              // timeInSecForIos: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white);

          //giai ma neu response.body la json
          var result = json.decode(response.body);

          UserInfoModels data = new UserInfoModels.fromJson(result);
          UserInfoData.id = data.userId;
          UserInfoData.username = data.userName;
          UserInfoData.email = data.userEmail;

          //luu thong tin dang nhap vao SharedPreferences ben flutter
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("id", result['_id']);
          prefs.setString("email", result['email']);
          prefs.setString("username", result['username']);

          Response loadStation = await post(NetworkConnect.api + 'list_station',
              body: {'id_num': UserInfoData.id});

          var stationResult = jsonDecode(loadStation.body);

          // print(stationResult.length);

          StationData.storeJson = stationResult;

          // print(stationResult);

          //Truy cap api voi duong dan load_station de lay thong tram tu co o tu nguoi dung dang so huu
          // Response response1 = await post(UserDetails.api + 'load_station',
          //     body: {'id_num': UserDetails.id});

          // //Giai ma chuoi json response1.body roi luu vao UserDetails.store de dung cho cac class khac
          // var result1 = jsonDecode(response1.body);
          // UserDetails.store = result1;

          //luu thong tin dang nhap vao SharedPreferences ben android studio
          // var platform = const MethodChannel('flutter.native/AndroidPlatform');
          // final String addUserInfo =
          //     await platform.invokeMethod('addUserInfo', {
          //   "id": UserDetails.id,
          //   "username": UserDetails.username,
          //   "email": UserDetails.email
          // });
          // var addUserInfo_result = (addUserInfo);
          // print(addUserInfo_result);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StationLocation()),
          );
        }
      },
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          );
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot your password?',
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Roboto-Regular',
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.blue,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Roboto-Regular',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAppBarForSignin(double size) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: size * 0.08, maxWidth: double.infinity),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.blue, Colors.teal[100]],
        ),
      ),
      child: Center(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 7.0),
            child: Text(
              "Don't have an account?",
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
              'Sign up',
              style: TextStyle(fontSize: 18.0),
            ),
            color: Colors.red[400],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()),
              );
            },
          ),
        ]),
      ),
    );
  }

  // Gradient color of background in Login Screen
  Widget _backgroundColor(double deviceHeight) {
    return Container(
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
    );
  }

  // Show logo of Cabinet to screen
  Widget _buildLogo(double deviceHeight, double deviceWidth) {
    return SafeArea(
      child: Container(
        height: deviceHeight * 0.12,
        width: deviceWidth * 0.30,
        child: Image.asset(
          'images/Logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    String emailTrans = emailController.text;
    String passTrans = passController.text;
    return Scaffold(
      // Use Scaffold for we need bottom appbar
      resizeToAvoidBottomPadding: false,
      body: Stack(
        // Use Stack for Container of Login can stand on background
        children: <Widget>[
          _backgroundColor(deviceHeight),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                _buildLogo(deviceHeight, deviceWidth),
                SizedBox(
                  height: 45.0,
                ),

                // Container Form to Sign in
                Container(
                  height: 400.0,
                  // height: deviceHeight * 0.45,
                  width: deviceWidth * 0.80,
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
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontFamily: 'Roboto-Black',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: deviceWidth * 0.72,
                          child: FlatButton(
                            color: Color(0xFF4267B2),
                            onPressed: () {},
                            child: Row(
                              children: <Widget>[
                                Image(
                                  image: AssetImage(
                                    "images/fb-logo.png",
                                  ),
                                  height: 32.0,
                                  width: 32.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14.0, right: 10.0),
                                  child: Text(
                                    'Continue with Facebook',
                                    style: TextStyle(
                                      // default to the application font-style
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: deviceWidth * 0.72,
                          child: FlatButton(
                            color: Color(0xFF4285F4),
                            onPressed: () {},
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.white,
                                  child: Image(
                                    image: AssetImage(
                                      "images/google-logo.png",
                                    ),
                                    height: 32.0,
                                    width: 32.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14.0, right: 10.0),
                                  child: Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '- OR -',
                          style: TextStyle(
                            fontFamily: 'Roboto-Regular',
                            fontSize: 18.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6.0),
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
                          width: deviceWidth * 0.72,
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto-Regular',
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                              hintText: 'Enter your Email',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Roboto-Regular',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
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
                          width: deviceWidth * 0.72,
                          child: TextField(
                            controller: passController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                            obscureText: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto-Regular',
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              hintText: 'Enter your Password',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Roboto-Regular',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        // _buildRememberMeCheckbox(),
                        _buildLoginBtn(emailTrans, passTrans),
                        _buildForgotPasswordBtn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAppBarForSignin(deviceHeight),
    );
  }
}
