import 'package:flutter/material.dart';

class CheckBoxStateFul extends StatefulWidget {
  final ValueChanged<bool> onCheckBoxChanged;

  final bool value;

  CheckBoxStateFul({Key key, this.onCheckBoxChanged, this.value})
      : super(key: key);

  @override
  _CheckBoxStateFulState createState() => _CheckBoxStateFulState();
}

class _CheckBoxStateFulState extends State<CheckBoxStateFul> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) _checked = widget.value;

    return Checkbox(
      value: _checked,
      //title: Text(widget.checkBoxTitle),
      onChanged: (value) {
        setState(() {
          _checked = value;
          widget.onCheckBoxChanged(value);
        });
      },
    );
  }
}
