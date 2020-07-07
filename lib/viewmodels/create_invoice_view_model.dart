import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/address.dart';
import 'package:bagi_barang/models/alloc.dart';
import 'package:bagi_barang/models/billable.dart';
import 'package:bagi_barang/models/customer.dart';
import 'package:bagi_barang/models/invoice.dart';
import 'package:bagi_barang/models/invoice_detail.dart';
import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../locator.dart';
import 'package:bagi_barang/viewmodels/base_model.dart';

class CreateInvoiceViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Billable> _billables = List<Billable>();
  List<Billable> get billables => _billables;

  List<Alloc> _updatedAllocs;
  List<Alloc> get allocs => _updatedAllocs;

  Invoice _invoice = Invoice();
  Invoice get invoice => _invoice;

  Customer _customer = Customer();
  Customer get customer => _customer;

  List<InvoiceDetail> _invoiceDetails;
  List<InvoiceDetail> get invoicedetails => _invoiceDetails;

  List<Product> _products = List<Product>();
  List<Product> get products => _products;

  double _qty;
  double get qty => _qty;

  double _subtotal = 0.0;
  double get subtotal => _subtotal;

  double _ttlweight = 0.0;
  double get ttlweight => _ttlweight;

  double _total = 0.0;
  double get total => _total;

  void getRefFilledBillableCustOrders(List<Alloc> custallocs) {
    setBusy(true);
    //_firestoreService.listenToBillablesRealTime().listen((dataOrder) {
    // List<Order> updatedOrders = dataOrder;
    if (custallocs != null && custallocs.length > 0) {
      _updatedAllocs = custallocs;

//order to invoice
      _invoice.custid = custallocs[0].custid;
// get customer object
      _firestoreService.getCustomer(_invoice.custid).then((customer) {
        if (customer != null) {
          _customer = customer;
          _invoice.custname = _customer.custname;

          // _firestoreService.getAddressList(_invoice.custid).then((addresses) {
          //   if (addresses != null) {
          //     _customer.addresses = addresses;
          //     notifyListeners();
          //   }
          // });
          notifyListeners();
        }
      });

      // get default addresss
      _firestoreService.getDefltAddress(_invoice.custid).then((address) {
        if (address != null) {
          _invoice.addressid = address.addressid;
          _invoice.recipient = address.recipient;
          _invoice.address = address.address;
          _invoice.phone = address.phone;
          _invoice.deflt = address.deflt;

          notifyListeners();
        }
      });

//order to invoice detail
      _invoiceDetails =
          custallocs.map((e) => InvoiceDetail.fromAlloc(e)).toList();

      //get reference collection (pengganti join spt sql)

      //get all orders from list of allocs

      var idprods = custallocs.map((e) => e.idprod).toSet().toList();

      idprods.forEach((idprod) {
        _firestoreService.getProduct(idprod).then((product) {
          //  if (!product is String) {
          Product prod = product;
          prod.variant =
              List<Variant>(); // kasih kosongan karena null ga bisa diisi
          _products.add(prod);

          //update pname di list invoice detail
          _invoiceDetails
              .where((element) => element.idprod == idprod)
              .forEach((element) {
            debugPrint(element.idprod);
            element.pname = prod.pname;
            element.imageUrl = prod.imageUrl;
          });

          notifyListeners();
          //order.pname = prod.pname;

          //get varian
          var prodvariant = custallocs
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

                //update pname di list invoice detail
                _invoiceDetails
                    .where((element) =>
                        element.idprod == idprod && element.varian == label)
                    .forEach((e) {
                  e.price = vari.price;
                  e.weight = vari.weight;
                  e.linettl = e.qty * vari.price;
                  e.lineweight = e.qty * vari.weight;

                  //      _subtotal += e.linettl;
                  //     _ttlweight += e.lineweight;
                });

                //      _total = _subtotal +
                //        double.parse((_invoice?.adjustment ?? 0).toString()) +
                //        double.parse((_invoice?.ongkir ?? 0).toString());
                updateTotal();
                notifyListeners();
                //    }
              });
            });
          }
        });
      });

      notifyListeners();
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

  void updateInvoiceQty(int index, double newqty) {
    if (_invoiceDetails != null) {
      _invoiceDetails[index].qty = newqty;
      _invoiceDetails[index].linettl = newqty * _invoiceDetails[index].price;
      _invoiceDetails[index].lineweight =
          newqty * _invoiceDetails[index].weight;

      updateTotal();
      notifyListeners();
    }
  }

  Future deleteItem(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete item?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      _invoiceDetails.removeAt(index);
      updateTotal();
      notifyListeners();
    }
  }

  void updateTotal() {
    _subtotal =
        _invoiceDetails.fold(0.0, (prev, next) => prev + next?.linettl ?? 0);
    _ttlweight =
        _invoiceDetails.fold(0.0, (prev, next) => prev + next?.lineweight ?? 0);

    _total = _subtotal +
        double.parse((_invoice?.correction ?? 0).toString()) +
        double.parse((_invoice?.postage ?? 0).toString());

    _invoice.subtotal = _subtotal;
    _invoice.ttlweight = _ttlweight;
    _invoice.total = _total;
    _invoice.ttlitem = _invoiceDetails?.length ?? 0;
  }

  void setCorrection(double correction) {
    _invoice.correction = correction ?? 0;
    updateTotal();
    notifyListeners();
  }

  

  void setPostage(double postage) {
    _invoice.postage = postage ?? 0;
    updateTotal();
    notifyListeners();
  }

  Future addInvoice() async {
    setBusy(true);

    Timestamp date = Timestamp.fromDate(DateTime.now());
    _invoice.date = date;
    _invoice.status = 1;

    var result;
    //add
    result = await _firestoreService.addInvoice(_invoice);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not add Invoice',
        description: result,
      );
      return;
    } else {
      //add invoice detail
      DocumentReference docref = result;
      _invoiceDetails.forEach((invoiceDetail) async {
        result = await _firestoreService.addInvoiceDetail(
            docref.documentID, invoiceDetail);
        if (result is String) {
          await _dialogService.showDialog(
            title: 'Could not add Invoice',
            description: result,
          );
          return;
        } else {
          //kalau berhasil update shipped di order

          Alloc alloc = _updatedAllocs.firstWhere(
              (element) => element.orderid == invoiceDetail.orderid);
          alloc.unshipped -= invoiceDetail.qty;
          _firestoreService.updateAlloc(
              alloc.idprod, alloc.varian, alloc.orderid, alloc);
        }
      });

      if (result is String) {
        await _dialogService.showDialog(
          title: 'Could not add Invoice',
          description: result,
        );
      } else {
        await _dialogService.showDialog(
          title: 'Invoice successfully Added',
          description: 'The invoice has been created',
        );
      }
    }
    setBusy(false);
    _navigationService.pop();
  }

  Future<void> navigateToChooseAddress(
      String custid, String currAddressid) async {
    Address address = await _navigationService.navigateTo(
        ChooseAddressViewRoute,
        arguments: {'custid': custid, 'currAddressid': currAddressid});
    if (address != null) {
      _invoice.addressid = address.addressid;
      _invoice.recipient = address.recipient;
      _invoice.address = address.address;
      _invoice.phone = address.phone;
      _invoice.deflt = address.deflt;
      notifyListeners();
    }
  }
}
