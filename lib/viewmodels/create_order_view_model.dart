import 'package:bagi_barang/locator.dart';
import 'package:bagi_barang/models/alloc.dart';
import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';

import 'package:bagi_barang/viewmodels/base_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateOrderViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  double allocable;
  Order _edittingOrder;

  double _ttlorder = 0.0;
  double get ttlorder => _ttlorder;
  void setTtlOrder(double ttlorder) {
    _ttlorder = ttlorder;
  }

  double _ttlallocs = 0.0;
  double get ttlallocs => _ttlallocs;
  void setTtlallocs(double ttlallocs) {
    _ttlallocs = ttlallocs;
  }

  double _ttlstock = 0.0;
  double get ttlstock => _ttlstock;
  void setTtlStock(double ttlstock) {
    _ttlstock = ttlstock;
  }

  List<Alloc> _orderallocs;
  List<Alloc> get orderallocs => _orderallocs;

  double _ttlorderalloc = 0.0;
  double get ttlorderallocs => _ttlorderalloc;

  void setEdittingOrder(Order order) {
    _edittingOrder = order;
  }

  bool get _editting => _edittingOrder != null;

  Alloc _edittingAlloc;
  void setEdittingAlloc(Alloc alloc) {
    _edittingAlloc = alloc;
  }

  bool get _edittingalloc => _edittingAlloc != null;

  Future addOrder(
      {@required String idprod,
      @required String label,
      String orderid,
      @required String custid,
      @required double orderqty}) async {
    setBusy(true);

    Timestamp date = Timestamp.fromDate(DateTime.now());

    var result;

    if (!_editting) {
      //add
      result = await _firestoreService.addOrder(idprod, label,
          Order(custid: custid, orderqty: orderqty, orderdate: date));
    } else {
      //edit
      //cek orderqty vs ttlorderallocs
      if (orderqty >= ttlorderallocs) {
        result = await _firestoreService.updateOrder(
            idprod,
            label,
            Order(
                orderid: orderid,
                custid: custid,
                orderqty: orderqty,
                //  orderdate: date,
                allocated: _ttlorderalloc));
      } else {
        result = "Order tidak boleh lebih kecil dr total alokasi";
      }
    }
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not add Order',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Order successfully Added',
        description: 'Your order has been created',
      );
    }

    if (!_editting) _navigationService.pop();
  }

  Future addAllocation({
    @required String idprod,
    @required String label,
    @required String orderid,
    String allocid,
    @required double qty,
  }) async {
    setBusy(true);

    //--DISINI HITUNG LIMIT ENTRI ORDER STOCK DAN ALLOC
    var result;

    var f = new NumberFormat("#.#");

    if (!_edittingalloc) {
      //add
      //cek dgn orderqty
      allocable = _edittingOrder.orderqty - (ttlorderallocs);
      if (allocable >= qty) {
        //cek melawan stock
        allocable = ttlstock - (ttlallocs);
        if (allocable >= qty) {
          Timestamp date = Timestamp.fromDate(DateTime.now());
          result = await _firestoreService.addAlloc(
              idprod, label, orderid, Alloc(date: date, qty: qty));
        } else {
          if (allocable == 0)
            result = "Stock habis";
          else
            result = 'Stock tinggal ${f.format(allocable)}';
        }
      } else {
        result = "Alokasi melebih jumlah order";
      }
    } else {
      //edit
      //cek dgn orderqty
      allocable =
          _edittingOrder.orderqty - (ttlorderallocs - _edittingAlloc.qty);
      if (allocable >= qty) {
        //cek melawan stock
        allocable = ttlstock - (ttlallocs - _edittingAlloc.qty);
        if (allocable >= qty) {
          result = await _firestoreService.updateAlloc(
              idprod,
              label,
              orderid,
              Alloc(
                allocid: allocid,
                qty: qty,
              ));
        } else {
          if (allocable == 0)
            result = "Stock habis";
          else
            result = 'Stock tinggal ${f.format(allocable)}';
        }
      } else {
        result = "Alokasi melebih jumlah order";
      }
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not add Allocation',
        description: result,
      );
    } else {
      result = await _firestoreService.updateOrder(
          idprod, label, Order(orderid: orderid, allocated: _ttlorderalloc));

      if (result is String) {
        await _dialogService.showDialog(
          title:
              'Allocation successfully added but could not update total allocation on order',
          description: result,
        );
      } else {
        await _dialogService.showDialog(
          title: 'Allocation successfully Added',
          description: 'Your allocation has been created',
        );
      }
    }

    // _navigationService.pop();
  }

  void listenToOrderAllocs(String idprod, String label, String orderid) {
    setBusy(true);
    _firestoreService
        .listenToAllocsRealTime(idprod, label, orderid)
        .listen((allocsData) {
      List<Alloc> updatedAllocs = allocsData;
      //  if (updatedAllocs != null && updatedAllocs.length > 0) {
      _orderallocs = updatedAllocs;
      _ttlorderalloc = updatedAllocs.fold(0.0, (prev, next) => prev + next.qty);
      //   }
      notifyListeners();
      // setBusy(false);
    });
    setBusy(false);
  }

//--------------
  Future deleteAlloc(
      String idprod, String label, String orderid, int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the allocation?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      await _firestoreService.deleteAlloc(
          idprod, label, orderid, _orderallocs[index].allocid);
      await _firestoreService.updateOrder(
          idprod, label, Order(orderid: orderid, allocated: _ttlorderalloc));
      setBusy(false);
    }
  }
}
