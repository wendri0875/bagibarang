import 'package:bagi_barang/models/alloc.dart';
import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/ui/shared/app_colors.dart';
import 'package:bagi_barang/ui/shared/shared_styles.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/widgets/busy_button.dart';
import 'package:bagi_barang/ui/widgets/input_field.dart';
import 'package:bagi_barang/ui/widgets/qty_input.dart';
import 'package:bagi_barang/viewmodels/create_invoice_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CreateInvoiceView extends StatefulWidget {
  CreateInvoiceView({Key key}) : super(key: key);

  @override
  _CreateInvoiceViewState createState() => _CreateInvoiceViewState();
}

class _CreateInvoiceViewState extends State<CreateInvoiceView> {
  final correctionController = TextEditingController();
  final postageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // String custid;
    List<Alloc> custallocs;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      custallocs = arguments['custallocs'];
    }
    // custorders = model.orders.where((order) => order.custid == custid).toList();

    return ViewModelProvider<CreateInvoiceViewModel>.withConsumer(
        viewModel: CreateInvoiceViewModel(),
        onModelReady: (model) =>
            model.getRefFilledBillableCustOrders(custallocs),
        builder: (context, model, child) {
          var f = new NumberFormat("#,###.#");
          return Scaffold(
            appBar: AppBar(
              title: Text("BIKIN NOTA"),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Customer",
                              style: headerTextStyle,
                            ),
                            Divider(),
                            Text(model.customer?.custname ?? "",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "MB",
                                    fontWeight: FontWeight.bold
                                    //fontWeight: FontWeight.bold),
                                    )),
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    model.invoicedetails != null
                        ? ListView.builder(
                            shrinkWrap: true, //ikut singlescrollview saja
                            physics:
                                NeverScrollableScrollPhysics(), //ikut singlescrollview saja
                            itemCount: model.invoicedetails.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SingleInvoiceProduct(
                                index: index,
                                //  order: model.orders[index],
                                // onDeleteItem: () =>
                                //     model.deleteStock(idprod, label, index),
                              );
                            },
                          )
                        : Center(
                            child: Text('Kosong'),
                            //  child: CircularProgressIndicator(
                            //     valueColor: AlwaysStoppedAnimation(
                            //         Theme.of(context).primaryColor),
                            //   ),
                          ),
                    verticalSpaceMedium,
                    Card(
                      // card subtotal
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: headerTextStyle,
                            ),
                            Text(
                              f.format(model.subtotal ?? 0),
                              style: importantTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Hero(
                      tag: model.invoice.addressid ?? "chooseaddress ",
                      child: Card(
                        // card alamat kirim
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Alamat Pengiriman",
                                    style: headerTextStyle,
                                  ),
                                  new InkWell(
                                    onTap: () {
                                      model.navigateToChooseAddress(
                                          model.invoice.custid,
                                          model.invoice.addressid);
                                    },
                                    child: Text("Pilih Alamat Lain",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline)),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    model.invoice.addressid ?? "",
                                    style: headerTextStyle,
                                  ),
                                  horizontalSpaceTiny,
                                  Text(
                                    model.invoice.deflt == true ? "Utama" : "",
                                    style: importantTextStyle,
                                  ),
                                ],
                              ),
                              verticalSpaceSmall,
                              Text(model.invoice.recipient ?? ""),
                              Text(model.invoice.address ?? ""),
                              Text(model.invoice.phone ?? ""),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      // card ongkir
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tambahan",
                              style: headerTextStyle,
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ongkir",
                                  style: headerTextStyle,
                                )
                              ],
                            ),
                            verticalSpaceTiny,
                            InputField(
                              textInputType: TextInputType.number,
                              placeholder: 'Ongkir',
                              controller: postageController,
                              onChanged: (val) {
                                model.setPostage(
                                    double.tryParse(val.replaceAll(",", "")));
                              },
                              formatter: NumericTextFormatter(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Koreksi",
                                  style: headerTextStyle,
                                )
                              ],
                            ),
                            verticalSpaceTiny,
                            InputField(
                              textInputType: TextInputType.number,
                              placeholder: 'Koreksi',
                              controller: correctionController,
                              onChanged: (val) {
                                model.setCorrection(
                                    double.tryParse(val.replaceAll(",", "")));
                              },
                              formatter: NumericTextFormatter(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Total harga:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              verticalSpaceTiny,
                              Text(f.format(model.total),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: importantColor))
                            ],
                          ),
                          Spacer(),
                          ButtonTheme(
                            minWidth: 150,
                            height: 40,
                            child: BusyButton(
                              busy: model.busy,

                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(8.0),
                              //     side: BorderSide(color: Colors.red)),
                              // textColor: Colors.white70,
                              color: importantColor,
                              onPressed: () {
                                if (!model.busy) model.addInvoice();
                              },
                              child: Text('Bikin Nota',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
                  Text(
                      (model.invoicedetails[index].pname ?? "") +
                          " - " +
                          (model.invoicedetails[index].varian ?? ""),
                      style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            subtitle: Text(f.format(model.invoicedetails[index].price ?? 0.0),
                style: TextStyle(
                  color: importantColor,
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

class NumericTextFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = new NumberFormat("#,###");
      int num = int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(num);
      return new TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
