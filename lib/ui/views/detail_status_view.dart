import 'package:bagi_barang/constants/status_invoice.dart';
import 'package:bagi_barang/ui/shared/app_colors.dart';
import 'package:bagi_barang/ui/shared/shared_styles.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/viewmodels/detail_status_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_widget.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DetailStatusView extends StatelessWidget {
  const DetailStatusView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _invoiceid;
    int _status;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      _invoiceid = arguments['invoiceid'];
      _status = arguments['status'];
    }

    return ViewModelProvider<DetailStatusViewModel>.withConsumer(
        viewModel: DetailStatusViewModel(),
        onModelReady: (model) {
          model.listenToDetailStatus(_invoiceid);
        },
        builder: (context, model, child) {
          final d = new DateFormat('dd MMM yyyy');
          final t = new DateFormat('hh:mm');
          return Scaffold(
              appBar: AppBar(
                title: Text("Detail Status"),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              statusIcon[1],
                              statusIcon[2],
                              statusIcon[3],
                              statusIcon[4]
                            ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              tick1(_status),
                              spacer(),
                              line(),
                              spacer(),
                              tick2(_status),
                              spacer(),
                              line(),
                              spacer(),
                              tick3(_status),
                              spacer(),
                              line(),
                              spacer(),
                              tick4(_status),
                            ],
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceLarge,
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          statusNota[_status],
                          style: headerTextStyle,
                        )),
                    verticalSpaceMedium,
                    Expanded(
                      child: model.detailstatuses != null
                          ? Scrollbar(
                              child: ListView.builder(
                                //   shrinkWrap: true, //ikut singlescrollview saja
                                //    physics:
                                //        NeverScrollableScrollPhysics(), //ikut singlescrollview saja
                                itemCount: model.detailstatuses.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DateTime o = model.detailstatuses[index].date
                                          .toDate() ??
                                      null;
                                  var date = d.format(o);
                                  var time = t.format(o);

                                  return TimelineTile(
                                    isFirst: index == 0 ? true : false,
                                    isLast:
                                        index == model.detailstatuses.length - 1
                                            ? true
                                            : false,
                                    alignment: TimelineAlign.manual,
                                    lineX: 0.3,
                                    indicatorStyle: const IndicatorStyle(
                                      width: 15,
                                      //  color: Colors.purple,
                                      // indicatorY: 0.2,
                                      padding: EdgeInsets.all(8),
                                    ),
                                    rightChild: Container(
                                        padding: EdgeInsets.all(8),
                                        constraints: const BoxConstraints(
                                          minHeight: 120,
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      statusNota[model
                                                          .detailstatuses[index]
                                                          .status],
                                                      style: headerTextStyle,
                                                    ),
                                                    Text(time,
                                                        style: headerTextStyle),
                                                  ]),
                                              verticalSpaceSmall,
                                              Text(model.detailstatuses[index]
                                                      .note ??
                                                  "")
                                            ])),
                                    leftChild: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(date)),
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
        });
  }

  Widget tick(bool isChecked) {
    return isChecked
        ? Icon(
            Icons.check_circle,
            color: accentColor,
          )
        : Icon(
            Icons.radio_button_unchecked,
            color: accentColor,
          );
  }

  Widget tick1(int status) {
    return status > 0 ? tick(true) : tick(false);
  }

  Widget tick2(int status) {
    return status > 1 ? tick(true) : tick(false);
  }

  Widget tick3(int status) {
    return status > 2 ? tick(true) : tick(false);
  }

  Widget tick4(int status) {
    return status > 3 ? tick(true) : tick(false);
  }

  Widget spacer() {
    return Container(
      width: 5.0,
    );
  }

  Widget line() {
    return Container(
      color: accentColor,
      height: 1.0,
      width: 50.0,
    );
  }
}

/*
class SingleAddress extends ProviderWidget<DetailStatusViewModel> {
  final String custid;
  final int index;
  //final Function onDeleteItem;

  SingleAddress(this.custid, {Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, DetailStatusViewModel model) {
    return Hero(
      tag: model.statusdetails[index].status,
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
                      child: Text(model.statusdetails[index].status,
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
*/
