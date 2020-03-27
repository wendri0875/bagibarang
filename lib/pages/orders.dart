import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/provider/totalorderprovider.dart';
import 'package:bagi_barang/provider/varianprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  final idprod;
  final Variant varian;

  Orders({Key key, this.varian, this.idprod}) : super(key: key);
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    var totalorderpvd = Provider.of<TotalOrderProvider>(context);

    //return Consumer<VarianProvider>(builder: (context, varianpvd, _) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('companies/Al-Hayya/Products/' +
              widget.idprod +
              '/Variant/' +
              widget.varian.label +
              '/Orders')
          .orderBy('orderdate', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (!snapshot.hasData)
          return const Text('Loading...');
        else {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data.documents.length > 0) {
            totalorderpvd.totalOrder = snapshot.data.documents
                .fold(0, (prev, next) => prev + next['orderqty'].toDouble());

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          Order order = Order.fromSnapshot(
                              snapshot.data.documents[index]);
                          return SingleOrder(order: order);
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text("Total: ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(totalorderpvd.totalOrder.toInt().toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Spacer(),
                      RaisedButton(
                        textColor: Colors.white70,
                        color: Colors.green,
                        onPressed: (() => {}),
                        child: const Text('ADD ORDER',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
          return Container();
        }
      },
    );
    // });
  }
}

class SingleOrder extends StatefulWidget {
  final Order order;

  const SingleOrder({Key key, this.order}) : super(key: key);

  @override
  _SingleOrderState createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      child: ListTile(
        title: Text(widget.order.custid,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(widget.order.orderdate),
        trailing: Text(widget.order.orderqty,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
