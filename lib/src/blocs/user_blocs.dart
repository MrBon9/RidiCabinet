import 'dart:async';

import 'package:RidiCabinet/src/models/user_infor_models.dart';
import 'package:rxdart/rxdart.dart';

// class UserBloc {
//   final _repository = Repository();
//   final _dataFetcher = PublishSubject<UserInfoModels>();

//   Stream<UserInfoModels> get userInfo => _dataFetcher.stream;

//   fetchUserData() async {
//     UserInfoModels userDataModels = await _repository.fetchUserData();
//     _dataFetcher.sink.add(userDataModels);
//   }

//   dispose() {
//     _dataFetcher.close();
//   }
// }

// final bloc = UserBloc();
