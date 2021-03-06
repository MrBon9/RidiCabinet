import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:RidiCabinet/src/models/cabinet_list_models.dart';
import 'package:RidiCabinet/src/models/station_data_models.dart';
import 'package:RidiCabinet/src/resources/cabinet_data.dart';
import 'package:RidiCabinet/src/resources/station_data.dart';
import 'package:RidiCabinet/src/ui/user/order_cab.dart';
import 'package:RidiCabinet/src/ui/user/station_location.dart';

class CabinetListScreen extends StatelessWidget {
  var stationIndex;
  CabinetListScreen({Key key, index}) {
    stationIndex = index;
  }
//   CabinetListScreen({Key key}) : super(key: key);
//   @override
//   _CabinetListScreenState createState() => _CabinetListScreenState();
// }

// class _CabinetListScreenState extends State<CabinetListScreen> {
  double screenWidth, screenHeight;
  StationDataModels stationData = new StationDataModels(StationData.storeJson);

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

  CabListModels cabList = new CabListModels(CabinetData.cabJson);

  // final images = [
  //   Image.asset('images/ngan.jpg'),
  //   Image.asset('images/Logo.png'),
  //   Image.asset('images/google-logo.png'),
  //   Image.asset('images/bg.png'),
  //   Image.asset('images/shoes.png')
  // ];

  Widget _buiCabContainer(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 6.0),
      child: GestureDetector(
        child: Hero(
          tag: 'to order ${cabList.cabinetList[index].cabNo}',
          child: Material(
            type: MaterialType.transparency, // likely needed
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
                            fontSize: 90.0,
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
                            "Cab No ${cabList.cabinetList[index].cabNo}",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto-Black',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Size: S \nL: 25 W: 25 H: 12 (cm)",
                            style: TextStyle(
                              fontSize: 18.0,
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
        onTap: () async {
          CabinetData.active = cabList.cabinetList[index].cabActive;
          CabinetData.status = cabList.cabinetList[index].cabStatus;
          CabinetData.id = cabList.cabinetList[index].cabID;
          CabinetData.no = cabList.cabinetList[index].cabNo;
          CabinetData.stationID = cabList.cabinetList[index].cabOfStationID;
          // print(cabList.cabinetList[index]);
          CabinetData.priceInOneH =
              stationData.station[stationIndex].stationAHourPrice;
          CabinetData.priceInOneD =
              stationData.station[stationIndex].stationADayPrice;
          CabinetData.priceInOneM =
              stationData.station[stationIndex].stationAMonthPrice;
          CabinetData.stationLoc =
              stationData.station[stationIndex].stationLocation;
          CabinetData.stationAddress =
              stationData.station[stationIndex].stationAddressDetail;
          CabinetData.stationNo =
              stationData.station[stationIndex].stationNumber;

          print(stationData.station[index].stationNumber);
          print(stationData.station[index].stationLocation);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderScreen(item: cabList.cabinetList[index])),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
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
          child: Text('Choose Cabinet in ' +
              stationData.station[stationIndex].stationLocation),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Container(
              width: screenWidth * 0.97,
              height: screenHeight * 0.25,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.lightBlueAccent[100],
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: Hero(
                tag: "station $stationIndex",
                transitionOnUserGestures: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  child: Image.asset(
                    thumbnails[stationIndex],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.5,
            padding: EdgeInsets.only(top: 10.0),
            // color: Colors.blue,
            child: ListView.builder(
              itemCount: CabinetData.cabJson.length,
              itemBuilder: (BuildContext context, int index) {
                return _buiCabContainer(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
