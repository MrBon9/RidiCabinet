import 'package:flutter/material.dart';

class CustomListStationItem extends StatelessWidget {
  const CustomListStationItem({
    this.thumbnail,
    this.title,
    this.building,
    this.address,
    this.onTap,
  });

  final Widget thumbnail;
  final String title;
  final String building;
  final String address;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _StationDescription(
              title: title,
              building: building,
              address: address,
            ),
          ),
        ],
      ),
    );
  }
}

class _StationDescription extends StatelessWidget {
  const _StationDescription({
    Key key,
    this.title,
    this.building,
    this.address,
  }) : super(key: key);

  final String title;
  final String building;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            building,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '$address',
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
