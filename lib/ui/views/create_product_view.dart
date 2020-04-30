import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/widgets/input_field.dart';
import 'package:bagi_barang/viewmodels/create_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CreateProductView extends StatelessWidget {
  final pnameController = TextEditingController();
  final pdescController = TextEditingController();
  final weightstdController = TextEditingController();
  final pricestdController = TextEditingController();

  CreateProductView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CreateProductViewModel>.withConsumer(
      viewModel: CreateProductViewModel(),
//      onModelReady: (model) {},

      builder: (context, model, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            child: !model.busy
                ? Icon(Icons.add)
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
            onPressed: () {
              if (!model.busy)
                model.addProduct(
                    pdesc: pdescController.text,
                    pname: pnameController.text,
                    weightstd: double.tryParse(weightstdController.text),
                    pricestd: double.tryParse(pricestdController.text));
            },
            backgroundColor:
                !model.busy ? Theme.of(context).primaryColor : Colors.grey[600],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ListView(
              children: <Widget>[
                verticalSpace(40),
                Text(
                  'Add Product',
                  style: TextStyle(fontSize: 26),
                ),
                verticalSpaceMedium,
                Text('Foto Product'),
                verticalSpaceSmall,
                GestureDetector(
                  // When we tap we call selectImage
                  onTap: () => model.selectImage(),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: model.selectedImage == null
                        ? Text(
                            'Tap to add post image',
                            style: TextStyle(color: Colors.grey[400]),
                          )
                        : // If we have a selected image we want to show it
                        Image.file(model.selectedImage),
                  ),
                ),
                verticalSpaceMedium,
                Text('Nama'),
                verticalSpaceSmall,
                InputField(
                  placeholder: 'Nama',
                  controller: pnameController,
                ),
                verticalSpaceMedium,
                Text('Deskripsi'),
                verticalSpaceSmall,
                InputField(
                  placeholder: 'Deskripsi',
                  controller: pdescController,
                ),
                verticalSpaceMedium,
                Text('Harga Standart'),
                verticalSpaceSmall,
                InputField(
                  textInputType: TextInputType.number,
                  placeholder: 'Harga Standart',
                  controller: pricestdController,
                ),
                verticalSpaceMedium,
                Text('Berat Standart'),
                verticalSpaceSmall,
                InputField(
                  textInputType: TextInputType.number,
                  placeholder: 'Berat Standart',
                  controller: weightstdController,
                ),
              ],
            ),
          )),
    );
  }
}
