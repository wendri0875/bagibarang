import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/widgets/input_field.dart';
import 'package:bagi_barang/ui/widgets/varian_detail.dart';

import 'package:bagi_barang/viewmodels/variant_model.dart';
import 'package:flutter/material.dart';
import 'package:grid_selector/base_grid_selector_item.dart';
import 'package:grid_selector/grid_selector.dart';

import 'package:provider_architecture/viewmodel_provider.dart';

class VariantGridSelector extends StatelessWidget {
  final Product product;
 // final Variant varian;

  VariantGridSelector({
    this.product,
   // this.varian,
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    //AFTER ALL LOADED EVENT

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (varian != null) {
    //     Navigator.pop(context);
    //     _showModalBottomSheet(context, product, varian);
    //   }
    // });

    return ViewModelProvider<VariantModel>.withConsumer(
        viewModel: VariantModel(),
        onModelReady: (model) => model.listenToVariant(product.idprod),
        builder: (context, model, child) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GridSelector<int>(
                    title: "Varian",
                    items: _getVariant(model.variant),
                    onSelectionChanged: (option) {
                      Variant varian = model.variant.firstWhere(
                          (vari) => vari.no == option,
                          orElse: () => null);
                      //  print(varian.label);
                      _showModalBottomSheet(context, product, varian);
                    },
                    emptyView: Container(child: Text("No Varian")),
                  ),
                  RaisedButton(
                    textColor: Colors.white70,
                    color: Colors.green,
                    onPressed: (() {
                      //     model.setEdittingAlloc(null);
                      TextEditingController noController =
                          TextEditingController();
                      TextEditingController lblController =
                          TextEditingController();

                      int maxno = 1;
                      if (model.variant != null && model.variant.isNotEmpty) {
                        model.variant.sort((a, b) => a.no.compareTo(b.no));
                        maxno = model.variant.last.no;
                      }
                      maxno++;
                      noController.text = maxno.toString();

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Varian"),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('No'),
                                  InputField(
                                    controller: noController,
                                    placeholder: "No",
                                    textInputType: TextInputType.number,
                                    smallVersion: true,
                                  ),
                                  verticalSpaceSmall,
                                  Text('Label'),
                                  InputField(
                                    placeholder: 'Label',
                                    controller: lblController,
                                    smallVersion: true,
                                  ),
                                ],
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
                                      Navigator.of(context).pop();
                                      model.addVarian(
                                          idprod: product.idprod,
                                          no: int.tryParse(noController.text),
                                          label: lblController.text,
                                          price: product.pricestd,
                                          weight: product.weightstd);

                                      //_navigationService.pop();
                                    })
                              ],
                            );
                          });
                    }),
                    child: const Text('ADD VARIAN',
                        style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
            ),
          );
        });
  }

  List<BaseGridSelectorItem> _getVariant(List documents) {
    List<BaseGridSelectorItem> x = documents != null
        ? documents
            .map((e) => BaseGridSelectorItem(key: e.no, label: e.label))
            .toList()
        : [];

    return x;
  }
}

void _showModalBottomSheet(
  context,
  Product product,
  Variant varian,
) {
  showModalBottomSheet(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10.0),
      // ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return VarianDetail(product, varian);
      });
}
