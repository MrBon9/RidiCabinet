class CabListModels {
  static List<_CabinetProperties> _cabinetList = [];

  CabListModels(parsedJson) {
    parsedJson.forEach((value) {
      _cabinetList.add(_CabinetProperties(value['state'], value['status'],
          value['_id'], value['no'], value['station_id']));
    });
  }

  List<_CabinetProperties> get cabinetList => _cabinetList;
}

class _CabinetProperties {
  int _active;
  int _status;
  String _cabID;
  int _cabNo;
  String _stationID;
  // int priceInOneH, priceInOneD, priceInOneM;
  // String stationLoc, stationAddress, stationNo;

  _CabinetProperties(
      this._active, this._status, this._cabID, this._cabNo, this._stationID);

  int get cabActive => _active;

  int get cabStatus => _status;

  String get cabID => _cabID;

  int get cabNo => _cabNo;

  String get cabOfStationID => _stationID;

  // int get oneHourPrice => priceInOneH;
  // int get oneDayPrice => priceInOneD;
  // int get oneMonthPrice => priceInOneM;
}
