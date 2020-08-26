import 'dart:convert';

import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/ui/guest/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:RidiCabinet/src/models/user_infor_models.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:RidiCabinet/src/ui/user/user_cabinet.dart';
import 'package:RidiCabinet/src/ui/user/user_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  String u_name = UserInfoData.username;
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    height: 90.0,
                    width: 90.0,
                    child: CircleAvatar(
                      radius: 45.0,
                      backgroundImage: AssetImage("images/Zoe.jpg"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 27, 10, 12),
                  child: Center(
                      child: Text(
                    u_name,
                    style: TextStyle(fontSize: 27, color: Colors.white),
                  )),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlue[400],
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('Account Details'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserInfo()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Your Boxes'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              Response response = await post(
                  NetworkConnect.api + 'load_station',
                  body: {'id_num': UserInfoData.id});
              // print(response.body);

              var result = jsonDecode(response.body);

              UserInfoData.storeUserCab = result;

              // print(result);
              // UserDetails.store = result;
              UserInfoData.userStation = new List();
              for (var i = 0; i < result.length; i++) {
                var inside_station = result[i]["station_id"];

                if (UserInfoData.userStation.length == 0)
                  UserInfoData.userStation.add(inside_station);
                else {
                  bool found = false;
                  for (var j = 0; j < UserInfoData.userStation.length; j++) {
                    String temp = inside_station['_id'];
                    String temp1 = UserInfoData.userStation[j]['_id'];
                    if (temp == temp1) found = true;
                  }
                  if (found == false)
                    UserInfoData.userStation.add(inside_station);
                }
              }
              // print(UserInfoData.userStation.length);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserStation()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement),
            title: Text('Notifications'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('Notificate');
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Friends'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('Friend List');
            },
          ),
          ListTile(
            leading: Icon(Icons.screen_share),
            title: Text('Authorize Your Boxes'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('Authorize');
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 70.0),
            child: Text(
              'SUPPORT',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Hotline: 1900290997'),
            onTap: () {
              launch('tel: 0962299798');
              print('phone');
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('teamKHMT15@gmail.com'),
            onTap: () {
              print('email');
              launch(
                  'mailto:minhduy290997@gmail.com?subject=We need technical support&body=If you need any assistance, please let us know');
            },
          ),
          ListTile(
            title:
                Text('             ABOUT US', style: TextStyle(fontSize: 20.0)),
            onTap: () {
              print('Link to web');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              //Remove String
              prefs.remove("id");
              prefs.remove("email");
              prefs.remove("username");

              var platform =
                  const MethodChannel('flutter.native/AndroidPlatform');
              final String deleteUserInfo =
                  await platform.invokeMethod('deleteUserInfo');
              var deleteUserInfo_result = (deleteUserInfo);
              print(deleteUserInfo_result);

              await post(NetworkConnect.api + 'logout',
                  body: {'user_id': UserInfoData.id});

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false);

              print('logout');
            },
          ),
        ],
      ),
    );
  }
}
