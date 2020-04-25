
import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class VariantModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final FirestoreService _firestoreService =
      locator<FirestoreService>();


  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Variant> _variant;
  List<Variant> get variant => _variant;



 void listenToVariant(String idprod) {
    setBusy(true);
    _firestoreService.listenToVariantRealTime(idprod).listen((variantData) {
      
      List<Variant> updatedVariant = variantData;
      if (updatedVariant != null && updatedVariant.length > 0) {
        _variant = updatedVariant;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  // Future navigateToCreateView() =>
  //     _navigationService.navigateTo(CreatePostViewRoute);
 
}