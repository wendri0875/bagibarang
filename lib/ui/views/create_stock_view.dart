import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/models/stock.dart';
import 'package:bagi_barang/ui/shared/shared_styles.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/widgets/busy_button.dart';
import 'package:bagi_barang/ui/widgets/input_field.dart';
import 'package:bagi_barang/viewmodels/create_order_view_model.dart';
import 'package:bagi_barang/viewmodels/create_stock_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CreateStockView extends StatelessWidget {
  final noteController = TextEditingController();
  final qtyController = TextEditingController();

  CreateStockView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stock edittingStock;
    String idprod;
    String label;
    String stockid;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      idprod = arguments['idprod'];
      label = arguments['label'];
      edittingStock = arguments['edittingStock'];
    }

    return ViewModelProvider<CreateStockViewModel>.withConsumer(
      viewModel: CreateStockViewModel(),
      onModelReady: (model) {
        // update the text in the controller

        if (edittingStock != null) {
          noteController.text = edittingStock?.note ?? '';
          qtyController.text = edittingStock?.qty.toString() ?? '';
          stockid = edittingStock?.stockid ?? '';
        }

        // set the editting post
        model.setEdittingStock(edittingStock);
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
          //       model.addStock(
          //           stockid: stockid,
          //           idprod: idprod,
          //           label: label,
          //           note: noteController.text,
          //           qty: double.tryParse(qtyController.text));
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
                  'Stock',
                  style: TextStyle(fontSize: 26),
                ),
                BusyButton(
                  child: Text(
                    "✅",
                    style: buttonTitleTextStyle,
                  ),

                  busy: model.busy,
                  // child: !model.busy
                  //     ? Icon(Icons.check)
                  //     : CircularProgressIndicator(
                  //         valueColor: AlwaysStoppedAnimation(Colors.white),
                  //       ),
                  onPressed: () {
                    if (!model.busy)
                      model.addStock(
                          stockid: stockid,
                          idprod: idprod,
                          label: label,
                          note: noteController.text,
                          qty: double.tryParse(qtyController.text));
                  },
                )
              ],
            ),
            verticalSpaceMedium,
            Text('Note'),
            verticalSpaceSmall,
            InputField(
              placeholder: 'Note',
              controller: noteController,
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
          ],
        ),
      )),
    );
  }
}
