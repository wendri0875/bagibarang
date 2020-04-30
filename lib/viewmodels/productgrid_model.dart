
import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/cloud_storage_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class ProductGridModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
      
  final FirestoreService _firestoreService =
      locator<FirestoreService>();


  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Product> _products;
  List<Product> get products => _products;

  Future<String> getImageUrl(int index) async {
    String imageUrl;
    imageUrl = await _cloudStorageService.getImageUrl(imageFileName: _products[index].imageFileName);
    return imageUrl;
  }

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

  void navigateToProductDetail(String idprod)
  {
    _navigationService.navigateTo(ProductDetailRoute,arguments:{'idprod': idprod} );
  }

  // Future navigateToCreateView() =>
  //     _navigationService.navigateTo(CreatePostViewRoute);
  Future deleteProduct(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the post?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      var productToDelete = _products[index];
      setBusy(true);
      await _firestoreService.deleteProduct(productToDelete.idprod);
      // Delete the image after the post is deleted
      await _cloudStorageService.deleteImage(productToDelete.imageFileName);
      setBusy(false);
    }
  }

 
}