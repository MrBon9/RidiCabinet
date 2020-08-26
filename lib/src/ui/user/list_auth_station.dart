import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:RidiCabinet/src/ui/user/list_auth_cab.dart';
import 'package:RidiCabinet/src/ui/user/user_cabinet.dart';
import 'package:flutter/material.dart';

class ListAuthStation extends StatefulWidget {
  var item;
  ListAuthStation({Key key, this.item}) : super(key: key);
  @override
  _ListAuthStation createState() => _ListAuthStation(item: item);
}

class _ListAuthStation extends State<ListAuthStation> {
  var loc = '\u{1F4CD}';
  var map = '\u{1F5FA}';
  var cabIcon = '\u{1F5C4}';
  String auth_id;
  String auth_username;
  String auth_email;
  List auth_station = new List();
  var item;
  _ListAuthStation({Key key, this.item}) {
    auth_id = item['_id'];
    auth_username = item['username'];
    auth_email = item['email'];
    auth_station = new List();
    for (var i = 0; i < UserInfoData.authObjList.length; i++) {
      if (UserInfoData.authObjList[i]['authorize_id']['_id'] == auth_id) {
        if (auth_station.length == 0) {
          auth_station.add(UserInfoData.authObjList[i]['station_id']);
        } else {
          for (var j = 0; j < auth_station.length; j++) {
            var check = false;
            if (auth_station[j]['_id'] ==
                UserInfoData.authObjList[i]['station_id']['_id']) check = true;
            if (check == false)
              auth_station.add(UserInfoData.authObjList[i]['station_id']);
          }
        }
      }
    }
  }

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
              builder: (context) => ListAuthCabinet(item: auth_station[index]),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(auth_username),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.blue, Colors.teal[100]],
              ),
            ),
          ),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: auth_station.length,
                  itemBuilder: (context, index) {
                    return _stationContainer(index);
                  },
                ),
              ),
            ]),
        bottomNavigationBar: AppBottomNavigationBar());
  }
}
