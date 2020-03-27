import 'package:flutter/foundation.dart';

class VarianProvider with ChangeNotifier {
  static double _totalorder = 0;

  set totalOrder(newValue) {
    _totalorder = newValue;
    notifyListeners();
  }

  double get totalOrder => _totalorder;
}
