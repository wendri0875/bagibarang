import 'package:bagi_barang/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

// Box Decorations

BoxDecoration fieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[200]);

BoxDecoration disabledFieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[100]);

// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding =
    const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
const TextStyle buttonTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20);

const TextStyle headerTextStyle = const TextStyle(fontWeight: FontWeight.bold);

const TextStyle importantTextStyle =
    const TextStyle(fontWeight: FontWeight.bold, color: importantColor);

const TextStyle hiperLinkTextStyle = const TextStyle(
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.bold,
    color: accentColor);

const TextStyle blackBigBoldTextStyle = const TextStyle(
    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20);

const TextStyle redBigBoldTextStyle = const TextStyle(
    fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20);
