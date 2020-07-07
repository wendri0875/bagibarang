import 'package:bagi_barang/models/address.dart';
import 'package:bagi_barang/ui/shared/shared_styles.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/widgets/busy_button.dart';
import 'package:bagi_barang/ui/widgets/input_field.dart';
import 'package:bagi_barang/viewmodels/create_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CreateAddressView extends StatelessWidget {
  // var addressid;
  // var recipient;
  // var address;
  // var phone;
  // var deflt;
  final addressidController = TextEditingController();
  final recipientController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  CreateAddressView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Address edittingAddress;
    String custid;
    //  bool deflt = false;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      custid = arguments['custid'];
      edittingAddress = arguments['edittingAddress'];
    }

    return ViewModelProvider<CreateAddressViewModel>.withConsumer(
      viewModel: CreateAddressViewModel(),
      onModelReady: (model) {
        // update the text in the controller

        // set the editting post
        model.setEdittingAddress(edittingAddress);

        if (model.edittingAddress != null) {
          addressidController.text = model.edittingAddress?.addressid ?? '';
          recipientController.text = model.edittingAddress?.recipient ?? '';
          addressController.text = model.edittingAddress?.address ?? '';
          phoneController.text = model.edittingAddress?.phone ?? '';
          addressidController.text = model.edittingAddress?.addressid ?? '';
          //   deflt = model.edittingAddress?.deflt ?? false;
        }
      },
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('Address'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: BusyButton(
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
                      model.addAddress(
                        custid: custid,
                        addressid: addressidController.text,
                        recipient: recipientController.text,
                        address: addressController.text,
                        phone: phoneController.text,
                        //    deflt: deflt
                      );
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  verticalSpaceMedium,
                  Text('Nama Alamat'),
                  verticalSpaceTiny,
                  InputField(
                    placeholder: 'Nama Alamat',
                    controller: addressidController,
                    isReadOnly: model.editting ? true : false,
                  ),
                  verticalSpaceSmall,
                  Text('Penerima'),
                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Penerima',
                    controller: recipientController,
                  ),
                  verticalSpaceSmall,
                  Text('Address'),
                  verticalSpaceTiny,
                  InputField(
                    placeholder: 'Address',
                    controller: addressController,
                    noteVersion: true,
                  ),
                  verticalSpaceSmall,
                  Text('Phone'),
                  verticalSpaceTiny,
                  InputField(
                    placeholder: 'Phone',
                    controller: phoneController,
                  ),
                  // verticalSpaceMedium,
                  // Text('Deflt'),
                  // verticalSpaceSmall,
                  // Checkbox(value: deflt, onChanged: (val) => deflt = val),
                ],
              ),
            ),
          )),
    );
  }
}
