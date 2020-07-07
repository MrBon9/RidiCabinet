import 'package:flutter/material.dart';
import 'package:RidiCabinet/src/blocs/user_blocs.dart';
import 'package:RidiCabinet/src/models/user_infor_models.dart';

class BackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // stream: bloc.userInfo,
        builder: (context, AsyncSnapshot<UserInfoModels> snapshot) {
      if (snapshot.hasData) {
        return Center(
          child: Container(
            child: Text(snapshot.data.userName),
          ),
        );
      } else if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }
      return Center(child: CircularProgressIndicator());
    });
  }
}
