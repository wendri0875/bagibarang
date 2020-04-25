import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/ui/widgets/varian_detail.dart';

import 'package:bagi_barang/viewmodels/variant_model.dart';
import 'package:flutter/material.dart';
import 'package:grid_selector/base_grid_selector_item.dart';
import 'package:grid_selector/grid_selector.dart';
import 'package:grid_selector/grid_selector_item.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class VariantGridSelector extends StatelessWidget {
  final Product product;

  VariantGridSelector({
    this.product,
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    //   VarianProvider varianpfd = Provider.of<VarianProvider>(context);

    return ViewModelProvider<VariantModel>.withConsumer(
        viewModel: VariantModel(),
        onModelReady: (model) => model.listenToVariant(product.idprod),
        builder: (context, model, child) => GridSelector<int>(
              title: "SIZE",
              items: _getVariant(model.variant),
              onSelectionChanged: (option) {
                Variant varian = model.variant.firstWhere(
                    (vari) => vari.no == option,
                    orElse: () => null);
                //  print(varian.label);
                _showModalBottomSheet(context, product, varian);
              },
              emptyView: Container(child: Text("No Varian")),
            ));
  }

  List<BaseGridSelectorItem> _getVariant(List documents) {

    List<BaseGridSelectorItem> x=  documents != null
        ? documents
            .map((e) => BaseGridSelectorItem(
                key: e.no, label: e.label))
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
