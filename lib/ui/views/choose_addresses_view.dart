import 'package:bagi_barang/ui/shared/shared_styles.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/viewmodels/choose_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_widget.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class ChooseAddressView extends StatelessWidget {
  ChooseAddressView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _custid;
    String _currAddressid;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      _custid = arguments['custid'];
      _currAddressid = arguments['currAddressid'];
    }

    return ViewModelProvider<ChooseAddressViewModel>.withConsumer(
        viewModel: ChooseAddressViewModel(),
        onModelReady: (model) {
          model.listenToAddresses(_custid, _currAddressid);
        },
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text("Alamat Pengiriman"),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: model.addresses != null
                        ? Scrollbar(
                            child: ListView.builder(
                              //   shrinkWrap: true, //ikut singlescrollview saja
                              //    physics:
                              //        NeverScrollableScrollPhysics(), //ikut singlescrollview saja
                              itemCount: model.addresses.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SingleAddress(
                                  _custid,
                                  index: index,
                                  // onDeleteItem: () =>
                                  //     model.deleteStock(idprod, label, index),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text('Kosong'),
                          ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlineButton(
                          borderSide:
                              BorderSide(color: Theme.of(context).accentColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            "Tambah Alamat Baru",
                            style: headerTextStyle,
                          ),
                          onPressed: () =>
                              {model.navigateToCreateAddressView(_custid)},
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}

class SingleAddress extends ProviderWidget<ChooseAddressViewModel> {
  final String custid;
  final int index;
  //final Function onDeleteItem;

  SingleAddress(this.custid, {Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, ChooseAddressViewModel model) {
    return Hero(
      tag: model.addresses[index].addressid,
      child: Card(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(model.addresses[index].addressid,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    horizontalSpaceTiny,
                    Text(
                      model.addresses[index]?.deflt ?? false == true
                          ? "Utama"
                          : "",
                      style: importantTextStyle,
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.addresses[index].recipient,
                      style: headerTextStyle,
                    ),
                    Text(model.addresses[index].address),
                    Text(model.addresses[index].phone),
                  ],
                ),
                leading: Radio(
                  value: model.addresses[index],
                  groupValue: model.address,
                  onChanged: (val) {
                    model.choosenAddress(val);
                    model.pop(val);
                  },
                ),
              ),
              Divider(),
              Row(children: [
                Expanded(
                  child: OutlineButton(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                    // shape: StadiumBorder(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "Utamakan",
                      style: headerTextStyle,
                    ),
                    onPressed: model.addresses[index]?.deflt ?? false
                        ? null
                        : () => model.setDefaultAddress(custid, index),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: OutlineButton(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        "Ubah",
                        style: headerTextStyle,
                      ),
                      onPressed: () =>
                          {model.navigateToEditAddress(custid, index)}),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: OutlineButton(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "Hapus",
                      style: headerTextStyle,
                    ),
                    onPressed: () {
                      model.deleteItem(custid, index);
                    },
                  ),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
