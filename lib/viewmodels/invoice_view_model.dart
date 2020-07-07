import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/models/address.dart';
import 'package:bagi_barang/models/alloc.dart';
import 'package:bagi_barang/models/detailstatus.dart';
import 'package:bagi_barang/models/invoice.dart';
import 'package:bagi_barang/models/invoice_detail.dart';
import 'package:bagi_barang/models/stock.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import 'base_model.dart';

class InvoiceViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Invoice _invoice;
  Invoice get invoice => _invoice;

  double _qty;
  double get qty => _qty;

  double _subtotal = 0.0;
  double get subtotal => _subtotal;

  double _ttlweight = 0.0;
  double get ttlweight => _ttlweight;

  double _total = 0.0;
  double get total => _total;

  List<InvoiceDetail> _invoiceDetails;
  List<InvoiceDetail> get invoiceDetails => _invoiceDetails;

  void listenToInvoice(String invoiceid) {
    setBusy(true);
    _firestoreService
        .listenToInvoiceDocumentRealTime(invoiceid)
        .listen((invoiceData) {
      _invoice = invoiceData;
      listenToInvoiceDetail(invoiceid);

      notifyListeners();

      setBusy(false);
    });
  }

  void listenToInvoiceDetail(String invoiceid) {
    setBusy(true);
    _firestoreService
        .listenToInvoiceDetailRealTime(invoiceid)
        .listen((invoiceDetailData) {
      List<InvoiceDetail> invoiceDetails = invoiceDetailData;
      if (invoiceDetails != null && invoiceDetails.length > 0) {
        _invoiceDetails = invoiceDetails;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  var result;
  Future updateInvoiceToFS() async {
    result = await _firestoreService.updateInvoice(_invoice);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not update Invoice',
        description: result,
      );
    }
  }

  Future deleteItem(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Konfirmasi',
      description: 'Hapus item?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
      //checkBoxTitle: "Order tidak dilanjutkan",
    );

    if (dialogResponse.confirmed) {
      // if (dialogResponse.checkBox)
      //   deleteInvoiceDetailFinishOrder(index);
      //  else
      deleteInvoiceDetail(index);
    }
  }

  Future deleteInvoiceDetail(int index) async {
    setBusy(true);
    result = await _firestoreService.deleteInvoiceDetail(
        _invoice.invoiceid, _invoiceDetails[index].invoicedetailid);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not delete items',
        description: result,
      );
      return;
    } else {
//update total
      updateTotal();
      updateInvoiceToFS();
      notifyListeners();

      //kalau berhasil update alloc unshipped dikurangi dgn invoice qty
      Alloc alloc = await _firestoreService.getAlloc(
          _invoiceDetails[index].idprod,
          _invoiceDetails[index].varian,
          _invoiceDetails[index].orderid,
          _invoiceDetails[index].allocid);

      alloc.unshipped += _invoiceDetails[index].qty;
      _firestoreService.updateAlloc(
          alloc.idprod, alloc.varian, alloc.orderid, alloc);
    }

    setBusy(false);
  }

//   Future deleteInvoiceDetailFinishOrder(int index) async {
//     setBusy(true);

//     InvoiceDetail data = _invoiceDetails[index];
//     data.cancel = true;

//     result = await _firestoreService.updateInvoiceDetail(data);
//     if (result is String) {
//       await _dialogService.showDialog(
//         title: 'Could not delete items',
//         description: result,
//       );
//       return;
//     } else {
// //update total
//       updateTotal();
//       updateInvoiceToFS();
//       notifyListeners();

//       //kalau berhasil add stock return
//       result = await _firestoreService.addStock(
//           data.idprod,
//           data.varian,
//           Stock(
//               note: "Hasil retur order " + data.orderid,
//               qty: data.qty,
//               stockdate: Timestamp.fromDate(DateTime.now())));
//     }

//     setBusy(false);
//   }

  Future<void> cancelItem(int index, bool cancel) async {
    String titlestr = cancel ? "Cancel item" : "Restore Item";
    String descriptionstr =
        cancel ? "Order tidak dilanjutkan?" : "Jadikan nota?";

    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: titlestr,
      description: descriptionstr,
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
      //checkBoxTitle: "Order tidak dilanjutkan",
    );

    if (dialogResponse.confirmed) {
      var data = _invoiceDetails[index];
      data.cancel = cancel;
      _firestoreService.updateInvoiceDetail(data);

      //kalau berhasil add stock return
      if (cancel) {
        await _firestoreService.addStock(
            data.idprod,
            data.varian,
            Stock(
                note: data.invoicedetailid,
                qty: data.qty,
                stockdate: Timestamp.fromDate(DateTime.now())));
      } else {
        await _firestoreService.deleteStockCancelation(
            data.idprod, data.varian, data.invoicedetailid);
      }
      updateTotal();
      updateInvoiceToFS();
      notifyListeners();
    }
  }

  Future<void> delInvoice() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: "Hapus Invoice",
      description: "Yakin hapus invoice?",
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      result = await _firestoreService.delInvoice(_invoice.invoiceid);
      if (result is String) {
        await _dialogService.showDialog(
          title: 'Could not save Detail Status',
          isError: true,
          description: result,
        );
      } else
        pop();
      setBusy(false);
    }
  }

  void setCorrection(double correction) {
    _invoice.correction = correction ?? 0;
    updateTotal();
    updateInvoiceToFS();
    notifyListeners();
  }

  void setPostage(double postage) {
    _invoice.postage = postage ?? 0;
    updateTotal();
    updateInvoiceToFS();
    notifyListeners();
  }

  void updateTotal() {
    _subtotal = _invoiceDetails.fold(0.0, (prev, next) {
      if (!(next?.cancel ?? false))
        return prev + next.linettl ?? 0;
      else
        return prev;
    });
    _ttlweight = _invoiceDetails.fold(0.0, (prev, next) {
      if (!(next?.cancel ?? false))
        return prev + next.lineweight ?? 0;
      else
        return prev;
    });

    _total = _subtotal +
        double.parse((_invoice?.correction ?? 0).toString()) +
        double.parse((_invoice?.postage ?? 0).toString());

    _invoice.subtotal = _subtotal;
    _invoice.ttlweight = _ttlweight;
    _invoice.total = _total;
    _invoice.ttlitem = _invoiceDetails?.length ?? 0;
  }

  void pop() {
    _navigationService.pop();
  }

  Future navigateToDetailStatus(String invoiceid, int status) async {
    await _navigationService.navigateTo(DetailStatusViewRoute,
        arguments: {'status': status, 'invoiceid': invoiceid});
  }

  Future changeStatus(int toStatus) async {
    setBusy(true);
    Timestamp date = Timestamp.fromDate(DateTime.now());
    DetailStatus detailstatus = new DetailStatus();
    detailstatus.date = date;

    switch (toStatus) {
      case 2:
        var dialogResponse = await _dialogService.showTwoFieldDialog(
          title: 'Paid Note',
          description: 'Add some paid note',
          fieldOneTitle: 'Payment Methods',
          fieldTwoTitle: 'Note',
          confirmationTitle: 'Yes',
          cancelTitle: 'No',
        );
        if (!dialogResponse.confirmed) {
          return;
        }

        _invoice.paymtd = dialogResponse.fieldOne;
        detailstatus.note = dialogResponse.fieldTwo;

        break;
      case 3:
        var dialogResponse = await _dialogService.showTwoFieldDialog(
          title: 'Change Note',
          description: 'Add some change note',
          fieldOneTitle: 'Kurir',
          fieldTwoTitle: 'Resi',
          fieldThreeTitle: 'Note',
          confirmationTitle: 'Yes',
          cancelTitle: 'No',
        );
        if (!dialogResponse.confirmed) {
          return;
        }

        _invoice.courier = dialogResponse.fieldOne;
        _invoice.waybill = dialogResponse.fieldTwo;
        detailstatus.note = dialogResponse.fieldThree;

        break;

      case 4:
        var dialogResponse = await _dialogService.showTwoFieldDialog(
          title: 'Finish Note',
          description: 'Add some finish note',
          fieldOneTitle: 'Note',
          confirmationTitle: 'Yes',
          cancelTitle: 'No',
        );
        if (!dialogResponse.confirmed) {
          return;
        }
        break;

      default:
        var dialogResponse = await _dialogService.showTwoFieldDialog(
          title: 'Cancel Note',
          description: 'Add some cancel note',
          fieldOneTitle: 'Note',
          confirmationTitle: 'Yes',
          cancelTitle: 'No',
        );
        if (!dialogResponse.confirmed) {
          return;
        }

        detailstatus.note = dialogResponse.fieldOne;
    }

    _invoice.status = toStatus;
    detailstatus.status = toStatus;
    result = await _firestoreService.updateInvoice(_invoice);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not update Invoice',
        isError: true,
        description: result,
      );
    } else {
      result = await _firestoreService.addDetailStatus(
          _invoice.invoiceid, detailstatus);
      if (result is String) {
        await _dialogService.showDialog(
          title: 'Could not save Detail Status',
          isError: true,
          description: result,
        );
      }
    }

    setBusy(false);
  }
}
