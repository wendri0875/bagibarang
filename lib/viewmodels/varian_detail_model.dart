import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/models/stock.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';
import 'base_model.dart';

class VarianDetailModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final FirestoreService _firestoreService = locator<FirestoreService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  Variant _varian;
  Variant get varian => _varian;

  void listenToVarian(String idprod, String label) {
    setBusy(true);
    _firestoreService
        .listenToVarianDocumentRealTime(idprod, label)
        .listen((varianData) {
      Variant updatedVarian = varianData;
      if (updatedVarian != null) {
        _varian = updatedVarian;
        notifyListeners();
      }

      listenToOrders(idprod, label);
      listenToStockCard(idprod, label);
      setBusy(false);
    });
  }

  // Future navigateToCreateView() =>
  //     _navigationService.navigateTo(CreatePostViewRoute);

  List<Order> _orders;
  List<Order> get orders => _orders;

  double _ttlorder = 0.0;
  double get ttlorder => _ttlorder;

  double _ttlallocs = 0.0;
  double get ttlallocs => _ttlallocs;

  void listenToOrders(String idprod, String label) {
    setBusy(true);
    _firestoreService
        .listenToOrdersRealTime(idprod, label)
        .listen((ordersData) {
      List<Order> updatedOrders = ordersData;
      if (updatedOrders != null && updatedOrders.length > 0) {
        _orders = updatedOrders;
        _ttlorder =
            updatedOrders.fold(0.0, (prev, next) => prev + next.orderqty ?? 0);
        debugPrint("ttlorder = $_ttlorder");
        _ttlallocs = updatedOrders.fold(
            0.0, (prev, next) => prev + next?.allocated ?? 0);
        debugPrint("ttlallocs = $_ttlallocs");
        notifyListeners();
      }
      setBusy(false);
    });
  }

  List<Stock> _stockcard;
  List<Stock> get stockcard => _stockcard;

  double _ttlstock = 0.0;
  double get ttlstock => _ttlstock;

  void listenToStockCard(String idprod, String label) {
    setBusy(true);
    _firestoreService
        .listenToStockCardRealTime(idprod, label)
        .listen((stockData) {
      List<Stock> updatedStockCard = stockData;
      if (updatedStockCard != null && updatedStockCard.length > 0) {
        _stockcard = updatedStockCard;
        _ttlstock = updatedStockCard.fold(0.0, (prev, next) => prev + next.qty);

        debugPrint("ttlstock = $_ttlstock");
        notifyListeners();
      }
      setBusy(false);
    });
  }

  // List<Stock> _allocs;
  // List<Stock> get allocs => _allocs;

  // double _ttlallocs = 0.0;
  // double get ttlallocs => _ttlallocs;

  // void listenToAllocs(String idprod, String label) {
  //   setBusy(true);
  //   _firestoreService
  //       .listenToStockCardRealTime(idprod, label)
  //       .listen((stockData) {
  //     List<Stock> updatedStockCard = stockData;
  //     if (updatedStockCard != null && updatedStockCard.length > 0) {
  //       _stockcard = updatedStockCard;
  //       _ttlstock = updatedStockCard.fold(
  //           0.0, (prev, next) => prev + double.tryParse(next.qty));
  //           debugPrint("ttlallocs = $_ttlstock");
  //       notifyListeners();
  //     }
  //     setBusy(false);
  //   });
  // }

//--------------
  Future deleteOrder(String idprod, String label, int index) async {
    var result;
    var allocated = _orders[index].allocated ?? 0;
    if (allocated > 0) {
      result = "Tidak bisa di delete, Order sudah dialokasikan";

      await _dialogService.showDialog(
        title: 'Prohibitted',
        description: result,
      );
    } else {
      var dialogResponse = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?',
        description: 'Do you really want to delete the order?',
        confirmationTitle: 'Yes',
        cancelTitle: 'No',
      );

      if (dialogResponse.confirmed) {
        setBusy(true);
        await _firestoreService.deleteOrder(
            idprod, label, _orders[index].orderid);
        setBusy(false);
      }
    }
  }

//-------------------
  Future deleteStock(String idprod, String label, int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the stock?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      await _firestoreService.deleteStock(
          idprod, label, _stockcard[index].stockid);
      setBusy(false);
    }
  }

  Future navigateToCreateOrderView(String idprod, String label, double ttlorder,
      double ttlstock, double ttlallocs) async {
    await _navigationService.navigateTo(CreateOrderViewRoute, arguments: {
      'idprod': idprod,
      'label': label,
      'ttlorder': ttlorder,
      'ttlstock': ttlstock,
      'ttlallocs': ttlallocs
    });
    // await fetchPosts();
  }

  void navigateToEditOrder(String idprod, String label, int index,
      double ttlorder, double ttlstock, double ttlallocs) {
    _navigationService.navigateTo(CreateOrderViewRoute, arguments: {
      'idprod': idprod,
      'label': label,
      'edittingOrder': _orders[index],
      'ttlorder': ttlorder,
      'ttlstock': ttlstock,
      'ttlallocs': ttlallocs
    });
  }

  Future navigateToCreateStockView(
      String idprod, String label, double ttlallocs) async {
    await _navigationService.navigateTo(CreateStockViewRoute,
        arguments: {'idprod': idprod, 'label': label, 'ttlallocs': ttlallocs});
    // await fetchPosts();
  }

  void navigateToEditStock(String idprod, String label, int index) {
    _navigationService.navigateTo(CreateStockViewRoute, arguments: {
      'idprod': idprod,
      'label': label,
      'edittingStock': _stockcard[index]
    });
  }
}
