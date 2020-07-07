import 'package:bagi_barang/constants/route_names.dart';

import 'package:bagi_barang/models/customer.dart';
import 'package:bagi_barang/models/invoice.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';

import 'package:bagi_barang/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class InvoiceListViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Invoice> _invoices;
  List<Invoice> get invoices => _invoices;

  Customer _customer = Customer();
  Customer get customer => _customer;

  List<Product> _products = List<Product>();
  List<Product> get products => _products;

  List<bool> _isSelected = [true, false, false, false, false, false];
  List<bool> get isSelected => _isSelected;

  void selectStatus(int index) {
    for (int indexBtn = 0; indexBtn < _isSelected.length; indexBtn++) {
      if (indexBtn == index) {
        _isSelected[indexBtn] = true;
      } else {
        _isSelected[indexBtn] = false;
      }
    }
    notifyListeners();
  }

  void listenToInvoices(String searchstr) {
    setBusy(true);
    _invoices = null;
    _firestoreService
        .listenToInvoiceListRealTime(searchstr)
        .listen((invoiceData) {
      _invoices = invoiceData;
      if (invoiceData != null && invoiceData.length > 0) {
        _invoices.sort((a, b) => a.date.compareTo(b.date));
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
      // var result = await _firestoreService.updateOrder(
      //     _invoices[index].idprod,
      //     _invoices[index].varian,
      //     Order(orderid: orders[index].orderid, pending: 0));

      // if (result is String) {
      //   await _dialogService.showDialog(
      //     title: 'Gagal hapus pending order',
      //     description: result,
      //   );
      // }

      notifyListeners();
    }
  }

  void navigateToInvoiceView(String invoiceid
//, String label
      ) //async
  {
    //if (label != null) {

    //Variant varian = await _firestoreService.getVarian(idprod, label);

    _navigationService.navigateTo(InvoiceViewRoute, arguments: {
      'invoiceid': invoiceid
      //, 'varian': varian
    });
    // }
  }
}
