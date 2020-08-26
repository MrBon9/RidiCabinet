import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListAuthCabinet extends StatefulWidget {
  var item;
  ListAuthCabinet({Key key, this.item}) : super(key: key) {}

  @override
  _ListAuthCabinet createState() => _ListAuthCabinet(item: item);
}

class _ListAuthCabinet extends State<ListAuthCabinet> {
  String station_location;
  String station_no;
  String station_id;
  List auth_box = new List();
  var item;
  _ListAuthCabinet({Key key, this.item}) {
    station_location = item["location"];
    station_no = item["no"];
    station_id = item["_id"];
    auth_box = new List();
    print(UserInfoData.authObjList);
    for (var i = 0; i < UserInfoData.authObjList.length; i++) {
      if (UserInfoData.authObjList[i]['authorize_id']['_id'] ==
              UserInfoData.authToUserID &&
          UserInfoData.authObjList[i]['station_id']['_id'] == station_id) {
        auth_box.add(UserInfoData.authObjList[i]['box_id']);
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Location "
            '${station_location}'
            ' - '
            "No "
            '${station_no}'),
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
                itemCount: auth_box.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: new ListTile(
                      leading: Container(
                        width: 100.0,
                        height: 100.0,
                        child: _thumbnail(),
                      ),
                      title: ListBoxDisplay(
                          cabinet: UserInfoData.userCabinet[index]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Box_auth(item: auth_box[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}

class Box_auth extends StatefulWidget {
  var item;
  Box_auth({Key key, this.item}) : super(key: key);

  @override
  _Box_auth createState() => _Box_auth(item: item);
}

class _Box_auth extends State<Box_auth> {
  var item;
  var box_id;
  var box_no;
  var station_id;

  _Box_auth({Key key, this.item}) {
    box_id = item['_id'];
    box_no = item['no'];
    station_id = item['station_id'];
    print(item);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("No " '${box_no}'),
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
        body: Container(
            child: Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          onPressed: () async {
                            Response response = await post(
                                NetworkConnect.api + 'revoke_a_box',
                                body: {
                                  'authorize_id': UserInfoData.authToUserID,
                                  'owner_id': UserInfoData.id,
                                  'box_id': box_id,
                                  'station_id': station_id,
                                });
                            Fluttertoast.showToast(
                                msg: response.body,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('Revoke',
                                style: TextStyle(fontSize: 20)),
                          )),
                    ]))),
        bottomNavigationBar: AppBottomNavigationBar());
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
