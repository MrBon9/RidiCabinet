import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:RidiCabinet/src/ui/user/auth_cab.dart';
import 'package:RidiCabinet/src/ui/user/user_cabinet.dart';
import 'package:flutter/material.dart';

class AuthStation extends StatefulWidget {
  @override
  _AuthStation createState() => _AuthStation();
}

class _AuthStation extends State<AuthStation> {
  var loc = '\u{1F4CD}';
  var map = '\u{1F5FA}';
  var cabIcon = '\u{1F5C4}';

  Widget _stationContainer(int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
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
                  AuthBox(item: UserInfoData.userStation[index]),
            ),
            // UserCabinetList(item: UserInfoData.userStation[index])),
          );
        },
      ),
      // ),
      // tag: "cab $index",
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: AppDrawer(),
        appBar: AppBar(
          title: new Text("Choose station"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.blue, Colors.teal[100]],
              ),
            ),
          ),
          actions: <Widget>[
            Container(
                padding: EdgeInsets.all(2.0),
                child: IconButton(
                  onPressed: () {
                    print('search');
                  },
                  icon: Icon(Icons.search),
                ))
          ],
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: UserInfoData.userStation.length,
                  itemBuilder: (context, index) {
                    return _stationContainer(index);
                  },
                ),
              ),
            ]),
        bottomNavigationBar: AppBottomNavigationBar());
  }
}
