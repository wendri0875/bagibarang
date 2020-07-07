import 'package:bagi_barang/locator.dart';
import 'package:bagi_barang/models/detailstatus.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:bagi_barang/viewmodels/base_model.dart';

class DetailStatusViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<DetailStatus> _detailstatuses;
  List<DetailStatus> get detailstatuses => _detailstatuses;

  void listenToDetailStatus(String invoiceid) {
    setBusy(true);
    _firestoreService
        .listenToDetailStatusRealTime(invoiceid)
        .listen((detailStatusData) {
      _detailstatuses = detailStatusData;
      notifyListeners();
    });

    setBusy(false);
  }
}
