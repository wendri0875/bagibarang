import 'package:bagi_barang/constants/status_invoice.dart';
import 'package:bagi_barang/models/detailstatus.dart';
import 'package:bagi_barang/models/invoice.dart';
import 'package:bagi_barang/ui/shared/app_colors.dart';
import 'package:bagi_barang/ui/shared/shared_styles.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/views/detail_status_view.dart';
import 'package:bagi_barang/ui/widgets/busy_button.dart';
import 'package:bagi_barang/ui/widgets/checkbox_stateful.dart';
import 'package:bagi_barang/ui/widgets/input_field.dart';
import 'package:bagi_barang/viewmodels/invoice_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_widget.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class InvoiceView extends StatelessWidget {
  InvoiceView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _invoiceid;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      _invoiceid = arguments['invoiceid'];
    }

    return ViewModelProvider<InvoiceViewModel>.withConsumer(
        viewModel: InvoiceViewModel(),
        onModelReady: (model) {
          model.listenToInvoice(_invoiceid);
        },
        builder: (context, model, child) {
          var f = new NumberFormat("#,###.#");
          final d = new DateFormat('dd MMM yyyy');
          DateTime o = model.invoice.date.toDate() ?? null;
          var invdate = d.format(o);

          return Scaffold(
              appBar: AppBar(
                title: Text("Invoice"),
                actions: [
                  if (model.invoice.status < 2)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BusyButton(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        busy: model.busy,
                        onPressed: () {
                          if (!model.busy) model.delInvoice();
                        },
                      ),
                    ),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Customer",
                              ),
                              Text(
                                model.invoice.custname,
                                style: headerTextStyle,
                              ),
                              Divider(),
                              Text(
                                "Status",
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    statusNota[model.invoice.status],
                                    style: importantTextStyle,
                                  ),
                                  InkWell(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: kMinInteractiveDimension,
                                        height: kMinInteractiveDimension,
                                        child: Text("Detail",
                                            style: hiperLinkTextStyle)),
                                    onTap: () {
                                      model.navigateToDetailStatus(
                                          model.invoice.invoiceid,
                                          model.invoice.status);
                                    },
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tanggal Nota",
                                  ),
                                  Text(
                                    invdate,
                                    style: headerTextStyle,
                                  ),
                                ],
                              ),
                              Divider(),
                              Text("Nota"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(model.invoice.invoiceid,
                                      style: headerTextStyle),
                                  InkWell(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: kMinInteractiveDimension,
                                        height: kMinInteractiveDimension,
                                        child: Text("Cetak",
                                            style: hiperLinkTextStyle)),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                      verticalSpaceSmall,
                      model.invoiceDetails != null
                          ? ListView.builder(
                              shrinkWrap: true, //ikut singlescrollview saja
                              physics:
                                  NeverScrollableScrollPhysics(), //ikut sin
                              itemCount: model.invoiceDetails.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SingleInvoiceDetail(
                                  // _custid,
                                  index: index,
                                  // onDeleteItem: () =>
                                  //     model.deleteStock(idprod, label, index),
                                );
                              },
                            )
                          : Center(child: Text("Kosong")),
                      verticalSpaceSmall,

                      //---DETAIL PENGIRIMAN
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Detail Pengiriman",
                                style: headerTextStyle,
                              ),
                              verticalSpaceSmall,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(width: 150, child: Text("Kurir")),
                                  Text(model.invoice?.courier ?? "")
                                ],
                              ),
                              verticalSpaceTiny,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 150, child: Text("No. Resi")),
                                  Text(model.invoice?.waybill ?? "")
                                ],
                              ),
                              verticalSpaceTiny,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text("Alamat Pengiriman")),
                                  generateAlamatWidget(model.invoice)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

//---------------------INFORMASI PEMBAYARAN-------------
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Informasi Pembayaran",
                                style: headerTextStyle,
                              ),
                              verticalSpaceSmall,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text("Metode Pembayaran")),
                                  Text(
                                    model.invoice?.paymtd ?? "",
                                    style: headerTextStyle,
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: 150,
                                      height: kMinInteractiveDimension,
                                      child: Text("Total Harga")),
                                  Text(f.format(model.invoice?.subtotal ?? 0),
                                      style: blackBigBoldTextStyle)
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: 150,
                                        height: kMinInteractiveDimension,
                                        child: Text("Ongkir",
                                            style: hiperLinkTextStyle)),
                                    onTap: () {
                                      var f = new NumberFormat("#.#");

                                      TextEditingController customController =
                                          TextEditingController();
                                      customController.text =
                                          f.format(model.invoice.postage);

                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Ongkir"),
                                              content: Container(
                                                height: 85,
                                                child: InputField(
                                                  controller: customController,
                                                  placeholder: "Nilai Ongkir",
                                                  textInputType:
                                                      TextInputType.number,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                ),
                                                FlatButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      model.setPostage(
                                                          double.tryParse(
                                                              customController
                                                                  .text));
                                                    }),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: kMinInteractiveDimension,
                                    child: Text(
                                        f.format(model.invoice?.postage ?? 0),
                                        style: blackBigBoldTextStyle),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          width: 150,
                                          height: kMinInteractiveDimension,
                                          child: Text("Koreksi",
                                              style: hiperLinkTextStyle)),
                                      onTap: () {
                                        var f = new NumberFormat("#.#");

                                        TextEditingController customController =
                                            TextEditingController();
                                        customController.text =
                                            f.format(model.invoice.correction);

                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Koreksi"),
                                                content: Container(
                                                  height: 85,
                                                  child: InputField(
                                                    controller:
                                                        customController,
                                                    placeholder:
                                                        "Nilai Koreksi",
                                                    textInputType:
                                                        TextInputType.number,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                  ),
                                                  FlatButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        model.setCorrection(
                                                            double.tryParse(
                                                                customController
                                                                    .text));
                                                      }),
                                                ],
                                              );
                                            });
                                      }),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: kMinInteractiveDimension,
                                    child: Text(
                                        f.format(
                                            model.invoice?.correction ?? 0),
                                        style: blackBigBoldTextStyle),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text("Total Bayar",
                                          style: headerTextStyle)),
                                  Text(f.format(model.invoice?.total ?? 0),
                                      style: redBigBoldTextStyle)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      verticalSpaceMedium,

                      // if (model.invoice.status < 2)
                      //   Container(
                      //     width: double.infinity,
                      //     height: kMinInteractiveDimension,
                      //     child: RaisedButton(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //         //side: BorderSide(color: Colors.red)),
                      //       ),
                      //       child: Text(
                      //         "Hapus",
                      //         style: buttonTitleTextStyle,
                      //       ),
                      //       textColor: Colors.white70,
                      //       color: importantColor,
                      //       onPressed: () {
                      //         model.changeStatus(5);
                      //       },
                      //     ),
                      //   ),
                      // verticalSpaceSmall,
                      if (model.invoice.status < 4)
                        Container(
                          width: double.infinity,
                          height: kMinInteractiveDimension,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              //side: BorderSide(color: Colors.red)),
                            ),
                            child: Text(
                              buttonText[model.invoice.status],
                              style: buttonTitleTextStyle,
                            ),
                            textColor: Colors.white70,
                            color: accentColor,
                            onPressed: () {
                              model.changeStatus(model.invoice.status + 1);
                            },
                          ),
                        )
                    ],
                  ),
                ),
              ));
        });
  }
}

Widget generateAlamatWidget(Invoice invoice) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(invoice.recipient ?? "", style: headerTextStyle),
      Text(invoice.phone ?? "", style: headerTextStyle),
      Text(invoice.address ?? "", style: headerTextStyle),
    ],
  );
}

class SingleInvoiceDetail extends ProviderWidget<InvoiceViewModel> {
  final int index;
  //final Order order;
  final Function onDeleteItem;
  final qtyController = TextEditingController();

  SingleInvoiceDetail({Key key, this.index, this.onDeleteItem})
      : super(key: key);

  @override
  Widget build(BuildContext context, InvoiceViewModel model) {
    var f = new NumberFormat("#,###.#");

    return Card(
      color: Colors.white70,
      child: Column(
        children: [
          ListTile(
            leading: CachedNetworkImage(
              imageUrl: model.invoiceDetails[index].imageUrl ?? "",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 12),
              child:
                  //Text(model.getModelProduct(model.orders[index].idprod)?.pname ?? "",
                  Text(
                      (model.invoiceDetails[index].pname ?? "") +
                          " - " +
                          (model.invoiceDetails[index].varian ?? ""),
                      style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            subtitle: Row(
              children: [
                Text(
                  f.format(model.invoiceDetails[index].qty ?? 0.0),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "x",
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  f.format(model.invoiceDetails[index].price ?? 0.0),
                ),
              ],
            ),
            trailing: Text(f.format(model.invoiceDetails[index].linettl ?? 0.0),
                style: TextStyle(fontSize: 15)),
          ),
          // SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     IconButton(
          //         icon: Icon(Icons.delete),
          //         onPressed: () {
          //           model.deleteItem(index);
          //         }),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Text("Cancel Order"),
          //         CheckBoxStateFul(
          //           value: model.invoiceDetails[index].cancel ?? false,
          //           onCheckBoxChanged: (value) {
          //             model.cancelItem(index, value);
          //           },
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
