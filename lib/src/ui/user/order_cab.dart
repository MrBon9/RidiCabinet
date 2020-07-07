import 'dart:convert';

import 'package:RidiCabinet/src/ui/user/user_cabinet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:RidiCabinet/src/resources/cabinet_data.dart';
import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:RidiCabinet/src/ui/user/user_info_screen.dart';

const activeColour = Color(0xFF4CAF50);
const inactiveColour = Color(0xFF03A9F4);

enum Option { oneHour, oneDay, oneMonth }

class OrderScreen extends StatefulWidget {
  var item;
  OrderScreen({Key key, this.item}) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  double screenWidth, screenHeight;
  Color notSelectedColor = inactiveColour;
  Color selectedColor = activeColour;
  Option selectedOrder;
  String dropdownValue = 'Ridi Coin';
  String holder = '';
  static const platform = const MethodChannel('flutter.native/AndroidPlatform');
  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
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
        title: Center(
          child: Text('Order Cabinet No ${CabinetData.no}'),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Center(
            child: Hero(
              tag: 'to order ${CabinetData.no}',
              transitionOnUserGestures: true,
              child: Material(
                type: MaterialType.transparency, // likely needed
                child: Container(
                  // height: screenHeight * 0.15,
                  // width: screenWidth * 0.85,
                  height: 100.0,
                  width: screenWidth * 0.85,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent[100],
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Container(
                          // height: screenHeight * 0.15,
                          // width: screenWidth * 0.25,
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.lightBlue[300],
                                Colors.blueAccent[700]
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0)),
                          ),
                          child: Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto-Black',
                                fontSize: 50.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Cab No ${CabinetData.no}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Roboto-Black',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Size: S \nL: 25 W: 25 H: 12 (cm) \nMax Weight: 1kg",
                                style: TextStyle(
                                  fontSize: 12.0,
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
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: screenHeight * 0.25,
            width: screenWidth * 0.85,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.lightBlueAccent[100],
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 10.0, 15.0, 0.0),
                      child: Icon(
                        Icons.watch_later,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                      child: Text('Choose your plan',
                          style: TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Container(
                  width: screenWidth * 0.85,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 60.0,
                        width: 100.0,
                        color: selectedOrder == Option.oneHour
                            ? selectedColor
                            : notSelectedColor,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOrder = Option.oneHour;
                            });
                          },
                          child: Center(
                            child: Text(
                              '1 hour\n${CabinetData.priceInOneH}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60.0,
                        width: 100.0,
                        color: selectedOrder == Option.oneDay
                            ? selectedColor
                            : notSelectedColor,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOrder = Option.oneDay;
                            });
                          },
                          child: Center(
                            child: Text(
                              '1 day\n${CabinetData.priceInOneD}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60.0,
                        width: 100.0,
                        color: selectedOrder == Option.oneMonth
                            ? selectedColor
                            : notSelectedColor,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOrder = Option.oneMonth;
                            });
                          },
                          child: Center(
                            child: Text(
                              '1 month\n${CabinetData.priceInOneM}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                // Row(
                //   children: <Widget>[
                //     Padding(
                //       padding: EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 0.0),
                //       child: Text('Checkbox place'),
                //     ),
                //     // Checkbox(
                //     //   onChanged: (bool value) {},
                //     //   value: null,
                //     // )
                //   ],
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: screenHeight * 0.15,
            width: screenWidth * 0.85,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.lightBlueAccent[100],
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 10.0, 15.0, 0.0),
                      child: Icon(
                        Icons.credit_card,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                      child: Text('Payment', style: TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 9.0,
                ),
                Container(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.75,
                  color: Colors.grey[100],
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.lightBlue[800]),
                    underline: Container(
                      height: 2,
                      color: Colors.lightBlue[400],
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Momo', 'Ridi Coin']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  // child: DropdownButton<String>(
                  //   items: <String>['Momo', 'PayPal'].map((String value) {
                  //     return new DropdownMenuItem<String>(
                  //       value: value,
                  //       child: new Text(value),
                  //     );
                  //   }).toList(),
                  //   onChanged: (_) {},
                  // ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            height: screenHeight * 0.055,
            width: screenWidth * 0.85,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),
              padding: EdgeInsets.all(0.0),
              onPressed: () async {
                print(CabinetData.stationNo);
                getDropDownItem();
                String period_kind;
                int amount;

                if (selectedOrder == Option.oneHour) {
                  period_kind = "1";
                  amount = CabinetData.priceInOneH;
                } else if (selectedOrder == Option.oneDay) {
                  period_kind = "2";
                  amount = CabinetData.priceInOneD;
                } else if (selectedOrder == Option.oneMonth) {
                  period_kind = "3";
                  amount = CabinetData.priceInOneM;
                }

                if (holder == 'Momo') {
                  if (period_kind != null) {
                    Response checkOwn =
                        await post(NetworkConnect.api + 'checkOwn', body: {
                      'id_num': UserInfoData.id,
                      'box_id': CabinetData.id,
                      'station_id': CabinetData.stationID,
                    });

                    var checkOwn_result = (checkOwn.body);

                    if (checkOwn_result.contains('0')) {
                      //call Android plaftform
                      final String getMoMoToken =
                          await platform.invokeMethod('getMoMoToken', {
                        "box_no": "${CabinetData.no}",
                        "amount": amount,
                        "period": period_kind,
                        'station_location': CabinetData.stationLoc,
                        'station_address': CabinetData.stationAddress,
                        'station_no': CabinetData.stationNo,
                      });
                      var getMoMoToken_result = json.decode(getMoMoToken);

                      print(getMoMoToken_result);
                      if (getMoMoToken_result["status"] == 0) {
                        Fluttertoast.showToast(
                            msg: "transaction in processing",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white);

                        Response payMoMo =
                            await post(NetworkConnect.api + 'payMoMo', body: {
                          'id_num': UserInfoData.id,
                          'box_id': CabinetData.id,
                          'station_id': CabinetData.stationID,
                          'period_kind': period_kind,
                          'partnerCode': "MOMOTOAE20200418",
                          'customerNumber': getMoMoToken_result["phonenumber"],
                          'token': getMoMoToken_result['data'],
                          'amount': amount.toString(),
                        });
                        var payMoMo_result = json.decode(payMoMo.body);
                        Fluttertoast.showToast(
                            msg: payMoMo_result["message"].toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white);
                        Response response = await post(
                            NetworkConnect.api + 'load_station',
                            body: {'id_num': UserInfoData.id});
                        // print(response.body);

                        var result = jsonDecode(response.body);

                        UserInfoData.storeUserCab = result;

                        // print(result);
                        // UserDetails.store = result;
                        UserInfoData.userStation = new List();
                        for (var i = 0; i < result.length; i++) {
                          var inside_station = result[i]["station_id"];

                          if (UserInfoData.userStation.length == 0)
                            UserInfoData.userStation.add(inside_station);
                          else {
                            bool found = false;
                            for (var j = 0;
                                j < UserInfoData.userStation.length;
                                j++) {
                              String temp = inside_station['_id'];
                              String temp1 = UserInfoData.userStation[j]['_id'];
                              if (temp == temp1) found = true;
                            }
                            if (found == false)
                              UserInfoData.userStation.add(inside_station);
                          }
                        }
                        // print(UserInfoData.userStation.length);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserStation()),
                        );
                      } else if (getMoMoToken_result["status"] == 5) {
                        Fluttertoast.showToast(
                            msg: "Timeout transaction",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white);
                      } else if (getMoMoToken_result["status"] == 6) {
                        Fluttertoast.showToast(
                            msg: "Transaction is canceled",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white);
                      }
                    } else if (checkOwn_result.contains('1')) {
                      Fluttertoast.showToast(
                          msg: "Box is already hired",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                    }
                  }
                } else {
                  if (period_kind != null) {
                    Response checkOwn =
                        await post(NetworkConnect.api + 'checkOwn', body: {
                      'id_num': UserInfoData.id,
                      'box_id': CabinetData.id,
                      'station_id': CabinetData.stationID,
                    });

                    var checkOwn_result = (checkOwn.body);

                    if (checkOwn_result.contains('0')) {
                      Response payDefault =
                          await post(NetworkConnect.api + 'payDefault', body: {
                        'id_num': UserInfoData.id,
                        'box_id': CabinetData.id,
                        'station_id': CabinetData.stationID,
                        'period_kind': period_kind,
                        'amount': amount.toString(),
                      });
                      var payDefault_result = json.decode(payDefault.body);
                      Fluttertoast.showToast(
                          msg: payDefault_result["message"].toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                      Response response = await post(
                          NetworkConnect.api + 'load_station',
                          body: {'id_num': UserInfoData.id});
                      // print(response.body);

                      var result = jsonDecode(response.body);

                      UserInfoData.storeUserCab = result;

                      // print(result);
                      // UserDetails.store = result;
                      UserInfoData.userStation = new List();
                      for (var i = 0; i < result.length; i++) {
                        var inside_station = result[i]["station_id"];

                        if (UserInfoData.userStation.length == 0)
                          UserInfoData.userStation.add(inside_station);
                        else {
                          bool found = false;
                          for (var j = 0;
                              j < UserInfoData.userStation.length;
                              j++) {
                            String temp = inside_station['_id'];
                            String temp1 = UserInfoData.userStation[j]['_id'];
                            if (temp == temp1) found = true;
                          }
                          if (found == false)
                            UserInfoData.userStation.add(inside_station);
                        }
                      }
                      print(CabinetData.stationID);
                      // print(UserInfoData.userStation.length);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserStation()),
                      );
                    } else if (checkOwn_result.contains('1')) {
                      print(CabinetData.stationID);
                      print(CabinetData.stationLoc);
                      Fluttertoast.showToast(
                          msg: "Box is already hired",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                    }
                  }
                }
              },
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.lightBlue, Colors.lightBlueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                child: Center(
                  child: Text(
                    'Order',
                    style: TextStyle(
                      fontFamily: 'Roboto-Black',
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
