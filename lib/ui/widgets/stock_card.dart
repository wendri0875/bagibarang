import 'package:bagi_barang/models/stock.dart';
import 'package:bagi_barang/viewmodels/varian_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_widget.dart';

class StockCard extends ProviderWidget<VarianDetailModel> {
  final idprod;
  final label;

  StockCard({Key key, this.label, this.idprod}) : super(key: key);

  @override
  Widget build(BuildContext context, VarianDetailModel model) {
    return //ViewModelProvider<VarianDetailModel>.withConsumer(
        //viewModel: VarianDetailModel(),
        // onModelReady: (model) => model.listenToStockCard(idprod,varian.label),
        //builder: (context, model, child) =>
        Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: model.stockcard != null
                ? Scrollbar(
                    child: ListView.builder(
                      itemCount: model.stockcard.length,
                      itemBuilder: (BuildContext context, int index) {
                        //Order order = Order.fromSnapshot(
                        //  snapshot.data.documents[index]);
                        return GestureDetector(
                          onTap: () =>
                              model.navigateToEditStock(idprod, label, index),
                          child: SingleStockCard(
                            stock: model.stockcard[index],
                            onDeleteItem: () =>
                                model.deleteStock(idprod, label, index),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: <Widget>[
                Text("Total: ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(model.ttlstock.toInt().toString(),
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Spacer(),
                RaisedButton(
                  textColor: Colors.white70,
                  color: Colors.green,
                  onPressed: (() =>
                      {model.navigateToCreateStockView(idprod, label,model.ttlallocs)}),
                  child:
                      const Text('ADD STOCK', style: TextStyle(fontSize: 20)),
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

class SingleStockCard extends StatefulWidget {
  final Stock stock;
  final Function onDeleteItem;

  const SingleStockCard({Key key, this.stock, this.onDeleteItem})
      : super(key: key);

  @override
  _SingleStockState createState() => _SingleStockState();
}

class _SingleStockState extends State<SingleStockCard> {
  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("#,###.#");
   var qty = widget.stock.qty==null? "" : f.format(widget.stock.qty);

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
        title: Text(widget.stock.note,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(widget.stock.stockdate),
        trailing: Text(qty,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
