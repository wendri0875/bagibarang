import 'package:bagi_barang/locator.dart';
import 'package:bagi_barang/models/stock.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:bagi_barang/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateStockViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  Stock _edittingStock;

  void setEdittingStock(Stock stock) {
    _edittingStock = stock;
  }

  bool get _editting => _edittingStock != null;

  Future addStock(
      {@required String idprod,
      @required String label,
      String stockid,
      @required String note,
      @required double qty}) async {
    setBusy(true);

    Timestamp date = Timestamp.fromDate(DateTime.now());

    var result;

    if (!_editting) {
      result = await _firestoreService.addStock(
          idprod, label, Stock(note: note, qty: qty, stockdate: date));
    } else {
      result = await _firestoreService.updateStock(idprod, label,
          Stock(stockid: stockid, note: note, qty: qty, stockdate: date));
    }
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not add Stock',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Stock successfully Added',
        description: 'Your stock has been created',
      );
    }

    _navigationService.pop();
  }
}
