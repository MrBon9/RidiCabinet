import 'dart:async';
import 'dart:convert';
import 'package:RidiCabinet/src/blocs/cabinet_functions.dart';
import 'package:RidiCabinet/src/resources/station_data.dart';
import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:RidiCabinet/src/ui/component/app_drawer.dart';
import 'package:RidiCabinet/src/ui/user/screen_state.dart';
import 'package:RidiCabinet/src/ui/user/search_button.dart';
import 'package:RidiCabinet/src/ui/user/user_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class UserCabinetList extends StatefulWidget {
  var item;
  UserCabinetList({Key key, this.item}) : super(key: key);
  @override
  _UserCabinetListState createState() => _UserCabinetListState(item: item);
}

class _UserCabinetListState extends State<UserCabinetList> {
  String current_station_location;
  String current_station_no;
  String current_station_id;
  String current_role;
  var item;
  _UserCabinetListState({Key key, this.item}) {
    UserInfoData.userCabinet = new List();
    current_station_location = item["location"];
    current_station_no = item["no"];
    current_station_id = item["_id"];

    for (var i = 0; i < UserInfoData.storeUserCab.length; i++) {
      var insideStore = UserInfoData.storeUserCab[i];
      if (current_station_id == insideStore["station_id"]['_id']) {
        var boxJson = {
          "_id": insideStore['box_id']["_id"],
          "no": insideStore["box_id"]["no"],
          "state": insideStore["box_id"]['state'],
          "station_id": insideStore['box_id']['station_id'],
          "role": insideStore['role']
        };
        UserInfoData.userCabinet.add(boxJson);
      }
    }
  }

  Widget _thumbnail() {
    return Container(
      width: 100.0,
      height: 100.0,
      // height: 150.0,
      // width: 150.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.lightBlue[300], Colors.blueAccent[700]],
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Center(
        child: Text(
          'S',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto-Black',
            fontSize: 36.0,
          ),
        ),
      ),
    );
  }

  void openButton(userCabinet) async {
    String qrResult = await CabFunctions.ScannQR();
    var box_id;
    var box_no;
    var station_id;
    var role;

    box_id = userCabinet['_id'];
    box_no = userCabinet['no'];
    station_id = userCabinet['station_id'];
    role = userCabinet['role'];

    print(qrResult);
    if (qrResult != null) {
      Response response = await post(NetworkConnect.api + 'open_box', body: {
        'id_num': UserInfoData.id.toString(),
        'box_id': box_id.toString(),
        'box_no': box_no.toString(),
        'token': qrResult.toString()
      });
      Fluttertoast.showToast(
          msg: response.body,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Your Cabinet in Station ' + current_station_location),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: ListView.builder(
        itemCount: UserInfoData.userCabinet.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            child: new ListTile(
              leading: Container(
                width: 100.0,
                height: 100.0,
                child: _thumbnail(),
              ),
              title:
                  new ListBoxDisplay(cabinet: UserInfoData.userCabinet[index]),
            ),
            onTap: () {
              // print(no);
              // print(role);
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: new CupertinoAlertDialog(
                    title: new Column(
                      children: <Widget>[
                        new Text("Choose your option"),
                        // new Icon(
                        //   Icons.crop_square,
                        //   color: Colors.green,
                        // )
                      ],
                    ),
                    content:
                        new Text("Tap 'Open' if you want to open this cab."),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () async {
                            openButton(UserInfoData.userCabinet[index]);
                            Navigator.of(context).pop();
                          },
                          child: new Text("Open")),
                      new FlatButton(
                        onPressed: () {
                          // print('Sayohyeah');
                          Navigator.of(context).pop();
                        },
                        child: new Text("Cancel"),
                      )
                    ],
                  ));
            },
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}

class ListBoxDisplay extends StatefulWidget {
  var cabinet;
  ListBoxDisplay({Key key, this.cabinet}) : super(key: key);
  @override
  _ListBoxDisplay createState() => _ListBoxDisplay(cabinet: cabinet);
}

class _ListBoxDisplay extends State<ListBoxDisplay> {
  String no;
  String role;
  var cabinet;
  _ListBoxDisplay({Key key, this.cabinet}) {
    no = cabinet['no'].toString();
    role = cabinet['role'];
  }

  Widget build(BuildContext context) {
    return _display();
  }

  Widget _display() {
    if (role == null)
      return Card(
        elevation: 5.0,
        child: new Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.only(top: 25.0, bottom: 30.0),
          child: new Text("Cab No.$no"),
        ),
      );
    if (role == 'own') {
      return Card(
        elevation: 5.0,
        child: new Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.only(top: 25.0, bottom: 30.0),
          child: new Text("Cab No.$no - Owned"),
        ),
      );
    }
    if (role == "auth") {
      return Card(
        elevation: 5.0,
        child: new Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.only(top: 25.0, bottom: 30.0),
          child: new Text("Cab No.$no - Authorized"),
        ),
      );
    }
  }
}

class UserStation extends StatefulWidget {
  // var station;
  UserStation({Key key}) : super(key: key);
  @override
  _UserStationState createState() => _UserStationState();
}

class _UserStationState extends State<UserStation>
    with SingleTickerProviderStateMixin {
  // var station;
  var loc = '\u{1F4CD}';
  var map = '\u{1F5FA}';
  var cabIcon = '\u{1F5C4}';
  // String location;
  // String no;
  // String placename;
  // String address;
  // _UserStationState({Key key, this.station}) {
  //   location = station['location'];
  //   no = station['no'];
  //   placename = station['placename'];
  //   address = station['address'];
  // }
  double screenWidth, screenHeight;
  bool isCollapsed = true;
  AnimationController _controller;
  final Duration duration = const Duration(milliseconds: 500);
  double borderRadius = 0.0;
  TabController tabController;
  int navBarIndex = 0;

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
        elevation: 3,
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
                child: Text('Your Cabinet Location'),
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
              actions: <Widget>[
                Container(
                    child: IconButton(
                  onPressed: () {
                    print('search');
                    showSearch(context: context, delegate: Searching());
                  },
                  icon: Icon(Icons.search),
                )),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Container(
                //   decoration: new BoxDecoration(
                //     color: Colors.white,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey[400],
                //         blurRadius: 7.0, // soften the shadow
                //         spreadRadius: 0.5, //extend the shadow
                //         offset: Offset(
                //           1.0, // Move to right 10  horizontally
                //           1.0, // Move to bottom 10 Vertically
                //         ),
                //       )
                //     ],
                //   ),
                //   height: 50.0,
                //   width: !isCollapsed ? 0 : double.infinity,
                // ),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.92,
                      // height:
                      //     !isCollapsed ? screenHeight * 0.5 : screenHeight * 0.77,
                      child: ListView.builder(
                          // show list station
                          itemCount: UserInfoData.userStation.length,
                          itemBuilder: (context, index) {
                            return _stationContainer(index);
                          }),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (ScreenState.user_station_screen == true) {
                  String qrResult = await ScreenState.Scann_QR();

                  Response response = await post(
                      NetworkConnect.api + 'query_station_id',
                      body: {'token': qrResult});

                  var result_stationID = json.decode(response.body);
                  if (result_stationID['station_id'] != null) {
                    //print(UserDetails.listStation);
                    var check = false;
                    var index;
                    for (var i = 0; i < UserInfoData.userStation.length; i++) {
                      if (UserInfoData.userStation[i]['_id'] ==
                          result_stationID['station_id']) {
                        check = true;
                        index = i;
                        break;
                      }
                    }
                    if (check == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserCabinetList(
                                item: UserInfoData.userStation[index])),
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Not Found",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "error",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white);
                  }
                }
              },
              tooltip: 'Scan QR',
              child: Image.asset(
                'images/QR.png',
                fit: BoxFit.fill,
              ),
              backgroundColor: Colors.lightBlue[800],
              elevation: 2.0,
            ),
            bottomNavigationBar: AppBottomNavigationBar(),
          ),
        ),
      ),
    );
  }

  Widget _stationContainer(int index) {
    // UserInfoData.userStation[index][id];
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
      // child: Hero(
      // transitionOnUserGestures: true,
      // child: Material(
      //   type: MaterialType.transparency, // likely needed
      child: GestureDetector(
        child: Container(
          height: 160.0,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.lightBlueAccent[100],
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(9.0),
            boxShadow: [
              BoxShadow(
                color: Colors.lightBlueAccent[100].withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 5,
              )
            ],
            color: Colors.white,
          ),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     Flexible(
          //       flex: 2,
          //       child: Container(
          //         height: 150.0,
          //         width: 150.0,
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(8.0),
          //               bottomLeft: Radius.circular(8.0)),
          //           child: Image.asset(
          //             StationData.stationPic[index],
          //             fit: BoxFit.fill,
          //           ),
          //         ),
          //       ),
          //     ),
          //     Flexible(
          //       flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Center(
                  child: Text(
                    'Ridi Cabinet - ${UserInfoData.userStation[index]['location']} ',
                    //   location = station['location'];
                    //   no = station['no'];
                    //   placename = station['placename'];
                    //   address = station['address'];
                    // 'Ridi Cabinet - ${stationData.station[index].stationLocation}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Roboto-Black',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  '$cabIcon  ${UserInfoData.userStation[index]['location']} building - No ${UserInfoData.userStation[index]['no']} \n$loc  ${UserInfoData.userStation[index]['placename']} \n$map  ${UserInfoData.userStation[index]['address']}',
                  // 'Haha \nHehe \nSay oh Yeah',
                  // "Blank: 3/4 \nFloor ${floor[index]}, ${stationData.station[index].stationLocation} \n${stationData.station[index].stationAddress}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Roboto-Regular',
                  ),
                ),
              ),
            ],
          ),
        ),
        // ],
        // ),
        // ),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UserCabinetList(item: UserInfoData.userStation[index])),
          );
        },
      ),
      // ),
      // tag: "cab $index",
      // ),
    );
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    ScreenState.register_station_screen = false;
    ScreenState.authorize_screen = false;
    ScreenState.user_station_screen = true;
    _controller = AnimationController(vsync: this, duration: duration);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
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
                bottom: isCollapsed ? 0 : screenHeight * 0.01,
                duration: duration,
                curve: Curves.fastOutSlowIn,
                child: dashboard(context)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        navBarIndex = tabController.index;
      });
    });
    super.dispose();
  }
}
