import 'dart:convert';

import 'package:http/http.dart';
import 'package:RidiCabinet/src/models/station_data_models.dart';
import 'package:RidiCabinet/src/resources/user_data.dart';
import 'package:RidiCabinet/src/services/networking.dart';

class StationData {
  static List storeJson;

  static int priceOneHour, priceOneDay, priceOneMonth;
  static String stationDetailAddress, stationLoc, stationNo;
  static List<String> stationPic;
}
