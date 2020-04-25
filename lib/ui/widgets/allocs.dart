import 'package:bagi_barang/models/alloc.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/widgets/busy_button.dart';
import 'package:bagi_barang/ui/widgets/input_field.dart';
import 'package:bagi_barang/viewmodels/create_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_widget.dart';

class Allocs extends ProviderWidget<CreateOrderViewModel> {
  final String idprod;
  final String label;
  final String orderid;
//  final Variant varian;

  Allocs({Key key, this.idprod, this.label, this.orderid}) : super(key: key);

  @override
  Widget build(BuildContext context, CreateOrderViewModel model) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            model.orderallocs != null
                ? Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: model.orderallocs.length,
                        itemBuilder: (BuildContext context, int index) {
                          //Order order = Order.fromSnapshot(
                          //  snapshot.data.documents[index]);

                          return GestureDetector(
                              onTap: ()
                                  //    model.navigateToEditOrder(idprod, label, index),

                                  {
                                var f = new NumberFormat("#.#");

                                TextEditingController customController =
                                    TextEditingController();
                                customController.text =
                                    f.format(model.orderallocs[index].qty);

                                String allocid =
                                    model.orderallocs[index].allocid;
                                model
                                    .setEdittingAlloc(model.orderallocs[index]);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      //  model.setValidationMessage("");
                                      return AlertDialog(
                                        title: Text("Jumlah Alokasi"),
                                        content: Container(
                                          height: 85,
                                          child: InputField(
                                            controller: customController,
                                            placeholder: "Alokasi",
                                            textInputType: TextInputType.number,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Cancel'),
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                          ),
                                          FlatButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                //Navigator.of(context).pop(customController.text.toString());

                                                // debugPrint(
                                                //     "ttlstock = ${model.ttlstock}");
                                                // debugPrint(
                                                //     "ttlallocs = ${model.ttlallocs}");
                                                // debugPrint(
                                                //     "ttlorderallocs = ${model.ttlorderallocs}");

                                                // double allocable = model
                                                //         .ttlstock -
                                                //     (model.ttlallocs -
                                                //         model.ttlorderallocs +
                                                //         double.tryParse(
                                                //             customController
                                                //                 .text));
                                                // if (allocable >=
                                                //     double.tryParse(
                                                //         customController
                                                //             .text)) {

                                                Navigator.of(context).pop();
                                                model.addAllocation(
                                                    idprod: idprod,
                                                    label: label,
                                                    allocid: allocid,
                                                    orderid: orderid,
                                                    qty: double.tryParse(
                                                        customController.text));
                                                //
                                                // } else {

                                                // }

                                                //_navigationService.pop();
                                              }),
                                        ],
                                      );
                                    });
                              },
                              child: SingleAlloc(
                                alloc: model.orderallocs[index],
                                onDeleteItem: () => model.deleteAlloc(
                                    idprod, label, orderid, index),
                              ));
                        },
                      ),
                    ),
                  )
                : Center(child: Text("Kosong")
                    //  child: CircularProgressIndicator(
                    //     valueColor: AlwaysStoppedAnimation(
                    //         Theme.of(context).primaryColor),
                    //),
                    ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "Total: " + model.ttlorderallocs.toInt().toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            verticalSpaceMedium
          ],
        ),
      ),
    ); //);
  }
  //    return Container();

}
//  },
//  );
// });
// }
//}

class SingleAlloc extends StatefulWidget {
  final Alloc alloc;
  final Function onDeleteItem;

  const SingleAlloc({Key key, this.alloc, this.onDeleteItem}) : super(key: key);

  @override
  _SingleAllocState createState() => _SingleAllocState();
}

class _SingleAllocState extends State<SingleAlloc> {
  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("#,###.#");
    var qty = widget.alloc.qty == null ? "" : f.format(widget.alloc.qty);

    return Card(
      color: Colors.white70,
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            if (widget.onDeleteItem != null) {
              widget.onDeleteItem();
            }
          },
        ),
        title: Text(widget.alloc.date),
        // subtitle: Text(widget.order.orderdate),
        trailing: Text(qty,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
