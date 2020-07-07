import 'package:bagi_barang/constants/status_invoice.dart';
import 'package:bagi_barang/ui/shared/shared_styles.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/viewmodels/invoice_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_widget.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class InvoiceListView extends StatelessWidget {
  InvoiceListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  String _custid;
    //  String _currAddressid;

    TextEditingController _txtsearchController = TextEditingController();

    return ViewModelProvider<InvoiceListViewModel>.withConsumer(
        viewModel: InvoiceListViewModel(),
        onModelReady: (model) {
          model.listenToInvoices("");
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
                        model.listenToInvoices(val);
                      },
                      decoration: InputDecoration(
                          suffixIcon: _txtsearchController.text.isNotEmpty
                              ? IconButton(
                                  color: Colors.black,
                                  icon: Icon(Icons.clear),
                                  iconSize: 20.0,
                                  onPressed: () {
                                    _txtsearchController.clear();
                                    model.listenToInvoices("");
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      constraints: BoxConstraints(
                          minWidth: 100,
                          maxWidth: 100,
                          minHeight: kMinInteractiveDimension),
                      borderRadius: BorderRadius.circular(50),
                      children: <Widget>[
                        Text("Semua"),
                        Text("Belum Dibayar"),
                        Text("Diproses"),
                        Text("Terkirim"),
                        Text("Selesai"),
                        Text("Batal"),
                      ],
                      isSelected: model.isSelected,
                      onPressed: (int index) {
                        model.selectStatus(index);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: model.invoices != null
                        ? Scrollbar(
                            child: ListView.builder(
                              //   shrinkWrap: true, //ikut singlescrollview saja
                              //    physics:
                              //        NeverScrollableScrollPhysics(), //ikut singlescrollview saja
                              itemCount: model.invoices.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    model.navigateToInvoiceView(
                                        model.invoices[index].invoiceid);
                                  },
                                  child: SingleInvoice(
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

class SingleInvoice extends ProviderWidget<InvoiceListViewModel> {
  // final String custid;
  final int index;
  //final Function onDeleteItem;

  SingleInvoice({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, InvoiceListViewModel model) {
    var f = new NumberFormat("#,###.#");
    final d = new DateFormat('dd MMM yyyy');
    DateTime o = model.invoices[index].date.toDate() ?? null;
    return Card(
      color: Colors.white70,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                color: Colors.green[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(statusNota[model.invoices[index].status])],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.invoices[index].invoiceid,
                    style: headerTextStyle,
                  ),
                  verticalSpaceTiny,
                  Text(d.format(o)),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    model.invoices[index].custname,
                    style: headerTextStyle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    model.invoices[index].addressid ?? "",
                    style: headerTextStyle,
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total ",
                    style: headerTextStyle,
                  ),
                  Text(
                    f.format(model.invoices[index].ttlitem ?? 0) + " Item",
                    style: headerTextStyle,
                  ),
                ],
              ),
            ),
            verticalSpaceTiny,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    f.format(model.invoices[index].total ?? 0.0),
                    style: importantTextStyle,
                  ),
                ),
              ],
            ),
            verticalSpaceTiny,
          ],
        ),
      ),
    );
  }
}
