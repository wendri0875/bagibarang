import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DialogRequest {
  final String title;
  final String description;
  final String buttonTitle;
  final String cancelTitle;
  final String fieldOneTitle;
  final String fieldTwoTitle;
  final String fieldThreeTitle;
  final String checkBoxTitle;
  final bool isError;

  DialogRequest({
    @required this.title,
    @required this.description,
    @required this.buttonTitle,
    this.cancelTitle,
    this.fieldOneTitle,
    this.fieldTwoTitle,
    this.fieldThreeTitle,
    this.checkBoxTitle,
    this.isError,
  });
}

class DialogResponse {
  final String fieldOne;
  final String fieldTwo;
  final String fieldThree;
  final bool checkBox;
  final bool confirmed;

  DialogResponse({
    this.fieldOne,
    this.fieldTwo,
    this.fieldThree,
    this.checkBox,
    this.confirmed,
  });
}
