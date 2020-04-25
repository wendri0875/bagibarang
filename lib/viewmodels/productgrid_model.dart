
import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class ProductGridModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final FirestoreService _firestoreService =
      locator<FirestoreService>();


  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Product> _products;
  List<Product> get products => _products;



 void listenToProducts() {
    setBusy(true);
    _firestoreService.listenToProductsRealTime().listen((productsData) {
      
      List<Product> updatedProducts = productsData;
      if (updatedProducts != null && updatedProducts.length > 0) {
        _products = updatedProducts;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  void navigateToProductDetail(String idprod, var imageFile)
  {
    _navigationService.navigateTo(ProductDetailRoute,arguments:{'idprod': idprod,'imageFile':imageFile} );
  }

  // Future navigateToCreateView() =>
  //     _navigationService.navigateTo(CreatePostViewRoute);
 
}