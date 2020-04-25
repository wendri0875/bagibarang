
import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();



  Future logout() async {
    setBusy(true);

    var result = await _authenticationService.firebaseSignOut();

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(LoginViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Logout Failure',
          description: 'Couldn\'t logout at this moment. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Logout Failure',
        description: result,
      );
    }
  }
 
}