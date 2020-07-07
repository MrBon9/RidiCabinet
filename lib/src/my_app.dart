import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/ui/user/station_location.dart';
import 'package:RidiCabinet/src/ui/user/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:RidiCabinet/src/ui/guest/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//     // TODO: implement build
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'My Project',
//       home: LoginScreen(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool checker;

  @override
  void initState() {
    super.initState();
    this.userState();
  }

  void userState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool id_state = prefs.containsKey("id");
    setState(() {
      checker = id_state;
    });
    if (id_state == true) {
      UserInfoData.id = prefs.getString('id');
      UserInfoData.email = prefs.getString('email');
      UserInfoData.username = prefs.getString('username');
    }
    print(UserInfoData.id);
    print(UserInfoData.email);

    print(UserInfoData.username);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Project',
      // home: checker == true ? StationLocation() : LoginScreen(),
      home: LoginScreen(),
    );
  }
}
