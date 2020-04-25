import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/viewmodels/varian_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_widget.dart';

class Orders extends ProviderWidget<VarianDetailModel> {
  final String idprod;
  final String label;
//  final Variant varian;

  Orders({Key key, this.idprod, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context, VarianDetailModel model) {
    //var totalorderpvd = Provider.of<TotalOrderProvider>(context);

    //return Consumer<VarianProvider>(builder: (context, varianpvd, _) {
    // return StreamBuilder(
    //   stream: Firestore.instance
    //       .collection('companies/Al-Hayya/Products/' +
    //           widget.idprod +
    //           '/Variant/' +
    //           widget.varian.label +
    //           '/Orders')
    //       .orderBy('orderdate', descending: true)
    //       .snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    //     if (!snapshot.hasData)
    //       return const Text('Loading...');
    //     else {
    //       if (snapshot.connectionState == ConnectionState.active &&
    //           snapshot.data.documents.length > 0) {
    //         totalorderpvd.totalOrder = snapshot.data.documents
    //             .fold(0, (prev, next) => prev + next['orderqty'].toDouble());

    return //ViewModelProvider<VarianDetailModel>.withConsumer(
        //viewModel: VarianDetailModel(),
        // onModelReady: (model) => model.listenToOrders(idprod,varian.label),
        //builder: (context, model, child) =>
        Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: model.orders != null
                ? Scrollbar(
                    child: ListView.builder(
                      itemCount: model.orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        //Order order = Order.fromSnapshot(
                        //  snapshot.data.documents[index]);
                        return GestureDetector(
                            onTap: () => model.navigateToEditOrder(
                                idprod,
                                label,
                                index,
                                model.ttlorder,
                                model.ttlstock,
                                model.ttlallocs),
                            child: SingleOrder(
                              order: model.orders[index],
                              onDeleteItem: () =>
                                  model.deleteOrder(idprod, label, index),
                            ));
                      },
                    ),
                  )
                : Center(child: Text("Kosong")
                    //  child: CircularProgressIndicator(
                    //     valueColor: AlwaysStoppedAnimation(
                    //         Theme.of(context).primaryColor),
                    //),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Total: " + model.ttlorder.toInt().toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    // Text("Stock: " + model.ttlstock.toInt().toString(),
                    //     style: TextStyle(
                    //         fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Spacer(),
                RaisedButton(
                  textColor: Colors.white70,
                  color: Colors.green,
                  onPressed: (() => {
                        model.navigateToCreateOrderView(idprod, label,
                            model.ttlorder, model.ttlstock, model.ttlallocs)
                      }),
                  child:
                      const Text('ADD ORDER', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          )
        ],
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

class SingleOrder extends StatefulWidget {
  final Order order;
  final Function onDeleteItem;

  const SingleOrder({Key key, this.order, this.onDeleteItem}) : super(key: key);

  @override
  _SingleOrderState createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {
  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("#,###.#");
    var orderqty =
        widget.order.orderqty == null ? "" : f.format(widget.order.orderqty);

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
        title: Text(widget.order.custid,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(widget.order.orderdate),
        trailing: Container(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(orderqty,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              ((widget.order?.allocated ?? 0)==0)
                  ? SizedBox()
                  : Text("🛒" + f.format(widget.order.allocated),
                      style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
