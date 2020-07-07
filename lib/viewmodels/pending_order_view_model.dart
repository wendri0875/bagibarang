import 'package:bagi_barang/constants/route_names.dart';

import 'package:bagi_barang/models/customer.dart';
import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';

import 'package:bagi_barang/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class PendingOrderViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Order> _orders;
  List<Order> get orders => _orders;

  Customer _customer = Customer();
  Customer get customer => _customer;

  List<Product> _products = List<Product>();
  List<Product> get products => _products;

  void listenToPendingOrders(String searchstr) {
    setBusy(true);
    _orders = null;
    _firestoreService
        .listenToPendingOrderRealTime(searchstr)
        .listen((orderData) {
      if (orderData != null && orderData.length > 0) {
        _orders = orderData;
        _orders.sort((a, b) => a.orderdate.compareTo(b.orderdate));
        //     notifyListeners();

//get reference collection (pengganti join spt sql)
//product
        var idprods = _orders.map((e) => e.idprod).toSet().toList();

        idprods.forEach((idprod) {
          _firestoreService.getProduct(idprod).then((product) {
            //  if (!product is String) {
            Product prod = product;
            prod.variant =
                List<Variant>(); // kasih kosongan karena null ga bisa diisi
            _products.add(prod);

            //update pname di list invoice detail
            _orders
                .where((element) => element.idprod == idprod)
                .forEach((element) {
              element.pname = prod.pname;
              element.imageUrl = prod.imageUrl;
            });

            notifyListeners();
          });
        });
      }
      setBusy(false);
    });
  }

  Future deleteItem(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete item?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      var result = await _firestoreService.updateOrder(
          orders[index].idprod,
          orders[index].varian,
          Order(orderid: orders[index].orderid, pending: 0));

      if (result is String) {
        await _dialogService.showDialog(
          title: 'Gagal hapus pending order',
          description: result,
        );
      }

      notifyListeners();
    }
  }

  void navigateToProductDetail(String idprod
//, String label
      ) //async
  {
    //if (label != null) {

    //Variant varian = await _firestoreService.getVarian(idprod, label);

    _navigationService.navigateTo(ProductDetailRoute, arguments: {
      'idprod': idprod
      //, 'varian': varian
    });
    // }
  }
}
