import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QtyInput extends StatelessWidget {
  final TextEditingController controller;
  final double initvalue;
  final Function(String) onUpdate;

  QtyInput({
    @required this.controller,
    @required this.initvalue,
    this.onUpdate,
  });

  final NumberFormat f = new NumberFormat("#,###.#");

  @override
  Widget build(BuildContext context) {
    controller.text = f.format(initvalue);
    return Container(
      child: new Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: 30.0,
              height: 30.0,
              child: new FloatingActionButton(
                elevation: 0,
                mini: true,
                heroTag: null,
                onPressed: () => minus(),
                child: new Icon(
                  const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                  size: 15,
                ),
              ),
            ),
            Expanded(
              child: new TextFormField(
                onEditingComplete: () {
                  double _qty = double.tryParse(controller.text) ?? 0;
                  if (_qty < 1) {
                    _qty=1;
                    controller.text = f.format(_qty);
                    onUpdate(controller.text);
                  }
                },
                decoration:
                    InputDecoration(contentPadding: EdgeInsets.all(10.0)),
                style: TextStyle(fontSize: 20),
                controller: controller,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 30.0,
              height: 30.0,
              child: new FloatingActionButton(
                elevation: 0,
                mini: true,
                heroTag: null,
                onPressed: () => add(),
                child: new Icon(
                  Icons.add,
                  size: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void add() {
    //  setState(() {
    double _qty = double.tryParse(controller.text) ?? 0;
    // if (_qty < initvalue) {
    _qty++;
    controller.text = f.format(_qty);
    onUpdate(controller.text);
    //   }
    //  });
  }

  void minus() {
    //setState(() {
    double _qty = double.tryParse(controller.text) ?? 0;
    if (_qty != 1) {
      _qty--;
      controller.text = f.format(_qty);
      onUpdate(controller.text);
    }
    // });
  }
}
