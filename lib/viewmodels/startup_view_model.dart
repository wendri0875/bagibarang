import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/services/authentication_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    if (hasLoggedInUser) {
      _navigationService.navigateTo(HomeViewRoute,arguments:{'title': 'BAGI BARANG'},);
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }
  }
}