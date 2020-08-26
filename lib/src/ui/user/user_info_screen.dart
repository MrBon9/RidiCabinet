import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:RidiCabinet/src/blocs/user_blocs.dart';
import 'package:RidiCabinet/src/models/user_infor_models.dart';
import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:RidiCabinet/src/ui/component/app_drawer.dart';
import 'package:date_format/date_format.dart';

import 'edit_user_info.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo>
    with SingleTickerProviderStateMixin {
  String user_name = UserInfoData.username;

  String email = UserInfoData.email;
  String number;
  DateTime birthday;
  int ownedCab = 0;

  double screenWidth, screenHeight;
  bool isCollapsed = true;
  AnimationController _controller;
  double borderRadius = 0.0;
  final Duration duration = const Duration(milliseconds: 500);
  TabController tabController;
  int _navBarIndex = 0;
  String birthdateToShow = '';

// Convert String to Date
  // void convertDateFromString(String strDate) {
  //   DateTime todayDate = DateTime.parse(strDate);
  //   print(todayDate.isUtc);
  //   print(todayDate);
  //   print(formatDate(todayDate, [dd, '/', mm, '/', yyyy]));
  //   birthdateToShow = formatDate(todayDate, [dd, '/', mm, '/', yyyy]);
  //   // , ' ', hh, ':', nn, ':', ss, ' ', am
  // }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);

    this.userState();
    // convertDateFromString(UserInfoData.birthday);
  }

  void userState() async {
    Response response = await post(NetworkConnect.api + 'load_station',
        body: {'id_num': UserInfoData.id});

    var result_cab = jsonDecode(response.body);
    UserInfoData.storeUserCab = result_cab;
    setState(() {
      ownedCab = UserInfoData.storeUserCab.length;
    });

    Response response1 = await post(NetworkConnect.api + 'user_info',
        body: {'user_id': UserInfoData.id});

    var result_user = jsonDecode(response1.body);

    UserInfoModels data = new UserInfoModels.fromJson(result_user);

    setState(() {
      //new
      if (data.userBirth != null)
        UserInfoData.birthday = data.userBirth;
      else
        UserInfoData.birthday = "";

      if (data.userNumber != null)
        UserInfoData.number = data.userNumber;
      else
        UserInfoData.number = "";

      if (data.userSex != null)
        UserInfoData.sex = data.userSex;
      else
        UserInfoData.sex = "";
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        _navBarIndex = tabController.index;
      });
    });
    super.dispose();
  }

  Widget menu(context) {
    return AppDrawer();
  }

  Widget dashboard(context) {
    return Container(
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        type: MaterialType.card,
        animationDuration: duration,
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 8,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
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
                child: Text(user_name + '\'s information'),
              ),
              leading: IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: _controller,
                ),
                onPressed: () {
                  setState(() {
                    if (isCollapsed) {
                      _controller.forward();

                      borderRadius = 16.0;
                    } else {
                      _controller.reverse();

                      borderRadius = 0.0;
                    }

                    isCollapsed = !isCollapsed;
                  });
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
                            backgroundImage: AssetImage("images/island.jpg"),
                          ),
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                        Container(
                          // color: Colors.blue,
                          height: 180.0,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                width: 15.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Your Name:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Sex:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Birthdate:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Your Number:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Email:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Owned Cabinet:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 50.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: 160.0,
                                    child: Text(
                                      UserInfoData.username,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto-Regular',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    width: 160.0,
                                    child: Text(
                                      UserInfoData.sex,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto-Regular',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    width: 160.0,
                                    child: Text(
                                      birthdateToShow,
                                      // formatDate(
                                      //     todayDate, [yyyy, '/', mm, '/', dd]),
                                      // UserInfoData.birthday
                                      //     .format(new DateTime('yMd')),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto-Regular',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    width: 160.0,
                                    child: Text(
                                      UserInfoData.number,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto-Regular',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    width: 160.0,
                                    child: Text(
                                      '$email',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto-Regular',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    width: 160.0,
                                    child: Text(
                                      '${ownedCab} Cabinet(s)',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto-Regular',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: <Color>[
                                          Colors.greenAccent,
                                          Colors.blue
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
                                  ),
                                  child: Container(
                                    width: screenWidth * 0.45,
                                    height: 45.0,
                                    // constraints: const BoxConstraints(
                                    //     minWidth: 0.0,
                                    //     maxWidth: screenWidth * 0.45,
                                    //     minHeight:
                                    //         45.0), // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Edit Information',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'Roboto-Regular',
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  // convertDateFromString(UserInfoData.birthday);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditUserData()),
                                  );
                                },
                              ),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: <Color>[
                                          Colors.orange,
                                          Colors.red
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
                                  ),
                                  child: Container(
                                    width: screenWidth * 0.45,
                                    height: 45.0,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Change Password',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'Roboto-Regular',
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          height: 50.0,
                          width: screenWidth * 0.81,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.12),
                                spreadRadius: 5.0,
                                blurRadius: 5.0,
                              )
                            ],
                          ),
                          child: RaisedButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "Payment Method",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Roboto-Regular',
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 50.0,
                          width: screenWidth * 0.81,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.12),
                                spreadRadius: 5.0,
                                blurRadius: 5.0,
                              )
                            ],
                          ),
                          child: RaisedButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "User History",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Roboto-Regular',
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: AppBottomNavigationBar(),
          ),
        ),
      ),
    );
  }

  // Widget buildScreen(AsyncSnapshot<UserInfoModels> snapshot) {
  //   return Container(
  //     child: Material(
  //       borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
  //       type: MaterialType.card,
  //       animationDuration: duration,
  //       color: Theme.of(context).scaffoldBackgroundColor,
  //       elevation: 8,
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
  //         child: Scaffold(
  //           appBar: AppBar(
  //             flexibleSpace: Container(
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topCenter,
  //                   end: Alignment.bottomCenter,
  //                   colors: <Color>[Colors.blue, Colors.teal[100]],
  //                 ),
  //               ),
  //             ),
  //             title: Center(
  //               child: Text(user_name + '\'s information'),
  //             ),
  //             leading: IconButton(
  //               icon: AnimatedIcon(
  //                 icon: AnimatedIcons.menu_close,
  //                 progress: _controller,
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   if (isCollapsed) {
  //                     _controller.forward();

  //                     borderRadius = 16.0;
  //                   } else {
  //                     _controller.reverse();

  //                     borderRadius = 0.0;
  //                   }

  //                   isCollapsed = !isCollapsed;
  //                 });
  //               },
  //             ),
  //           ),
  //           body: Center(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.12),
  //                     spreadRadius: 9.0,
  //                     blurRadius: 5.0,
  //                   )
  //                 ],
  //                 color: Colors.white,
  //               ),
  //               width: screenWidth * 0.9,
  //               height: screenHeight * 0.75,
  //               child: ListView(
  //                 children: <Widget>[
  //                   Column(
  //                     children: <Widget>[
  //                       SizedBox(
  //                         height: 10.0,
  //                       ),
  //                       Container(
  //                         width: 160.0,
  //                         height: 160.0,
  //                         // color: Colors.blue,
  //                         child: CircleAvatar(
  //                           radius: 45.0,
  //                           backgroundImage: AssetImage("images/Zoe.jpg"),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 18.0,
  //                       ),
  //                       Container(
  //                         // color: Colors.blue,
  //                         height: 180.0,
  //                         child: Row(
  //                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: <Widget>[
  //                             SizedBox(
  //                               width: 15.0,
  //                             ),
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: <Widget>[
  //                                 Text(
  //                                   'Your Name:',
  //                                   style: TextStyle(
  //                                     fontSize: 16.0,
  //                                     fontFamily: 'Roboto-Regular',
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Text(
  //                                   'Sex:',
  //                                   style: TextStyle(
  //                                     fontSize: 16.0,
  //                                     fontFamily: 'Roboto-Regular',
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Text(
  //                                   'Birthdate:',
  //                                   style: TextStyle(
  //                                     fontSize: 16.0,
  //                                     fontFamily: 'Roboto-Regular',
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Text(
  //                                   'Your Number:',
  //                                   style: TextStyle(
  //                                     fontSize: 16.0,
  //                                     fontFamily: 'Roboto-Regular',
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Text(
  //                                   'Email:',
  //                                   style: TextStyle(
  //                                     fontSize: 16.0,
  //                                     fontFamily: 'Roboto-Regular',
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Text(
  //                                   'Owned Cabinet:',
  //                                   style: TextStyle(
  //                                     fontSize: 16.0,
  //                                     fontFamily: 'Roboto-Regular',
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               width: 50.0,
  //                             ),
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.end,
  //                               children: <Widget>[
  //                                 Container(
  //                                   width: 160.0,
  //                                   child: Text(
  //                                     snapshot.data.userName,
  //                                     // 'Pham Minh Duy',
  //                                     style: TextStyle(
  //                                       fontSize: 16.0,
  //                                       fontFamily: 'Roboto-Regular',
  //                                       decoration: TextDecoration.underline,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Container(
  //                                   width: 160.0,
  //                                   child: Text(
  //                                     'Male',
  //                                     style: TextStyle(
  //                                       fontSize: 16.0,
  //                                       fontFamily: 'Roboto-Regular',
  //                                       decoration: TextDecoration.underline,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Container(
  //                                   width: 160.0,
  //                                   child: Text(
  //                                     '29/09/1997',
  //                                     style: TextStyle(
  //                                       fontSize: 16.0,
  //                                       fontFamily: 'Roboto-Regular',
  //                                       decoration: TextDecoration.underline,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Container(
  //                                   width: 160.0,
  //                                   child: Text(
  //                                     '0962299798',
  //                                     style: TextStyle(
  //                                       fontSize: 16.0,
  //                                       fontFamily: 'Roboto-Regular',
  //                                       decoration: TextDecoration.underline,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Container(
  //                                   width: 160.0,
  //                                   child: Text(
  //                                     '1552075@hcmut.edu.vn',
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: TextStyle(
  //                                       fontSize: 16.0,
  //                                       fontFamily: 'Roboto-Regular',
  //                                       decoration: TextDecoration.underline,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                                 Container(
  //                                   width: 160.0,
  //                                   child: Text(
  //                                     '2 Cabinets',
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: TextStyle(
  //                                       fontSize: 16.0,
  //                                       fontFamily: 'Roboto-Regular',
  //                                       decoration: TextDecoration.underline,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10.0,
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         child: Row(
  //                           children: <Widget>[
  //                             RaisedButton(
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(0.0)),
  //                               padding: EdgeInsets.all(0.0),
  //                               child: Ink(
  //                                 decoration: const BoxDecoration(
  //                                   gradient: LinearGradient(
  //                                       colors: <Color>[
  //                                         Colors.greenAccent,
  //                                         Colors.blue
  //                                       ],
  //                                       begin: Alignment.topCenter,
  //                                       end: Alignment.bottomCenter),
  //                                   borderRadius:
  //                                       BorderRadius.all(Radius.circular(0.0)),
  //                                 ),
  //                                 child: Container(
  //                                   width: screenWidth * 0.45,
  //                                   height: 45.0,
  //                                   // constraints: const BoxConstraints(
  //                                   //     minWidth: 0.0,
  //                                   //     maxWidth: screenWidth * 0.45,
  //                                   //     minHeight:
  //                                   //         45.0), // min sizes for Material buttons
  //                                   alignment: Alignment.center,
  //                                   child: const Text(
  //                                     'Edit Information',
  //                                     style: TextStyle(
  //                                       fontSize: 18.0,
  //                                       fontFamily: 'Roboto-Regular',
  //                                       color: Colors.white,
  //                                     ),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 ),
  //                               ),
  //                               onPressed: () {},
  //                             ),
  //                             RaisedButton(
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(0.0)),
  //                               padding: EdgeInsets.all(0.0),
  //                               child: Ink(
  //                                 decoration: const BoxDecoration(
  //                                   gradient: LinearGradient(
  //                                       colors: <Color>[
  //                                         Colors.orange,
  //                                         Colors.red
  //                                       ],
  //                                       begin: Alignment.topCenter,
  //                                       end: Alignment.bottomCenter),
  //                                   borderRadius:
  //                                       BorderRadius.all(Radius.circular(0.0)),
  //                                 ),
  //                                 child: Container(
  //                                   width: screenWidth * 0.45,
  //                                   height: 45.0,
  //                                   alignment: Alignment.center,
  //                                   child: const Text(
  //                                     'Change Password',
  //                                     style: TextStyle(
  //                                       fontSize: 18.0,
  //                                       fontFamily: 'Roboto-Regular',
  //                                       color: Colors.white,
  //                                     ),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 ),
  //                               ),
  //                               onPressed: () {},
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 15.0,
  //                       ),
  //                       Container(
  //                         height: 50.0,
  //                         width: screenWidth * 0.81,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(7.0),
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.grey.withOpacity(0.12),
  //                               spreadRadius: 5.0,
  //                               blurRadius: 5.0,
  //                             )
  //                           ],
  //                         ),
  //                         child: RaisedButton(
  //                           onPressed: () {},
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(3.0)),
  //                           padding: EdgeInsets.all(0.0),
  //                           child: Ink(
  //                             color: Colors.white,
  //                             child: Center(
  //                               child: Text(
  //                                 "Payment Method",
  //                                 style: TextStyle(
  //                                   fontSize: 18.0,
  //                                   fontFamily: 'Roboto-Regular',
  //                                   color: Colors.grey,
  //                                 ),
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 10.0,
  //                       ),
  //                       Container(
  //                         height: 50.0,
  //                         width: screenWidth * 0.81,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(7.0),
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.grey.withOpacity(0.12),
  //                               spreadRadius: 5.0,
  //                               blurRadius: 5.0,
  //                             )
  //                           ],
  //                         ),
  //                         child: RaisedButton(
  //                           onPressed: () {},
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(3.0)),
  //                           padding: EdgeInsets.all(0.0),
  //                           child: Ink(
  //                             color: Colors.white,
  //                             child: Center(
  //                               child: Text(
  //                                 "User History",
  //                                 style: TextStyle(
  //                                   fontSize: 18.0,
  //                                   fontFamily: 'Roboto-Regular',
  //                                   color: Colors.grey,
  //                                 ),
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 10.0,
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           bottomNavigationBar: AppBottomNavigationBar(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // bloc.fetchUserData();
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        if (!isCollapsed) {
          setState(() {
            _controller.reverse();
            borderRadius = 0.0;
            isCollapsed = !isCollapsed;
          });
          return false;
        } else
          return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            menu(context),
            AnimatedPositioned(
                left: isCollapsed ? 0 : 0.65 * screenWidth,
                right: isCollapsed ? 0 : -0.45 * screenWidth,
                top: isCollapsed ? 0 : screenHeight * 0.1,
                bottom: isCollapsed ? 0 : screenHeight * 0.1,
                duration: duration,
                curve: Curves.fastOutSlowIn,
                child: dashboard(context)),
          ],
        ),
      ),
    );
  }
}
