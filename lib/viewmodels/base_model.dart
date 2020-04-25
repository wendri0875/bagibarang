import 'package:bagi_barang/locator.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class BaseModel extends ChangeNotifier {

 final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

FirebaseUser get currentFirebaseUser => _authenticationService.currentFirebaseUser;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
