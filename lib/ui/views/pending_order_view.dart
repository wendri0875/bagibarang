import 'package:bagi_barang/ui/shared/shared_styles.dart';
import 'package:bagi_barang/viewmodels/pending_order_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_widget.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class PendingOrderView extends StatelessWidget {
  PendingOrderView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  String _custid;
    //  String _currAddressid;

    TextEditingController _txtsearchController = TextEditingController();

    return ViewModelProvider<PendingOrderViewModel>.withConsumer(
        viewModel: PendingOrderViewModel(),
        onModelReady: (model) {
          model.listenToPendingOrders("");
        },
        builder: (context, model, child) => Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _txtsearchController,
                      onChanged: (val) {
                        // initiateSearch(val);
                        model.listenToPendingOrders(val);
                      },
                      decoration: InputDecoration(
                          suffixIcon: _txtsearchController.text.isNotEmpty
                              ? IconButton(
                                  color: Colors.black,
                                  icon: Icon(Icons.clear),
                                  iconSize: 20.0,
                                  onPressed: () {
                                    _txtsearchController.clear();
                                    model.listenToPendingOrders("");
                                  },
                                )
                              : null,
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintText: 'Search by customer',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0))),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: model.orders != null
                        ? Scrollbar(
                            child: ListView.builder(
                              //   shrinkWrap: true, //ikut singlescrollview saja
                              //    physics:
                              //        NeverScrollableScrollPhysics(), //ikut singlescrollview saja
                              itemCount: model.orders.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    model.navigateToProductDetail(
                                        model.orders[index].idprod
                                        //   , model.orders[index].varian
                                        );
                                  },
                                  child: SingleOrder(
                                    // _custid,
                                    index: index,
                                    // onDeleteItem: () =>
                                    //     model.deleteStock(idprod, label, index),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text('Kosong'),
                          ),
                  ),
                ],
              ),
            ));
  }
}

class SingleOrder extends ProviderWidget<PendingOrderViewModel> {
  // final String custid;
  final int index;
  //final Function onDeleteItem;

  SingleOrder({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, PendingOrderViewModel model) {
    var f = new NumberFormat("#,###.#");
    final d = new DateFormat('dd MMM');
    DateTime o = model.orders[index].orderdate.toDate() ?? null;
    var orderdate = d.format(o);
    return Card(
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(model.orders[index].custid ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.orders[index].pname ?? "",
                      style: headerTextStyle,
                    ),
                    Text(
                      model.orders[index].varian ?? "",
                      style: headerTextStyle,
                    ),
                    Text(
                      orderdate,
                    ),
                  ],
                ),
                leading: CachedNetworkImage(
                  imageUrl: model.orders[index].imageUrl ?? "",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                trailing: Text(f.format(model.orders[index].pendingqty ?? 0.0),
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlineButton(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  "Hapus",
                  style: headerTextStyle,
                ),
                onPressed: () {
                  model.deleteItem(index);
                },
              )
            ])
          ],
        ),
      ),
    );
  }
}
