import 'package:RidiCabinet/src/models/user_infor_models.dart';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:RidiCabinet/src/services/networking.dart';

class UserInfoData {
  static String id;

  //user email
  static String email;

  //user username
  static String username;

  static List<dynamic> userStation = new List();

  static List<dynamic> userCabinet = new List();

  static List<dynamic> storeUserCab = new List();

  // static String uname;
  // Client client = Client();

  // Future<UserInfoModels> FetchUserData() async {
  //   final response = await client.get(NetworkConnect.api + 'login');

  //   if (response.statusCode == 200) {
  //     var result = json.decode(response.body);
  //     // If the call to the server was successful, parse the JSON
  //     return UserInfoModels.fromJson(result);
  //   } else {
  //     // If that call was not successful, throw an error.
  //     throw Exception('Failed to load data');
  //   }
  // }
}

// static String id, email, _uname;

// //tram tu co o tu cua user
// List<dynamic> uCabStation = new List();

// //cac tram tu de dang ky o tu moi
// static List<dynamic> regStation = new List();

// //dang ky o tu moi tren tram tu vua bam vao
// static List<dynamic> regBox = new List();

// //luu giu thong tin ban dau cua tram tu va o tu ma nguoi dung dang so huu, listStation va listBox xu ly dua tren list
// static List<dynamic> store = new List();

// //luu giu thong tin ban dau cua nhung nguoi duoc uy quyen boi user
// static List<dynamic> auth_store = new List();

// //id cua nguoi dc uy quyen boi user
// static String auth_id = "";

// }
