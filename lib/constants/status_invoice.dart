import 'package:bagi_barang/ui/shared/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Map<int, String> statusNota = {
  1: "Terbit Nota",
  2: "Diproses",
  3: "Terkirim",
  4: "Selesai",
  5: "Batal"
};

const Map<int, String> buttonText = {
  1: "Sudah dibayar",
  2: "Sudah dikirim",
  3: "Selesai",
};

const Map<int, Icon> statusIcon = {
  1: Icon(
    Icons.receipt,
    color: accentColor,
    size: 32,
  ),
  2: Icon(
    Icons.redeem,
    color: accentColor,
    size: 32,
  ),
  3: Icon(
    Icons.local_shipping,
    color: accentColor,
    size: 32,
  ),
  4: Icon(
    Icons.check_box,
    color: accentColor,
    size: 32,
  ),
  5: Icon(
    Icons.clear,
    color: accentColor,
    size: 32,
  )
};
