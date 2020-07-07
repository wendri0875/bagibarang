import 'package:bagi_barang/locator.dart';
import 'package:bagi_barang/models/address.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:bagi_barang/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateAddressViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  Address _edittingAddress;
  Address get edittingAddress => _edittingAddress;

  void setEdittingAddress(Address address) {
    _edittingAddress = address;
  }

  bool get editting => _edittingAddress != null;

  Future addAddress(
      {@required String custid,
      String addressid,
      @required String recipient,
      @required String address,
      @required String phone
      }) async {
    setBusy(true);

    Timestamp date = Timestamp.fromDate(DateTime.now());

    var result;
    if (!editting) {
      result = await _firestoreService.addAddress(
          custid,
          Address(
              addressid: addressid,
              recipient: recipient,
              address: address,
              phone: phone));
    } else {
      result = await _firestoreService.updateAddress(
          custid,
          Address(
              addressid: addressid,
              recipient: recipient,
              address: address,
              phone: phone));
    }
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not add Address',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Address successfully Added',
        description: 'Your address has been created',
      );
    }

    _navigationService.pop();
  }
}
