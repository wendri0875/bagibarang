import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/ui/widgets/qty_input.dart';
import 'package:bagi_barang/viewmodels/create_invoice_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CreateInvoiceView extends StatefulWidget {
  CreateInvoiceView({Key key}) : super(key: key);

  @override
  _CreateInvoiceViewState createState() => _CreateInvoiceViewState();
}

class _CreateInvoiceViewState extends State<CreateInvoiceView> {
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
        builder: (context, model, child) {
          var f = new NumberFormat("#,###.#");
          return Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 25),
                  Text("BIKIN NOTA",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "MB",
                        //fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: 10),
                  Text("Customer: ${model.customer?.custname ?? ""}",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "MB",
                        //fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                    child: model.invoicedetails != null
                        ? Scrollbar(
                            child: ListView.builder(
                              itemCount: model.invoicedetails.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SingleInvoiceProduct(
                                  index: index,
                                  //  order: model.orders[index],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text("Total: " + f.format(model.total),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Spacer(),
                        RaisedButton(
                          textColor: Colors.white70,
                          color: Colors.green,
                          onPressed: () {
                            if (!model.busy) model.addInvoice();
                          },
                          child: const Text('ADD INVOICE',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class SingleInvoiceProduct extends ProviderWidget<CreateInvoiceViewModel> {
  final int index;
  //final Order order;
  final Function onDeleteItem;
  final qtyController = TextEditingController();

  SingleInvoiceProduct({Key key, this.index, this.onDeleteItem})
      : super(key: key);

  @override
  Widget build(BuildContext context, CreateInvoiceViewModel model) {
    // qtyController.addListener(() {
    //   //print("Second text field: ${qtyController.text}");

    //   if (qtyController.text != "") {
    //     double _qty = double.tryParse(qtyController.text) ?? 0;
    //     model.updateInvoiceQty(index, _qty);
    //   }
    // });

    var f = new NumberFormat("#,###.#");
    // double price =
    // model.getModelProductVarian(model.orders[index].idprod, model.orders[index].varian)?.price ?? 0;
    //model.getModelProductVarian(model.orders[index].idprod, model.orders[index].varian)?.price ?? 0;
    // debugPrint("price: $price");

    //double qty = double.tryParse(model.orders[index].unshipped.toString()) ?? 0;
    // debugPrint("price: $qty");

    //qtyController.text =f.format(qty);

    // double linettl = price * qty;
    // debugPrint("price: $linettl");

    return Card(
      color: Colors.white70,
      child: Column(
        children: [
          ListTile(
            // leading: IconButton(
            //   icon: Icon(Icons.close),
            //   onPressed: () {
            //     if (onDeleteItem != null) {
            //       onDeleteItem();
            //     }
            //   },
            leading: CachedNetworkImage(
              //imageUrl: model.getModelProduct(model.orders[index].idprod)?.imageUrl ?? "",
              imageUrl: model.invoicedetails[index].imageUrl ?? "",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 12),
              child:
                  //Text(model.getModelProduct(model.orders[index].idprod)?.pname ?? "",
                  Text(model.invoicedetails[index].pname ?? "",
                      style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            subtitle: Text(f.format(model.invoicedetails[index].price ?? 0.0),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                )),

            trailing: Text(f.format(model.invoicedetails[index].linettl ?? 0.0),
                style: TextStyle(fontSize: 15)),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      model.deleteItem(index);
                    }),
                SizedBox(
                  width: 130,
                  child: QtyInput(
                    controller: qtyController,
                    initvalue: model.invoicedetails[index].qty ?? 0.0,
                    onUpdate: (text) {
                      if (text != "") {
                        print("Second text field: $text");
                        double _qty = double.tryParse(text) ?? 0;
                        model.updateInvoiceQty(index, _qty);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
