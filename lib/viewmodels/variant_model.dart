import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import 'base_model.dart';

class VariantModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final FirestoreService _firestoreService = locator<FirestoreService>();

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

  Variant _edittingVarian;
  void setEdittingOrder(Variant varian) {
    _edittingVarian = varian;
  }

  bool get _editting => _edittingVarian != null;

  Future addVarian(
      {@required String idprod,
      int no,
      String label,
      double price,
      double weight}) async {
    setBusy(true);

    var result;

    if (!_editting) {
      //add
      result = await _firestoreService.addVarian(
          idprod, Variant(no: no, label: label, weight: weight, price: price));
    } else {
      //edit
      //cek orderqty vs ttlorderallocs

      result = await _firestoreService.updateVarian(
          idprod, Variant(no: no, label: label, weight: weight, price: price));

      setBusy(false);

      if (result is String) {
        await _dialogService.showDialog(
          title: 'Could not add Varian',
          description: result,
        );
      } else {
        await _dialogService.showDialog(
          title: 'Varian successfully Added',
          description: 'Your varian has been created',
        );
      }

      if (!_editting) _navigationService.pop();
    }

    // Future navigateToCreateView() =>
    //     _navigationService.navigateTo(CreatePostViewRoute);
  }
}
