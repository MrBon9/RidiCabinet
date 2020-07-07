import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:RidiCabinet/src/models/cabinet_list_models.dart';
import 'package:RidiCabinet/src/models/station_data_models.dart';
import 'package:RidiCabinet/src/resources/cabinet_data.dart';
import 'package:RidiCabinet/src/resources/station_data.dart';
import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
// import 'package:my_cabinet_app/src/ui/design/custom_list_item.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:RidiCabinet/src/ui/user/search_button.dart';
import 'package:RidiCabinet/src/ui/component/app_drawer.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:RidiCabinet/src/ui/user/cab_screen.dart';

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

  StationDataModels stationData = new StationDataModels(StationData.storeJson);

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    // this.testLocation();
    //call Android plaftform
    platform.invokeMethod('startSocket');
    // platform.setMethodCallHandler(_handleMethod);
    _controller = AnimationController(vsync: this, duration: duration);
  }

  void _sortStationDefault() {
    stationIDList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  }

  void _sortStationRecent() {
    stationIDList = [3, 0, 2, 1, 4, 5, 6, 7, 8, 9, 10, 11];
  }

  void _sortStationNearest() {
    stationIDList = [0, 4, 1, 2, 3, 5, 6, 7, 8, 9, 10, 11];
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
                          thumbnails[index],
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
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return LoadingBouncingGrid.square(
              //         backgroundColor: Colors.lightBlue,
              //         borderColor: Colors.lightBlue,
              //         size: 45.0,
              //         duration: Duration(milliseconds: 2500),
              //       );
              //     });

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
                          // station: stationData.station[index],
                        )),
              );
            },
          ),
        ),
        tag: "cab $index",
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
                    showSearch(context: context, delegate: Searching());
                  },
                  icon: Icon(Icons.search),
                )),
              ],
            ),
            body: Container(
              height: screenHeight * 0.81,
              child: Column(
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
                  Container(
                    width: screenWidth * 0.92,
                    height:
                        !isCollapsed ? screenHeight * 0.5 : screenHeight * 0.60,
                    child: ListView(
                      children: <Widget>[
                        stationContainer(stationIDList[0]),
                        stationContainer(stationIDList[1]),
                        stationContainer(stationIDList[2]),
                        stationContainer(stationIDList[3]),
                        stationContainer(stationIDList[4]),
                        stationContainer(stationIDList[5]),
                        stationContainer(stationIDList[6]),
                        stationContainer(stationIDList[7]),
                        stationContainer(stationIDList[8]),
                        stationContainer(stationIDList[9]),
                        stationContainer(stationIDList[10]),
                        stationContainer(stationIDList[11]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
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
