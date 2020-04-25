
import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class ProductDetailModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final FirestoreService _firestoreService =
      locator<FirestoreService>();


  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  Product _product;
Product get product => _product;



 void listenToProduct(String idprod) {
    setBusy(true);
    _firestoreService.listenToProductDetailRealTime(idprod).listen((productsData) {
      
      Product updatedProduct = productsData;
      if (updatedProduct != null ) {
        _product = updatedProduct;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  // Future navigateToCreateView() =>
  //     _navigationService.navigateTo(CreatePostViewRoute);
 
}