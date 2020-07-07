import 'dart:async';
import 'package:flutter/material.dart';
import 'package:RidiCabinet/src/ui/user/cab_screen.dart';
import 'package:RidiCabinet/src/ui/user/search_button.dart';
// import 'package:my_cabinet_app/login_screen.dart';
import 'package:RidiCabinet/src/ui/component/app_drawer.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';

class LocationScreen extends StatefulWidget {
  // LocationScreen({
  //   Key key,
  // });
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 500);
  AnimationController _controller;
  // AppBar appBar = AppBar();
  double borderRadius = 0.0;
  List<String> cab_locid = [
    'A4 Automactic Cabinet',
    'A5 Automactic Cabinet',
    'B1 Automactic Cabinet',
    'B4 Automactic Cabinet',
    'Dorm Automactic Cabinet'
  ];
  var loc = '\u{1F4CD}';
  var map = '\u{1F5FA}';
  var cab_icon = '\u{1F5C4}';
  int _navBarIndex = 0;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
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
                    // padding: EdgeInsets.all(2.0),
                    child: IconButton(
                  onPressed: () {
                    print('search');
                    showSearch(context: context, delegate: Searching());
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return Dialog(
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(20.0)),
                    //         child: Container(
                    //           height: 300.0,
                    //           child: Column(
                    //             children: <Widget>[
                    //               Center(
                    //                 child: Text(
                    //                   'Search with',
                    //                   style: TextStyle(fontSize: 30.0),
                    //                 ),
                    //               ),
                    //               RoundedLoadingButton(
                    //                 child: Text('Tap me!',
                    //                     style:
                    //                         TextStyle(color: Colors.white)),
                    //                 controller: _btnController,
                    //                 onPressed: () {
                    //                   Searching();
                    //                 },
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     });
                  },
                  icon: Icon(Icons.search),
                )),
                Container(
                    // padding: EdgeInsets.all(2.0),
                    child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.linked_camera),
                )),
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 60.0,
                      decoration: BoxDecoration(boxShadow: <BoxShadow>[
                        BoxShadow(
                          offset: Offset(1.0, 6.0),
                          color: Colors.white,
                        ),
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            padding: EdgeInsets.only(left: 12.0),
                            onPressed: () {},
                            child: Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {},
                            child: Text(
                              'Recent',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.only(right: 20.0),
                            onPressed: () {},
                            child: Text(
                              'Near you',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ListView(children: <Widget>[]),
                    Container(
                      height: 470.0,
                      child: PageView(
                        controller: PageController(viewportFraction: 0.81),
                        scrollDirection: Axis.vertical,
                        pageSnapping: true,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(9.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 5,
                                )
                              ],
                              color: Colors.blueGrey[50],
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  'images/Cab_images/Cab1.jpg',
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  // leading: ,
                                  title: Text(
                                    '$cab_icon ' +
                                        cab_locid[0] +
                                        '\n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(9.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 5,
                                )
                              ],
                              color: Colors.blueGrey[50],
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                Image.asset('images/Cab_images/Cab5.jpg'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  // leading: ,
                                  title: Text(
                                    '$cab_icon ' +
                                        cab_locid[2] +
                                        '\n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CabinetListScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(9.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 5,
                                )
                              ],
                              color: Colors.blueGrey[50],
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                Image.asset('images/Cab_images/Cab2.jpg'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  // leading: ,
                                  title: Text(
                                    '$cab_icon ' +
                                        cab_locid[0] +
                                        '\n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(9.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 5,
                                )
                              ],
                              color: Colors.blueGrey[50],
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                Image.asset('images/Cab_images/Cab3.jpg'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  // leading: ,
                                  title: Text(
                                    '$cab_icon ' +
                                        cab_locid[2] +
                                        '\n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   margin: const EdgeInsets.symmetric(horizontal: 8),
                          //   color: Colors.green,
                          //   // width: 100.0,
                          // ),
                          Container(
                            color: Colors.grey[300],
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: IconButton(
                              icon: Icon(
                                Icons.add_circle_outline,
                                size: 90.0,
                              ),
                              onPressed: () {
                                print('object');
                              },
                            ),
                            // color: Colors.blueAccent,
                            // width: 100,
                          ),
                          // Container(
                          //   margin: const EdgeInsets.symmetric(horizontal: 8),
                          //   color: Colors.greenAccent,
                          //   width: 100,
                          // ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 45.0),
                    // Container(
                    //   height: 100.0,
                    //   width: 100.0,
                    //   color: Colors.red,
                    // )
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
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   tooltip: 'Increment',
        //   child: Icon(Icons.add),
        //   elevation: 5.0,
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

// Menu reference
// return SafeArea(
//   child: Padding(
//     padding: const EdgeInsets.only(left: 32.0),
//     child: Align(
//       alignment: Alignment.centerLeft,
//       child: FractionallySizedBox(
//         widthFactor: 0.6,
//         heightFactor: 0.8,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               'Menu item 1',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Menu item 2',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Menu item 3',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Menu item 4',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Menu item 5',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//     ),
//   ),
// );

// appBar reference
// appBar: AppBar(
//   title: Text('Location'),
//   leading: IconButton(
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_close,
//         progress: _controller,
//       ),
//       onPressed: () {
//         setState(() {
//           if (isCollapsed) {
//             _controller.forward();

//             borderRadius = 16.0;
//           } else {
//             _controller.reverse();

//             borderRadius = 0.0;
//           }

//           isCollapsed = !isCollapsed;
//         });
//       }),
// ),
// bottomNavigationBar: ClipRRect(
//   borderRadius: BorderRadius.only(
//       topLeft: Radius.circular(16.0),
//       topRight: Radius.circular(16.0),
//       bottomLeft: Radius.circular(borderRadius),
//       bottomRight: Radius.circular(borderRadius)),
//   child: BottomNavigationBar(
//       currentIndex: _navBarIndex,
//       type: BottomNavigationBarType.shifting,
//       onTap: (index) {
//         setState(() {
//           _navBarIndex = index;
//         });
//       },
//       backgroundColor: Theme.of(context).primaryColorDark,
//       // backgroundColor: Colors.red,
//       items: [
//         BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             title: Text(
//               '.',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             )),
//         BottomNavigationBarItem(
//             icon: Icon(Icons.explore),
//             title: Text('.',
//                 style: TextStyle(fontWeight: FontWeight.bold))),
//         BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             title: Text('.',
//                 style: TextStyle(fontWeight: FontWeight.bold))),
//         BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             title: Text('.',
//                 style: TextStyle(fontWeight: FontWeight.bold))),
//       ]),
// ),

// body reference
// body: SingleChildScrollView(
//   scrollDirection: Axis.vertical,
//   physics: ClampingScrollPhysics(),
//   child: Container(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         SizedBox(height: 50),
//         Container(
//           height: 300,
//           child: PageView(
//             controller: PageController(viewportFraction: 0.8),
//             scrollDirection: Axis.horizontal,
//             pageSnapping: true,
//             children: <Widget>[
//               Container(
//                 // height: 500.0,

//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 color: Colors.green,
//                 width: 100,
//                 // child: ,
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 color: Colors.blueAccent,
//                 width: 100,
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 color: Colors.greenAccent,
//                 width: 100,
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 20),
//       ],
//     ),
//   ),
// ),

// Old UI
// List<String> cab_locid = [
//   'A4 Automactic Cabinet',
//   'A5 Automactic Cabinet',
//   'B1 Automactic Cabinet',
//   'B4 Automactic Cabinet',
//   'Dorm Automactic Cabinet'
// ];
// @override
// Widget build(BuildContext context) {
//   double deviceHeight = MediaQuery.of(context).size.height;
//   double deviceWidth = MediaQuery.of(context).size.width;
//   var loc = '\u{1F4CD}';
//   var map = '\u{1F5FA}';
//   var cab_icon = '\u{1F5C4}';
//   return Scaffold(
//     drawer: AppDrawer(),
//     appBar: AppBar(
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: <Color>[Colors.blue, Colors.teal[100]],
//           ),
//         ),
//       ),
//       title: Text('Location of station'),
//       actions: <Widget>[
//         Container(
//           padding: EdgeInsets.all(2.0),
//           child: IconButton(
//             onPressed: () {
//               print('search');
//             },
//             icon: Icon(Icons.search),
//           ),
//         )
//       ],
//     ),
//     body: Center(
//       child: Column(
//         children: <Widget>[
//           SafeArea(
//             // padding: EdgeInsets.fromLTRB(0, 18.0, 0.0, 10.0),
//             child: Text(
//               'Cabinet Stations',
//               style: TextStyle(fontSize: 45.0),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               // height: 600.0,
//               width: deviceWidth * 0.8,
//               child: ListView(
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(10.0, 0.0, 0, 10.0),
//                     child: Container(
//                       height: 100.0,
//                       // width: 310.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent),
//                         borderRadius: BorderRadius.circular(9.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.2),
//                             spreadRadius: 4,
//                             blurRadius: 5,
//                           )
//                         ],
//                         color: Colors.white,
//                       ),
//                       child: ListTile(
//                         // leading: ,
//                         title: Text(
//                           '$cab_icon ' +
//                               cab_locid[0] +
//                               '\n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
//                           style: TextStyle(fontSize: 18.0),
//                         ),
//                         onTap: () {},
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
//                     child: Container(
//                       height: 100.0,
//                       // width: 310.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent),
//                         borderRadius: BorderRadius.circular(9.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.2),
//                             spreadRadius: 4,
//                             blurRadius: 5,
//                           )
//                         ],
//                         color: Colors.white,
//                       ),
//                       child: ListTile(
//                         // leading: ,
//                         title: Text(
//                           '$cab_icon ' +
//                               cab_locid[1] +
//                               '\n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
//                           style: TextStyle(fontSize: 18.0),
//                         ),
//                         onTap: () {},
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
//                     child: Container(
//                       height: 100.0,
//                       // width: 310.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent),
//                         borderRadius: BorderRadius.circular(9.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.2),
//                             spreadRadius: 4,
//                             blurRadius: 5,
//                           )
//                         ],
//                         color: Colors.white,
//                       ),
//                       child: ListTile(
//                         // leading: ,
//                         title: Text(
//                           '$cab_icon ' +
//                               cab_locid[2] +
//                               '\n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
//                           style: TextStyle(fontSize: 18.0),
//                         ),
//                         onTap: () {},
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
//                     child: Container(
//                       height: 100.0,
//                       // width: 310.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent),
//                         borderRadius: BorderRadius.circular(9.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.2),
//                             spreadRadius: 4,
//                             blurRadius: 5,
//                           )
//                         ],
//                         color: Colors.white,
//                       ),
//                       child: ListTile(
//                         // leading: ,
//                         title: Text(
//                           '$cab_icon ' +
//                               cab_locid[3] +
//                               '\n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
//                           style: TextStyle(fontSize: 18.0),
//                         ),
//                         onTap: () {},
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
//                     child: Container(
//                       height: 100.0,
//                       width: 310.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent),
//                         borderRadius: BorderRadius.circular(9.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.2),
//                             spreadRadius: 4,
//                             blurRadius: 5,
//                           )
//                         ],
//                         color: Colors.white,
//                       ),
//                       child: ListTile(
//                         // leading: ,
//                         title: Text(
//                           '$cab_icon ' +
//                               cab_locid[4] +
//                               '\n$loc Di An Town \n$map Binh Duong Province, Viet Nam',
//                           style: TextStyle(fontSize: 18.0),
//                         ),
//                         onTap: () {},
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
//                     child: Container(
//                       height: 100.0,
//                       // width: 310.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent),
//                         borderRadius: BorderRadius.circular(9.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.2),
//                             spreadRadius: 4,
//                             blurRadius: 5,
//                           )
//                         ],
//                         color: Colors.white,
//                       ),
//                       child: ListTile(
//                         // leading: ,
//                         title: Text(
//                           '$cab_icon ' +
//                               cab_locid[4] +
//                               '\n$loc 497 Hoa Hao, District 10 \n$map Ho Chi Minh City, Viet Nam',
//                           style: TextStyle(fontSize: 18.0),
//                         ),
//                         onTap: () {},
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//     bottomNavigationBar: AppBottomNavigationBar(),
//   );
// }
