
import 'package:bagi_barang/models/billable.dart';
import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import '../locator.dart';
import 'package:bagi_barang/viewmodels/base_model.dart';

class CreateInvoiceViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final NavigationService _navigationService = locator<NavigationService>();

  List<Billable> _billables = List<Billable>();
  List<Billable> get billables => _billables;

  List<Order> _updatedOrders;
  List<Order> get orders => _updatedOrders;

  List<Product> _products = List<Product>();
  List<Product> get products => _products;

  void getRefFilledBillableCustOrders(List<Order> custorders) {
    setBusy(true);
    //_firestoreService.listenToBillablesRealTime().listen((dataOrder) {
    // List<Order> updatedOrders = dataOrder;
    if (custorders != null && custorders.length > 0) {
      // _updatedOrders = custorders;

      //get reference collection (pengganti join spt sql)

      //product

//get unique idprod in list
      // var prodvars = custorders
      //     .map((e) => Prodvar(idprod: e.idprod, varian: e.varian))
      //     .toSet()
      //     .toList();

      var idprods = custorders.map((e) => e.idprod).toSet().toList();

      idprods.forEach((idprod) {
        _firestoreService.getProduct(idprod).then((product) {
          //  if (!product is String) {
          Product prod = product;
          prod.variant = List<Variant>();
          _products.add(prod);
          notifyListeners();
          //order.pname = prod.pname;

          //get varian
          var prodvariant = custorders
              .where((element) => element.idprod == prod.idprod)
              .map((e) => e.varian)
              .toSet()
              .toList();

          if (prodvariant != null) {
            prodvariant.forEach((label) {
              _firestoreService.getVarian(prod.idprod, label).then((varian) {
                // if (!varian is String) {
                Variant vari = varian;
                _products
                    .firstWhere((element) => element.idprod == prod.idprod)
                    .variant
                    .add(vari);

                //prod.variant.add(vari);
                // order.price = vari.price;
                //order.weight = vari.weight;
                notifyListeners();
                //    }
              });
            });
          }
        });

        //get variant

// // if (!_products.contains(product)) {
        // //   _products.add(product);
        // // }

        // // get sub variant
        // _firestoreService
        //     .listenToVariantRealTime(order.idprod)
        //     .listen((variants) {
        //   List<Variant> updatedVariant = variants;
        //   if (updatedVariant != null && updatedVariant.length > 0) {
        //     _variant = updatedVariant;
        //     _products
        //         .firstWhere((element) => element.idprod == order.idprod)
        //         .variant = _variant;
        //   }
        // });

        // _firestoreService.getProduct(order.idprod).then((product) {
        //   //  if (!product is String) {
        //   Product prod = product;
        //   order.pname = prod.pname;
        //   notifyListeners();
        //   //   }
        // });
      });

      // //groupby
      // Map<String, dynamic> a = groupBy(updatedOrders, (e) => e.custid)
      //     .map((key, value) => MapEntry(key, value.length));

      // for (var entry in a.entries) {
      //   _billables.add(Billable(custid: entry.key, ttlitem: entry.value));
      // }

      //  debugPrint(b.toString());

      //  notifyListeners();
    }
    setBusy(false);
    // });
  }

  Product getModelProduct(String idprod) => _products
      .firstWhere((element) => element.idprod == idprod, orElse: () => null);

  Variant getModelProductVarian(String idprod, String varian) {
    return _products
        .firstWhere((element) => element.idprod == idprod, orElse: () => null)
        ?.variant
        ?.firstWhere((element) => element.label == varian, orElse: () => null);
  }

  // void navigateToCartDetail(int index) {
  //   _navigationService.navigateTo(CreateInvoiceViewRoute,
  //       arguments: {'custid': _billables[index].custid});
  // }
}
