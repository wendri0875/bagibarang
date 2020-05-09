import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/billable.dart';
import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/navigation_service.dart';

import '../locator.dart';
import 'package:bagi_barang/viewmodels/base_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class BillablesModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final NavigationService _navigationService = locator<NavigationService>();

  List<Billable> _billables = List<Billable>();
  List<Billable> get billables => _billables;

  List<Order> _orders;
  List<Order> get orders => _orders;

  List<Product> _products = List<Product>();
  List<Product> get products => _products;



  void listenToGroupedBillables() {
    setBusy(true);
    _firestoreService.listenToBillablesRealTime().listen((dataOrder) {
      List<Order> updatedOrders = dataOrder;
      if (updatedOrders != null && updatedOrders.length > 0) {
        _orders = updatedOrders;

          //groupby
        Map<String, dynamic> a = groupBy(updatedOrders, (e) => e.custid)
            .map((key, value) => MapEntry(key, value.length));

        for (var entry in a.entries) {
          _billables.add(Billable(custid: entry.key, ttlitem: entry.value));
        }

        //  debugPrint(b.toString());

        notifyListeners();
      }
      setBusy(false);
    });
  }

  void navigateToCartDetail(int index) {

    List<Order> custOrders;
    custOrders = _orders.where((element) => element.custid==_billables[index].custid).toList();
    
    _navigationService.navigateTo(CreateInvoiceViewRoute,
        arguments: {'custorders': custOrders});
  }
}
