import 'dart:io';

import 'package:bagi_barang/locator.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:bagi_barang/services/cloud_storage_service.dart';
import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:bagi_barang/utils/image_selector.dart';
import 'package:bagi_barang/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateProductViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  Product _edittingProduct;

  void setEdittingOrder(Product product) {
    _edittingProduct = product;
  }

  bool get _editting => _edittingProduct != null;

  final ImageSelector _imageSelector = locator<ImageSelector>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  File _selectedImage;
  File get selectedImage => _selectedImage;

  Future selectImage() async {
    var tempImage = await _imageSelector.selectImage();
    if (tempImage != null) {
      _selectedImage = tempImage;
      notifyListeners();
    }
  }

  Future addProduct(
      {String idprod,
      @required String pdesc,
      @required String pname,
      @required double pricestd,
      @required double weightstd}) async {
    setBusy(true);

    CloudStorageResult storageResult;
    var result;
    if (!_editting) {
      storageResult = await _cloudStorageService.uploadImage(
          imageToUpload: _selectedImage, pname: pname);

      Timestamp date = Timestamp.fromDate(DateTime.now());

      var product = Product(
          pname: pname,
          pdesc: pdesc,
          pricestd: pricestd,
          weightstd: weightstd,
          imageUrl: storageResult.imageUrl,
          imageFileName: storageResult.imageFileName,
          uploaddate: date);

      result = await _firestoreService.addProduct(product);
    } else {
      result = await _firestoreService.updateProduct(Product(
        pname: pname,
        pdesc: pdesc,
        pricestd: pricestd,
        weightstd: weightstd,
        idprod: _edittingProduct.idprod,
        imageUrl: _edittingProduct.imageUrl,
        imageFileName: _edittingProduct.imageFileName,
      ));
    }
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not add Product',
        description: result,
      );
    } else {
      

      await _dialogService.showDialog(
        title: 'Product successfully Added',
        description: 'Your product has been created',
      );
    }

    if (!_editting) _navigationService.pop();
  }
}
