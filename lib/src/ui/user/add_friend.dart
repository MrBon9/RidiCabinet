import 'dart:convert';

import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:RidiCabinet/src/ui/user/auth_station.dart';
import 'package:RidiCabinet/src/ui/user/list_auth_station.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:RidiCabinet/src/ui/component/app_bottom_bar.dart';
import 'package:RidiCabinet/src/ui/guest/login_screen.dart';

class Authorize extends StatefulWidget {
  @override
  _ExamplePageState createState() => new _ExamplePageState();
}

class _ExamplePageState extends State<Authorize> {
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List searchData = new List();
  List searchDisplay = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Authorize User');
  List contact_display = new List();
  var previousInput;

  _ExamplePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    _filter.clear();
    this._getAuthUser();
    this._getContactUser();
    super.initState();
  }

  //implement activities when user presses search button
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Authorize User');

        _filter.clear();
      }
    });
  }

  //for searching user
  void _searchUser(search_key) async {
    Response response = await post(NetworkConnect.api + 'list_user',
        body: {'user_id': UserInfoData.id, 'search_data': search_key});
    var result = jsonDecode(response.body);

    if (this.mounted) {
      setState(() {
        searchDisplay = result;
      });
    }
  }

  //list contact of user
  void _getContactUser() async {
    Response response = await post(NetworkConnect.api + 'list_contact',
        body: {'user_id': UserInfoData.id});
    var result = jsonDecode(response.body);

    List temp = new List();
    for (var i = 0; i < result.length; i++) {
      temp.add(result[i]['contact_id']);
    }

    if (this.mounted) {
      setState(() {
        contact_display = temp;
      });
    }
  }

  //list contact of user who owns some boxes from user
  void _getAuthUser() async {
    Response response = await post(NetworkConnect.api + 'list_authorize',
        body: {'id_num': UserInfoData.id});
    var result = jsonDecode(response.body);
    UserInfoData.authObjList = result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: _buildBar(context),
      body: Container(
          child: this._searchIcon.icon == Icons.search
              ? _buildListAuth()
              : _buildListSearch()),
      resizeToAvoidBottomPadding: false,
      // bottomNavigationBar: Naviagationbar(),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.blue, Colors.teal[100]]))),
      actions: <Widget>[
        Container(
            padding: EdgeInsets.all(2.0),
            child: IconButton(
              onPressed: () {
                print('search');
                this._searchPressed();
              },
              icon: (_searchIcon),
            ))
      ],
    );
  }

  Widget _buildListAuth() {
    return ListView.builder(
      itemCount: contact_display.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(contact_display[index]['username'] +
              ' - ' +
              contact_display[index]['email']),
          onTap: () {
            UserInfoData.authToUserID = contact_display[index]['_id'];

            //check the existence of the contact id in list authorize of user
            var check = false;
            for (var i = 0; i < UserInfoData.authObjList.length; i++) {
              if (UserInfoData.authObjList[i]['authorize_id']['_id'] ==
                  contact_display[index]['_id']) {
                check = true;
                break;
              }
            }
            if (check == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ListChoice(item: contact_display[index]),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AuthProcess(item: contact_display[index]),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildListSearch() {
    if (!(_searchText.isEmpty)) {
      if (_searchText != previousInput || previousInput == "") {
        searchDisplay = new List();
        previousInput = _searchText;
        var convert = _searchText.toLowerCase();
        this._searchUser(convert);
      }
    } else {
      searchDisplay.clear();
      previousInput = "";
    }

    return ListView.builder(
      itemCount: searchDisplay.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(searchDisplay[index]['email']),
          onTap: () {
            UserInfoData.authToUserID = searchDisplay[index]['_id'];

            //check the existence of the search id in list authorize of user
            var check = false;
            for (var i = 0; i < UserInfoData.authObjList.length; i++) {
              if (UserInfoData.authObjList[i]['authorize_id']['_id'] ==
                  searchDisplay[index]['_id']) {
                check = true;
                break;
              }
            }
            if (check == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListChoice(item: searchDisplay[index]),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthProcess(item: searchDisplay[index]),
                ),
              );
            }
          },
        );
      },
    );
  }
}

//for the contact_id who doesn't own any boxex from user
class AuthProcess extends StatefulWidget {
  var item;
  AuthProcess({Key key, this.item}) : super(key: key) {}
  @override
  _AuthProcess createState() => _AuthProcess(item: item);
}

class _AuthProcess extends State<AuthProcess> {
  bool checkAuthState = false;
  bool authorize_button = false;
  var item;
  _AuthProcess({Key key, this.item}) {}

  @override
  void initState() {
    this.checkAuth();
    super.initState();
  }

  void checkAuth() async {
    Response response = await post(NetworkConnect.api + 'checkContact',
        body: {'user_id': UserInfoData.id, 'contact_id': item["_id"]});
    var result = jsonDecode(response.body);
    print(result);

    if (!result['message']) {
      setState(() {
        checkAuthState = false;
      });
    } else {
      setState(() {
        checkAuthState = true;
      });
    }

    setState(() {
      authorize_button = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(item['username']),
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
                    authorize_button != false
                        ? RaisedButton(
                            onPressed: () async {
                              if (checkAuthState == false) {
                                Response response1 = await post(
                                    NetworkConnect.api + 'add_a_contact',
                                    body: {
                                      'user_id': UserInfoData.id,
                                      'contact_id': item["_id"]
                                    });
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthStation()),
                              );
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
                              child: const Text('Authorize',
                                  style: TextStyle(fontSize: 20)),
                            ))
                        : Row(),
                    checkAuthState != false
                        ? RaisedButton(
                            onPressed: () async {
                              Response response = await post(
                                  NetworkConnect.api + 'delete_a_contact',
                                  body: {
                                    'user_id': UserInfoData.id,
                                    'contact_id': item["_id"]
                                  });

                              Fluttertoast.showToast(
                                  msg: response.body,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Authorize(),
                                ),
                              );
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
                              child: const Text('Delete contact',
                                  style: TextStyle(fontSize: 20)),
                            ))
                        : Row(),
                  ]))),
      // bottomNavigationBar: Naviagationbar(),
    );
  }
}

//for the contact_id who own some boxex from user
class ListChoice extends StatefulWidget {
  var item;
  ListChoice({Key key, this.item}) : super(key: key) {}
  @override
  _ListChoice createState() => _ListChoice(item: item);
}

class _ListChoice extends State<ListChoice> {
  var auth_username;
  var item;
  _ListChoice({Key key, this.item}) {}
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(item['username']),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListAuthStation(item: item),
                            ),
                          );
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
                          child: const Text('List Boxes',
                              style: TextStyle(fontSize: 20)),
                        )),
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthStation()),
                          );
                        },
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
                          child: const Text('New Box',
                              style: TextStyle(fontSize: 20)),
                        )),
                    RaisedButton(
                        onPressed: () async {
                          Response response = await post(
                              NetworkConnect.api + 'delete_a_contact',
                              body: {
                                'user_id': UserInfoData.id,
                                'contact_id': item["_id"]
                              });

                          Fluttertoast.showToast(
                              msg: response.body,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Authorize(),
                            ),
                          );
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
                          child: const Text('Delete contact',
                              style: TextStyle(fontSize: 20)),
                        )),
                  ]))),
      // bottomNavigationBar: Naviagationbar(),
    );
  }
}
