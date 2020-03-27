import 'package:flutter/foundation.dart';

class PriceProvider with ChangeNotifier {
  static double _price = 0;

  set price(newValue) {
    _price = newValue.toDouble();
    notifyListeners();
  }

  double get price => _price;
}
