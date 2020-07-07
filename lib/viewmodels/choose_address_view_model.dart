import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/address.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import 'base_model.dart';

class ChooseAddressViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<Address> _addresses;
  List<Address> get addresses => _addresses;

  Address _address;
  Address get address => _address;

  void listenToAddresses(String custid, String currAddressid) {
    setBusy(true);
    _firestoreService.listenToAddressesRealTime(custid).listen((addressesData) {
      List<Address> updatedAddresses = addressesData;
      if (updatedAddresses != null && updatedAddresses.length > 0) {
        _addresses = updatedAddresses;
        _address = _addresses.firstWhere(
            (element) => element.addressid == currAddressid,
            orElse: () => null);
        notifyListeners();
      }
      setBusy(false);
    });
  }

  Future deleteItem(String custid, int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete item?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      await _firestoreService.deleteAddress(
          custid, _addresses[index].addressid);
      setBusy(false);
    }
  }

  Future setDefaultAddress(String custid, int index) async {
    setBusy(true);
    await _firestoreService.setDefaultAddress(custid, _addresses, _addresses[index].addressid);
    setBusy(false);
  }

  void choosenAddress(Address choosenaddr) {
    _address = choosenaddr;
    notifyListeners();
  }

  void pop(Address addr) {
    _navigationService.pop(addr);
  }

  Future navigateToCreateAddressView(String custid) async {
    await _navigationService
        .navigateTo(CreateAddressViewRoute, arguments: {'custid': custid});
    // await fetchPosts();
  }

  void navigateToEditAddress(String custid, int index) {
    _navigationService.navigateTo(CreateAddressViewRoute, arguments: {
      'custid': custid,
      'edittingAddress': _addresses[index],
    });
  }
}
