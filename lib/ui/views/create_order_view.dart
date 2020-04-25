import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/widgets/allocs.dart';
import 'package:bagi_barang/ui/widgets/busy_button.dart';
import 'package:bagi_barang/ui/widgets/input_field.dart';
import 'package:bagi_barang/viewmodels/create_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CreateOrderView extends StatelessWidget {
  final customerController = TextEditingController();
  final qtyController = TextEditingController();

  CreateOrderView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Order edittingOrder;
    String idprod;
    String label;
    String orderid;
    double ttlorder;
    double ttlallocs;
    double ttlstock;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      idprod = arguments['idprod'];
      label = arguments['label'];
      edittingOrder = arguments['edittingOrder'];
      ttlorder = arguments['ttlorder'];
      ttlallocs = arguments['ttlallocs'];
      ttlstock = arguments['ttlstock'];
    }

    return ViewModelProvider<CreateOrderViewModel>.withConsumer(
      viewModel: CreateOrderViewModel(),
      onModelReady: (model) {
         var f = new NumberFormat("#,###.#");
        // update the text in the controller
        customerController.text = edittingOrder?.custid ?? '';

        orderid = edittingOrder?.orderid ?? '';

        // set the editting post
        model.setEdittingOrder(edittingOrder);
        if (edittingOrder != null) {
          qtyController.text = f.format(edittingOrder.orderqty);
          model.listenToOrderAllocs(idprod, label, orderid);
        }

        //set all data total
        model.setTtlOrder(ttlorder);
        model.setTtlallocs(ttlallocs);
        model.setTtlStock(ttlstock);
      },
      builder: (context, model, child) => Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   child: !model.busy
          //       ? Icon(Icons.add)
          //       : CircularProgressIndicator(
          //           valueColor: AlwaysStoppedAnimation(Colors.white),
          //         ),
          //   onPressed: () {
          //     if (!model.busy)
          //       model.addOrder(
          //           orderid: orderid,
          //           idprod: idprod,
          //           label: label,
          //           custid: customerController.text,
          //           orderqty: double.tryParse(qtyController.text));
          //   },
          //   backgroundColor:
          //       !model.busy ? Theme.of(context).primaryColor : Colors.grey[600],
          // ),
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            verticalSpace(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Order',
                  style: TextStyle(fontSize: 26),
                ),
                BusyButton(
                  title: "✅",
                  busy: model.busy,
                  onPressed: () {
                    if (!model.busy)
                      model.addOrder(
                          orderid: orderid,
                          idprod: idprod,
                          label: label,
                          custid: customerController.text,
                          orderqty: double.tryParse(qtyController.text));
                  },
                )
              ],
            ),
            verticalSpaceMedium,
            Text('Customer'),
            verticalSpaceSmall,
            InputField(
              placeholder: 'Customer',
              controller: customerController,
            ),
            verticalSpaceMedium,
            Text('Quantity'),
            verticalSpaceSmall,
            InputField(
              textInputType: TextInputType.number,
              placeholder: 'Quantity',
              controller: qtyController,
            ),

            // Container(
            //   height: 250,
            //   decoration: BoxDecoration(
            //       color: Colors.grey[200],
            //       borderRadius: BorderRadius.circular(10)),
            //   alignment: Alignment.center,
            //   child: Text(
            //     'Tap to add post image',
            //     style: TextStyle(color: Colors.grey[400]),
            //   ),
            // )

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Dapat Barang',
                  style: TextStyle(fontSize: 26),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    //model.createAlertDialog(idprod,label,orderid,context);
                    model.setEdittingAlloc(null);
                    TextEditingController customController =
                        TextEditingController();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Jumlah Alokasi"),
                            content: Container(
                              height: 65,
                              child: InputField(
                                controller: customController,
                                placeholder: "Alokasi",
                                textInputType: TextInputType.number,
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              FlatButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    //Navigator.of(context).pop(customController.text.toString());
                                    Navigator.of(context).pop();
                                    model.addAllocation(
                                        idprod: idprod,
                                        label: label,
                                        orderid: orderid,
                                        qty: double.tryParse(
                                            customController.text));

                                    //_navigationService.pop();
                                  })
                            ],
                          );
                        });
                  },
                )
              ],
            ),
            Allocs(
              idprod: idprod,
              label: label,
              orderid: orderid,
            ),
          ],
        ),
      )),
    );
  }
}
