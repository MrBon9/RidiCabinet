import 'dart:convert';

import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:RidiCabinet/src/ui/user/add_friend.dart';
import 'package:RidiCabinet/src/ui/user/cab_screen.dart';
import 'package:RidiCabinet/src/ui/user/setting_screen.dart';
import 'package:RidiCabinet/src/ui/user/station_location.dart';
import 'package:RidiCabinet/src/ui/user/user_cabinet.dart';
import 'package:http/http.dart';

class AppBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    // return BottomAppBar(
    //   shape: CircularNotchedRectangle(),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: <Widget>[],
    //   ),
    //   color: Colors.blueGrey,
    // );
    return Container(
      width: deviceWidth,
      height: deviceHeight * 0.081,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.blue, Colors.teal[100]],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 32.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StationLocation()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_add,
              color: Colors.white,
              size: 32.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFriend()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.dashboard,
              color: Colors.white,
              size: 32.0,
            ),
            onPressed: () async {
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
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 32.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
