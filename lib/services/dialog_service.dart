import 'dart:async';

import 'package:bagi_barang/models/dialog_models.dart';
import 'package:flutter/cupertino.dart';

class DialogService {
  GlobalKey<NavigatorState> _dialogNavigationKey = GlobalKey<NavigatorState>();
  Function(DialogRequest) _showDialogListener;
  Completer<DialogResponse> _dialogCompleter;

  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;

  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future<DialogResponse> showDialog(
      {String title,
      String description,
      String buttonTitle = 'Ok',
      bool isError}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
        title: title,
        description: description,
        buttonTitle: buttonTitle,
        isError: isError));
    return _dialogCompleter.future;
  }

  /// Shows a confirmation dialog
  Future<DialogResponse> showConfirmationDialog(
      {String title,
      String description,
      String checkBoxTitle,
      String confirmationTitle = 'Ok',
      String cancelTitle = 'Cancel'}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
        title: title,
        description: description,
        checkBoxTitle: checkBoxTitle,
        buttonTitle: confirmationTitle,
        cancelTitle: cancelTitle));
    return _dialogCompleter.future;
  }

  /// Shows a dialog with a field
  Future<DialogResponse> showOneFieldDialog(
      {String title,
      String description,
      String fieldOneTitle,
      String checkBoxTitle,
      String confirmationTitle = 'Ok',
      String cancelTitle = 'Cancel'}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
        title: title,
        description: description,
        fieldOneTitle: fieldOneTitle,
        checkBoxTitle: checkBoxTitle,
        buttonTitle: confirmationTitle,
        cancelTitle: cancelTitle));
    return _dialogCompleter.future;
  }

  /// Shows a dialog with a field
  Future<DialogResponse> showTwoFieldDialog(
      {String title,
      String description,
      String fieldOneTitle,
      String fieldTwoTitle,
      String fieldThreeTitle,
      String checkBoxTitle,
      String confirmationTitle = 'Ok',
      String cancelTitle = 'Cancel'}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
        title: title,
        description: description,
        fieldOneTitle: fieldOneTitle,
        fieldTwoTitle: fieldTwoTitle,
        fieldThreeTitle: fieldThreeTitle,
        checkBoxTitle: checkBoxTitle,
        buttonTitle: confirmationTitle,
        cancelTitle: cancelTitle));
    return _dialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(DialogResponse response) {
    _dialogNavigationKey.currentState.pop();
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }
}
