import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/alloc.dart';
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

  List<Billable> _billables;
  List<Billable> get billables => _billables;

  List<Alloc> _allocs;
  List<Alloc> get allocs => _allocs;

  List<Product> _products = List<Product>();
  List<Product> get products => _products;

  void listenToGroupedBillables() {
    setBusy(true);
    _firestoreService.listenToBillablesRealTime().listen((data) {
      List<Alloc> unshippedAllocs = data;
      if (unshippedAllocs != null && unshippedAllocs.length > 0) {
        _allocs = data;
        _billables = List<Billable>();
        //groupby
        Map<String, dynamic> a = groupBy(unshippedAllocs, (e) => e.custid)
            .map((key, value) => MapEntry(key, value.length));

        for (var entry in a.entries) {
          _billables.add(Billable(custid: entry.key, ttlitem: entry.value));
        }

        //  debugPrint(b.toString());

      } else {
        _billables
            .clear(); // terakhir  ter add tapi ga dihapus saat sudah kosong, makanya dihapus disini
      }
      setBusy(false);
      notifyListeners();
    });
  }

  void navigateToCartDetail(int index) {
    List<Alloc> custAllocs;
    custAllocs = _allocs
        .where((element) => element.custid == _billables[index].custid)
        .toList();

    _navigationService.navigateTo(CreateInvoiceViewRoute,
        arguments: {'custallocs': custAllocs});
  }
}
