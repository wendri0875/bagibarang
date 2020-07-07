import 'package:bagi_barang/models/billable.dart';
import 'package:bagi_barang/viewmodels/billables_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';



class BillablesView extends StatelessWidget {
  BillablesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BillablesModel>.withConsumer(
        viewModel: BillablesModel(),
        onModelReady: (model) => model.listenToGroupedBillables(),
        builder: (context, model, child) => Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("CARTS",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "MB",
                        //fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: 10),
                  Expanded(
                    child: model.billables != null
                        ? Scrollbar(
                            child: ListView.builder(
                              itemCount: model.billables.length,
                              itemBuilder: (BuildContext context, int index) {
                                //Order order = Order.fromSnapshot(
                                //  snapshot.data.documents[index]);
                                return GestureDetector(
                                  onTap: () =>
                                        model.navigateToCartDetail(index),
                                      //_showModalBottomSheet(context,
                                         // model.billables[index].custid),
                                  child: SingleBillable(
                                    billable: model.billables[index],
                                    // onDeleteItem: () =>
                                    //     model.deleteStock(idprod, label, index),
                                  ),
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 5),
                  //   child: Row(
                  //     children: <Widget>[
                  //       Text("Total: ",
                  //           style: TextStyle(
                  //               fontSize: 20, fontWeight: FontWeight.bold)),
                  //       Text(model.ttlstock.toInt().toString(),
                  //           style: TextStyle(
                  //               fontSize: 20, fontWeight: FontWeight.bold)),
                  //       Spacer(),
                  //       RaisedButton(
                  //         textColor: Colors.white70,
                  //         color: Colors.green,
                  //         onPressed: (() => {
                  //               model.navigateToCartDetail(
                  //                   idprod, label, model.ttlallocs)
                  //             }),
                  //         child: const Text('ADD STOCK',
                  //             style: TextStyle(fontSize: 20)),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )); //);
  }
  //    return Container();

}
//  },
//  );
// });
// }
//}

// void _showModalBottomSheet(context, String custid) {
//   showModalBottomSheet(
//       // shape: RoundedRectangleBorder(
//       //   borderRadius: BorderRadius.circular(10.0),
//       // ),
//       backgroundColor: Colors.transparent,
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return CreateInvoiceView(custid);
//       });
// }

class SingleBillable extends StatefulWidget {
  final Billable billable;
  //final Function onDeleteItem;

  const SingleBillable({Key key, this.billable}) : super(key: key);

  @override
  _SingleBillableState createState() => _SingleBillableState();
}

class _SingleBillableState extends State<SingleBillable> {
  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("#,###.#");
    var qty = widget.billable.ttlitem == null
        ? ""
        : f.format(widget.billable.ttlitem);

    return Card(
      color: Colors.white70,
      child: ListTile(
        // leading: IconButton(
        //   icon: Icon(Icons.close),
        //   onPressed: () {
        //     if (widget.onDeleteItem != null) {
        //       widget.onDeleteItem();
        //     }
        //   },
        // ),
        title: Text(widget.billable.custid,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        // subtitle: Text(widget.stock.stockdate),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(qty,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Items")
          ],
        ),
      ),
    );
  }
}
