import 'package:bagi_barang/locator.dart';
import 'package:bagi_barang/models/dialog_models.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/widgets/checkbox_stateful.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    var isFieldOne = request.fieldOneTitle != null;
    var isFieldTwo = request.fieldTwoTitle != null;
    var isFieldThree = request.fieldThreeTitle != null;
    var isCheckBox = request.checkBoxTitle != null;
    var isError = request.isError ?? false;

    var fieldOneController = TextEditingController();
    var fieldTwoController = TextEditingController();
    var fieldThreeController = TextEditingController();

    var checkBoxController = false;

    Alert(
      context: context,
      type: isError ? AlertType.error : AlertType.info,
      title: request.title,
      desc: request.description,
      content: Column(
        children: <Widget>[
          if (isFieldOne)
            TextField(
              controller: fieldOneController,
              decoration: InputDecoration(
                //  icon: Icon(Icons.account_circle),
                labelText: request.fieldOneTitle,
              ),
            ),
          verticalSpaceSmall,
          if (isFieldTwo)
            TextField(
              controller: fieldTwoController,
              //   obscureText: true,
              decoration: InputDecoration(
                //  icon: Icon(Icons.lock),
                labelText: request.fieldTwoTitle,
              ),
            ),
          verticalSpaceSmall,
          if (isFieldThree)
            TextField(
              controller: fieldThreeController,
              //   obscureText: true,
              decoration: InputDecoration(
                //  icon: Icon(Icons.lock),
                labelText: request.fieldThreeTitle,
              ),
            ),
          verticalSpaceSmall,
          if (isCheckBox)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(request.checkBoxTitle),
                CheckBoxStateFul(
                  onCheckBoxChanged: (value) {
                    checkBoxController = value;
                  },
                ),
              ],
            ),
        ],
      ),
      buttons: [
        if (isConfirmationDialog)
          DialogButton(
            child: Text(
              request.cancelTitle,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () =>
                _dialogService.dialogComplete(DialogResponse(confirmed: false)),
            width: 120,
          ),
        DialogButton(
          child: Text(request.buttonTitle,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () {
            _dialogService.dialogComplete(DialogResponse(
                confirmed: true,
                fieldOne: fieldOneController.text ?? "",
                fieldTwo: fieldTwoController.text ?? "",
                fieldThree: fieldThreeController.text ?? "",
                checkBox: checkBoxController));
          },
        ),
      ],
    ).show();
  }
}
