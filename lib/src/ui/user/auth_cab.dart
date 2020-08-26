import 'package:RidiCabinet/src/blocs/cabinet_functions.dart';
import 'package:RidiCabinet/src/models/cabinet_list_models.dart';
import 'package:RidiCabinet/src/resources/cabinet_data.dart';
import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';

class AuthBox extends StatefulWidget {
  var item;
  AuthBox({Key key, this.item}) : super(key: key) {}
  @override
  _AuthBox createState() => _AuthBox(item: item);
}

class _AuthBox extends State<AuthBox> {
  String current_station_location;
  String current_station_no;
  String current_station_id;
  String current_role;
  var item;
  _AuthBox({Key key, this.item}) {
    UserInfoData.userCabinet = new List();
    current_station_location = item["location"];
    current_station_no = item["no"];
    current_station_id = item["_id"];

    for (var i = 0; i < UserInfoData.storeUserCab.length; i++) {
      var inside_store = UserInfoData.storeUserCab[i];
      if (current_station_id == inside_store["station_id"]["_id"] &&
          inside_store['role'] == 'own') {
        var boxJson = {
          "_id": inside_store['box_id']["_id"],
          "no": inside_store["box_id"]["no"],
          "state": inside_store["box_id"]['state'],
          "station_id": inside_store['box_id']['station_id'],
          "role": inside_store['role'],
          "start_time": inside_store['start_time'],
          "end_time": inside_store['end_time'],
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
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Location "
              '${current_station_location}'
              ' - '
              "No "
              '${current_station_no}'),
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
        body: ListView.builder(
          itemCount: UserInfoData.userCabinet.length,
          itemBuilder: (context, index) {
            return new GestureDetector(
              child: new ListTile(
                leading: Container(
                  width: 100.0,
                  height: 100.0,
                  child: _thumbnail(),
                ),
                title: new ListBoxDisplay(
                    cabinet: UserInfoData.userCabinet[index]),
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
                          new Text("Authorize your cabinet"),
                        ],
                      ),
                      content:
                          new Text("Do you want to authorize this cabinet?"),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthBoxProc(
                                      item: UserInfoData.userCabinet[index]),
                                ),
                              );
                            },
                            child: new Text("Auth")),
                        new FlatButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: new Text("Cancel")),
                      ],
                    ));
              },
            );
          },
        ),
        bottomNavigationBar: AppBottomNavigationBar());
  }
}

class AuthBoxProc extends StatefulWidget {
  var item;
  AuthBoxProc({Key key, this.item}) : super(key: key) {}
  @override
  _AuthBoxProc createState() => _AuthBoxProc(item: item);
}

class _AuthBoxProc extends State<AuthBoxProc> {
  var item;
  var box_id;
  var box_no;
  var station_id;
  var role;
  var hello;

  _AuthBoxProc({Key key, this.item}) {
    box_no = item['no'];
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
          padding: EdgeInsets.only(top: 0.0),
          child: Container(
              child: Column(children: <Widget>[
            CheckBox(),
            RaisedButton(
                onPressed: () async {
                  String transfer = _CheckBoxState.limitControler.text;

                  String limit;
                  if (_CheckBoxState.unlimited) {
                    limit = 'unlimited';
                  } else {
                    if (transfer.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Enter number!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                      return;
                    } else
                      limit = int.parse(transfer).toString();
                  }
                  print(limit);
                  Response response =
                      await post(NetworkConnect.api + 'auth_a_box', body: {
                    'authorize_id': UserInfoData.authToUserID,
                    'owner_id': UserInfoData.id,
                    'box_id': item['_id'],
                    'station_id': item['station_id'],
                    'limit': limit,
                    'start_time': item['start_time'],
                    'end_time': item['end_time']
                  });
                  print(response.body);
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
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Accept authorize',
                      style: TextStyle(fontSize: 20)),
                )),
          ])),
        )),
        bottomNavigationBar: AppBottomNavigationBar());
  }
}

class CheckBox extends StatefulWidget {
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  static TextEditingController limitControler = new TextEditingController();
  static bool unlimited = false;
  String result;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                value: unlimited,
                onChanged: (bool value) {
                  setState(() {
                    unlimited = value;
                  });
                },
              ),
              Text("Unlimited"),
            ],
          ),
          unlimited
              ? Container()
              : Padding(
                  padding: EdgeInsets.all(40.0),
                  child: new TextFormField(
                      controller: limitControler,
                      decoration: new InputDecoration(
                          labelText: "Enter number of using"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ]),
                ),
        ],
      ),
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
