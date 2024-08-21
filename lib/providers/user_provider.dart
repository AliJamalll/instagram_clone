import 'package:flutter/cupertino.dart';
import 'package:instagram_clonee/resouces/auth_method.dart';

import '../model/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  final AuthMethod _authMethods = AuthMethod();

  User? get getUser => _user;

  Future<void> refreshUser() async {

    User user = await _authMethods.getUserDetails();

    _user = user;

    notifyListeners();

  }
}