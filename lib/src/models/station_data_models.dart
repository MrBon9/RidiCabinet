import 'dart:convert';

class StationDataModels {
  static List<_StationCab> _station = [];

  StationDataModels(parsedJson) {
    _station.clear();
    if (parsedJson.length > 0) {
      parsedJson.forEach((value) {
        _station.add(_StationCab(
            value['_id'],
            value['location'],
            value['placename'],
            value['no'],
            value['address'],
            value['price_id']['price_oneDay'],
            value['price_id']['price_oneHour'],
            value['price_id']['price_oneMonth']));
      });
    }

    // parsedJson.forEach((value) {
    //   _station.add(_StationCab(
    //       value['_id'],
    //       value['location'],
    //       value['placename'],
    //       value['no'],
    //       value['address'],
    //       value['price_id']['price_oneDay'],
    //       value['price_id']['price_oneHour'],
    //       value['price_id']['price_oneMonth']));
    // });
  }

  List<_StationCab> get station => _station;
}

class _StationCab {
  String _stationID;
  String _stationLoc;
  String _stationAddress;
  String _stationNum;
  String _addressDetail;
  int _priceOneDay, _priceOneHour, _priceOneMonth;

  _StationCab(
      this._stationID,
      this._stationLoc,
      this._stationAddress,
      this._stationNum,
      this._addressDetail,
      this._priceOneDay,
      this._priceOneHour,
      this._priceOneMonth);

  String get stationID => _stationID;

  String get stationLocation => _stationLoc;

  String get stationAddress => _stationAddress;

  String get stationNumber => _stationNum;

  String get stationAddressDetail => _addressDetail;

  int get stationADayPrice => _priceOneDay;

  int get stationAHourPrice => _priceOneHour;

  int get stationAMonthPrice => _priceOneMonth;
}
