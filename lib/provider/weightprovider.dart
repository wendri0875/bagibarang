import 'package:flutter/foundation.dart';

class WeightProvider with ChangeNotifier {
  static double _weight = 0;

  set weight(newValue) {
    _weight = newValue.toDouble();
    notifyListeners();
  }

  double get weight => _weight;
}
