import 'dart:async';
import 'dart:convert';

import 'package:RidiCabinet/src/blocs/cabinet_functions.dart';
import 'package:RidiCabinet/src/ui/guest/login_screen.dart';
import 'package:RidiCabinet/src/ui/user/new_search_button.dart';
import 'package:RidiCabinet/src/ui/user/screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:RidiCabinet/src/models/cabinet_list_models.dart';
import 'package:RidiCabinet/src/models/station_data_models.dart';
import 'package:RidiCabinet/src/resources/cabinet_data.dart';
import 'package:RidiCabinet/src/resources/station_data.dart';
import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:RidiCabinet/src/ui/user/search_button.dart';
import 'package:RidiCabinet/src/ui/component/app_drawer.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:RidiCabinet/src/ui/user/cab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StationLocation extends StatefulWidget {
  @override
  _StationLocationState createState() => _StationLocationState();
}

class _StationLocationState extends State<StationLocation>
    with SingleTickerProviderStateMixin {
  static const platform = const MethodChannel('flutter.native/AndroidPlatform');

  double screenWidth, screenHeight;
  bool isCollapsed = true;
  final Duration duration = const Duration(milliseconds: 500);
  AnimationController _controller;
  double borderRadius = 0.0;
  TabController tabController;
  int navBarIndex = 0;
  bool loading = false;

  List<String> thumbnails = [
    'images/Cab_images/Cab1.jpg',
    'images/Cab_images/Cab5.jpg',
    'images/Cab_images/Cab6.jpg',
    'images/Cab_images/Cab2.jpg',
    'images/Cab_images/Cab3.jpg',
    'images/Cab_images/Cab4.jpg',
    'images/Cab_images/Cab7.jpg',
    'images/Cab_images/Cab8.jpg',
    'images/Cab_images/Cab9.jpg',
    'images/Cab_images/Cab10.jpg',
    'images/Cab_images/Cab11.jpg',
    'images/Cab_images/Cab12.jpg',
  ];

  List<int> stationIDList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  StationDataModels stationData = new StationDataModels([]);

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    // this.testLocation();
    //call Android plaftform
    platform.invokeMethod('startSocket');
    platform.setMethodCallHandler(_blockUser);
    this.loadRegisterStation();
    ScreenState.register_station_screen = true;
    ScreenState.authorize_screen = false;
    ScreenState.user_station_screen = false;
    // platform.setMethodCallHandler(_handleMethod);
    _controller = AnimationController(vsync: this, duration: duration);
  }

  Future<dynamic> _blockUser(MethodCall call) async {
    if (call.method == "blockUser") {
      var result = jsonDecode(call.arguments);
      if (result['active'] == "false") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //Remove String
        prefs.remove("id");
        prefs.remove("email");
        prefs.remove("username");

        final String deleteUserInfo =
            await platform.invokeMethod('deleteUserInfo');

        await post(NetworkConnect.api + 'logout',
            body: {'user_id': UserInfoData.id});

        Fluttertoast.showToast(
            msg: "You has been blocked",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);

        print('block user');
      }
    }
  }

  void _sortStationDefault() {
    // stationIDList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    this.loadRegisterStation();
  }

  //new
  void _sortStationRecent() {
    // stationIDList = [3, 0, 2, 1, 4, 5, 6, 7, 8, 9, 10, 11];
  }

  //new
  void _sortStationNearest() async {
    // stationIDList = [0, 4, 1, 2, 3, 5, 6, 7, 8, 9, 10, 11];
    print("near u");
    stationData.station.clear();
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    print(geolocationStatus);
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    if (position != null) {
      Response response =
          await post(NetworkConnect.api + 'list_station_near_user', body: {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      });
      var stationResult = jsonDecode(response.body);

      StationData.storeJson = stationResult;
      print(stationResult);

      setState(() {
        stationData = new StationDataModels(StationData.storeJson);
      });
    }
  }

  void loadRegisterStation() async {
    stationData.station.clear();
    Response loadStation = await post(NetworkConnect.api + 'list_station',
        body: {'id_num': UserInfoData.id});

    var stationResult = jsonDecode(loadStation.body);

    StationData.storeJson = stationResult;
    print("hey");
    print(stationResult);

    setState(() {
      stationData = new StationDataModels(StationData.storeJson);
    });
  }

  Widget menu(context) {
    return AppDrawer();
  }

  Widget stationContainer(int index) {
    stationData.station[index].stationID;
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
      child: Hero(
        transitionOnUserGestures: true,
        child: Material(
          type: MaterialType.transparency, // likely needed
          child: GestureDetector(
            child: Container(
              height: 150.0,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 150.0,
                      width: 150.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0)),
                        child: Image.asset(
                          thumbnails[index % 12],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                          child: Text(
                            'Ridi Cabinet - ${stationData.station[index].stationLocation}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto-Black',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Blank: 3/4 \nFloor ${stationData.station[index].stationNumber}, ${stationData.station[index].stationLocation} \n${stationData.station[index].stationAddress}",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Roboto-Regular',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              Response response = await post(NetworkConnect.api + 'list_box',
                  body: {'station_id': stationData.station[index].stationID});
              var result = jsonDecode(response.body);
              CabinetData.cabJson = result;
              StationData.priceOneHour =
                  stationData.station[index].stationAHourPrice;
              StationData.priceOneDay =
                  stationData.station[index].stationADayPrice;
              StationData.priceOneMonth =
                  stationData.station[index].stationAMonthPrice;
              StationData.stationLoc =
                  stationData.station[index].stationLocation;
              StationData.stationNo = stationData.station[index].stationNumber;
              StationData.stationDetailAddress =
                  stationData.station[index].stationAddressDetail;
              // StationData.stationPic.add(thumbnails[index]);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CabinetListScreen(
                          index: index,
                        )),
              );
            },
          ),
        ),
        tag: "station $index",
      ),
    );
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
                child: Text('Cabinet Location'),
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
                    // showSearch(context: context, delegate: Searching());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewSearchButton(

                              // station: stationData.station[index],
                              )),
                    );
                  },
                  icon: Icon(Icons.search),
                )),
              ],
            ),
            body: Column(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 7.0, // soften the shadow
                        spreadRadius: 0.5, //extend the shadow
                        offset: Offset(
                          1.0, // Move to right 10  horizontally
                          1.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  height: 50.0,
                  width: !isCollapsed ? 0 : double.infinity,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: screenWidth * 0.3,
                        color: Colors.white,
                        child: FlatButton(
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _sortStationDefault();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.033,
                      ),
                      Container(
                        width: screenWidth * 0.3,
                        color: Colors.white,
                        child: FlatButton(
                          child: Text(
                            'Recent',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _sortStationRecent();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.3,
                        color: Colors.white,
                        child: FlatButton(
                          child: Text(
                            'Near you',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _sortStationNearest();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                //new
                Expanded(
                    child: Center(
                  child: Container(
                    width: screenWidth * 0.92,
                    // height:
                    //     !isCollapsed ? screenHeight * 0.5 : screenHeight * 0.70,
                    child: ListView.builder(
                        itemCount: stationData.station.length,
                        itemBuilder: (context, index) {
                          return stationContainer(index);
                        }),
                  ),
                )),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (ScreenState.register_station_screen == true) {
                  String qrResult = await ScreenState.Scann_QR();
                  Response response = await post(
                      NetworkConnect.api + 'query_station_id',
                      body: {'token': qrResult});

                  var result_stationID = json.decode(response.body);

                  if (result_stationID['station_id'] != null) {
                    var check = false;
                    var index;

                    Response loadStation = await post(
                        NetworkConnect.api + 'list_station',
                        body: {'id_num': UserInfoData.id});

                    var stationResult = jsonDecode(loadStation.body);

                    StationData.storeJson = stationResult;

                    stationData = new StationDataModels(StationData.storeJson);

                    for (var i = 0; i < stationData.station.length; i++) {
                      if (stationData.station[i].stationID ==
                          result_stationID['station_id']) {
                        check = true;
                        index = i;
                        break;
                      }
                    }

                    if (check == true) {
                      Response response1 =
                          await post(NetworkConnect.api + 'list_box', body: {
                        'station_id': stationData.station[index].stationID
                      });
                      var result_list_box = jsonDecode(response1.body);
                      CabinetData.cabJson = result_list_box;
                      StationData.priceOneHour =
                          stationData.station[index].stationAHourPrice;
                      StationData.priceOneDay =
                          stationData.station[index].stationADayPrice;
                      StationData.priceOneMonth =
                          stationData.station[index].stationAMonthPrice;
                      StationData.stationLoc =
                          stationData.station[index].stationLocation;
                      StationData.stationNo =
                          stationData.station[index].stationNumber;
                      StationData.stationDetailAddress =
                          stationData.station[index].stationAddressDetail;
                      // StationData.stationPic.add(thumbnails[index]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CabinetListScreen(
                                    index: index,
                                    // station: stationData.station[index],
                                  )));
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
