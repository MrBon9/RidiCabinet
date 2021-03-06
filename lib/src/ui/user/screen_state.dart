import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class ScreenState {
  static bool register_station_screen = false;
  static bool user_station_screen = false;
  static bool authorize_screen = false;

  static Scann_QR() async {
    String result;
    try {
      result = (await BarcodeScanner.scan()) as String;
      print("Scann successfully");
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        print('Camera permission was denied');
      } else {
        print('Unknown Error $ex');
      }
    } on FormatException {
      print("You pressed the back button before scanning anything");
    } catch (ex) {
      print("Unknown Error $ex");
    }
    return result;
  }
}
