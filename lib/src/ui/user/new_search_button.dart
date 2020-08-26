import 'dart:convert';

import 'package:RidiCabinet/src/models/station_data_models.dart';
import 'package:RidiCabinet/src/resources/cabinet_data.dart';
import 'package:RidiCabinet/src/resources/station_data.dart';
import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'cab_screen.dart';

class NewSearchButton extends StatefulWidget {
  @override
  _NewSearchButton createState() => _NewSearchButton();
}

class _NewSearchButton extends State<NewSearchButton> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  String previousInput;
  Icon _closeIcon = new Icon(Icons.close);

  StationDataModels stationData;
  List searchDisplay = [];

  Widget _appBarTitle;

  _NewSearchButton() {
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

  void _closePressed() {
    print("hey");
    setState(() {
      _filter.clear();
    });
  }

  @override
  void initState() {
    _filter.clear();
    _appBarTitle = new TextField(
      controller: _filter,
      decoration: new InputDecoration(
          prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
    );
    super.initState();
  }

  @override
  void dispose() {
    _filter.dispose();

    super.dispose();
    print("exit Search");
  }

  void _searchRegStation(search_key) async {
    Response response = await post(
        NetworkConnect.api + 'list_station_search_key',
        body: {'search_data': search_key});
    var stationResult = jsonDecode(response.body);

    if (stationResult.length > 0) {
      StationData.storeJson = stationResult;
      stationData = new StationDataModels(stationResult);
      var temp = [];

      for (var i = 0; i < stationData.station.length; i++) {
        var content = stationData.station[i].stationAddress +
            " - " +
            stationData.station[i].stationLocation +
            " - " +
            "No " +
            stationData.station[i].stationNumber;
        temp.add(content);
      }

      setState(() {
        searchDisplay = temp;
      });
    }
  }

  Widget _buildListSearchReg() {
    if (!(_searchText.isEmpty)) {
      if (_searchText != previousInput || previousInput == "") {
        searchDisplay = new List();
        previousInput = _searchText;
        var convert = _searchText.toLowerCase();
        this._searchRegStation(convert);
      }
    } else {
      searchDisplay.clear();
      previousInput = "";
    }
    return ListView.builder(
      itemCount: searchDisplay.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () async {
          print(searchDisplay[index]);
          Response response = await post(NetworkConnect.api + 'list_box',
              body: {'station_id': stationData.station[index].stationID});
          var result = jsonDecode(response.body);
          CabinetData.cabJson = result;
          StationData.priceOneHour =
              stationData.station[index].stationAHourPrice;
          StationData.priceOneDay = stationData.station[index].stationADayPrice;
          StationData.priceOneMonth =
              stationData.station[index].stationAMonthPrice;
          StationData.stationLoc = stationData.station[index].stationLocation;
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
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
              text: searchDisplay[index].substring(0, _searchText.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: searchDisplay[index].substring(_searchText.length),
                  style: TextStyle(color: Colors.grey),
                ),
              ]),
        ),
        // title: Text(suggestionList[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
        appBar: new AppBar(
          title: _appBarTitle,
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
                    print('close');
                    _closePressed();
                  },
                  icon: (_closeIcon),
                ))
          ],
        ),
        body: _buildListSearchReg());
  }
}
