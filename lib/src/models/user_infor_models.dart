class UserInfoModels {
  String _id, _name, _sex, _number, _email;
  String _birthday;
  int _ownedCab;

  UserInfoModels.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['_id'];
    _name = parsedJson['username'];
    _sex = parsedJson['sex'];
    _number = parsedJson['phonenum'];
    _email = parsedJson['email'];
    _birthday = parsedJson['birthday'];
  }

  String get userId => _id;

  String get userName => _name;

  String get userSex => _sex;

  String get userNumber => _number;

  String get userEmail => _email;

  String get userBirth => _birthday;

  int get userOwnedCab => _ownedCab;

  // set userName(String value) {
  //   this._lastNameController = value;
  //   notifyListeners();
  // }
}
