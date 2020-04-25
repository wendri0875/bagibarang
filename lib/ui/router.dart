import 'package:bagi_barang/constants/route_names.dart';
import 'package:bagi_barang/ui/views/create_order_view.dart';
import 'package:bagi_barang/ui/views/create_stock_view.dart';
import 'package:bagi_barang/ui/views/home_view.dart';
import 'package:bagi_barang/ui/views/login_view.dart';
import 'package:bagi_barang/ui/views/product_detail.dart';
import 'package:bagi_barang/ui/views/signup_view.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        arguments: settings.arguments,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        arguments: settings.arguments,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
          routeName: settings.name,
          arguments: settings.arguments,
          viewToShow: HomeView());

    case ProductDetailRoute:
      return _getPageRoute(
          routeName: settings.name,
          arguments: settings.arguments,
          viewToShow: ProductDetailView());

    case CreateOrderViewRoute:
      return _getPageRoute(
          routeName: settings.name,
          arguments: settings.arguments,
          viewToShow: CreateOrderView());

    case CreateStockViewRoute:
      return _getPageRoute(
          routeName: settings.name,
          arguments: settings.arguments,
          viewToShow: CreateStockView());

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute(
    {String routeName, Widget viewToShow, Object arguments}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        arguments: arguments,
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
