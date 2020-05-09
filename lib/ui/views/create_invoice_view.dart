import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/viewmodels/billables_model.dart';
import 'package:bagi_barang/viewmodels/create_invoice_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CreateInvoiceView extends StatelessWidget {
  CreateInvoiceView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String custid;
    List<Order> custorders;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      custorders = arguments['custorders'];
    }
    // custorders = model.orders.where((order) => order.custid == custid).toList();

    return ViewModelProvider<CreateInvoiceViewModel>.withConsumer(
        viewModel: CreateInvoiceViewModel(),
        onModelReady: (model) =>
            model.getRefFilledBillableCustOrders(custorders),
        builder: (context, model, child) => Scaffold(
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height:20),
                    Text("BIKIN NOTA",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "MB",
                          //fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: 10),
                    Expanded(
                      child: custorders != null
                          ? Scrollbar(
                              child: ListView.builder(
                                itemCount: custorders.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SingleInvoiceProduct(
                                    order: custorders[index],
                                    // onDeleteItem: () =>
                                    //     model.deleteStock(idprod, label, index),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Text('Kosong'),
                              //  child: CircularProgressIndicator(
                              //     valueColor: AlwaysStoppedAnimation(
                              //         Theme.of(context).primaryColor),
                              //   ),
                            ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

class SingleInvoiceProduct extends ProviderWidget<CreateInvoiceViewModel> {
  final Order order;
  final Function onDeleteItem;

  SingleInvoiceProduct({Key key, this.order, this.onDeleteItem})
      : super(key: key);

  @override
  Widget build(BuildContext context, CreateInvoiceViewModel model) {
    var f = new NumberFormat("#,###.#");
    var orderqty = order.orderqty == null ? "" : f.format(order.orderqty);

    return Card(
      color: Colors.white70,
      child: ListTile(
        // leading: IconButton(
        //   icon: Icon(Icons.close),
        //   onPressed: () {
        //     if (onDeleteItem != null) {
        //       onDeleteItem();
        //     }
        //   },
        leading:CachedNetworkImage(
                    imageUrl: model.getModelProduct(order.idprod)?.imageUrl ?? "",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  
        ),
        title: Text(model.getModelProduct(order.idprod)?.pname ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(
            "Weight: ${model.getModelProductVarian(order.idprod, order.varian)?.weight ?? 0}, Price: ${model.getModelProductVarian(order.idprod, order.varian)?.price ?? 0} "),
        trailing: Container(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(orderqty,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 5,
              ),
              Text(
                  f.format(model
                          .getModelProductVarian(order.idprod, order.varian)
                          ?.price ??
                      0 * order.orderqty),
                  style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
