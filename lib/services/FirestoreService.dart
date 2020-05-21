import 'dart:async';

import 'package:bagi_barang/controls/sprintf.dart';
import 'package:bagi_barang/models/address.dart';
import 'package:bagi_barang/models/alloc.dart';
import 'package:bagi_barang/models/billable.dart';
import 'package:bagi_barang/models/customer.dart';
import 'package:bagi_barang/models/invoice.dart';
import 'package:bagi_barang/models/invoice_detail.dart';
import 'package:bagi_barang/models/order.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/stock.dart';
import 'package:bagi_barang/models/user.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final String _productPath = 'companies/Al-Hayya/Products';

  final String _variantPath = 'companies/Al-Hayya/Products/{{idprod}}/Variant';

  final String _ordersPath =
      'companies/Al-Hayya/Products/{{idprod}}/Variant/{{label}}/Orders';

  final String _allocsPath =
      'companies/Al-Hayya/Products/{{idprod}}/Variant/{{label}}/Orders/{{orderid}}/Allocation';

  final String _stockcardPath =
      'companies/Al-Hayya/Products/{{idprod}}/Variant/{{label}}/StockCard';

  final String _addressesPath =
      'companies/Al-Hayya/Customers/{{custid}}/Addresses';

  final String _invoicesPath =
      'companies/Al-Hayya/Invoices';

final String _invoiceDetailsPath =
      'companies/Al-Hayya/Invoices/{{invoiceid}}/InvoiceDetails';

  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("users");

  final CollectionReference _productsCollectionReference =
      Firestore.instance.collection('companies/Al-Hayya/Products');

  final CollectionReference _customersCollectionReference =
      Firestore.instance.collection('companies/Al-Hayya/Customers');

  final StreamController<List<Product>> _productsController =
      StreamController<List<Product>>.broadcast();

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
      return e.message;
    }
  }

  Future getProduct(String idprod) async {
    try {
      var data = await _productsCollectionReference.document(idprod).get();
      return Product.fromMap(data.data, data.documentID);
    } catch (e) {
      return e.message;
    }
  }

  Future getCustomer(String custid) async {
    try {
      var cust = await _customersCollectionReference.document(custid).get();
      return Customer.fromMap(cust.data, cust.documentID);
      // .then((snapshot) {
      //   if (snapshot != null) {
      //     return Customer.fromMap(snapshot.data, snapshot.documentID);
      //   }
      //   return cust;
      // });
    } catch (e) {
      return e.message;
    }
  }

  Future getAddressList(String custid) async {
    try {
      String s = sprintf(_addressesPath, [custid]);
      final CollectionReference _addressesCollectionReference =
          Firestore.instance.collection(s);
      var addresses =
          _addressesCollectionReference.getDocuments().then((snapshot) {
        return snapshot.documents
            .map((e) => Address.fromMap(e.data, e.documentID))
            .toList();
      });

      return addresses;
    } catch (e) {
      return e.message;
    }
  }

  Future getVarian(String idprod, String varian) async {
    try {
      String s = sprintf(_variantPath, [idprod]);

      final CollectionReference _variantCollectionReference =
          Firestore.instance.collection(s);
      var data = await _variantCollectionReference.document(varian).get();
      return Variant.fromMap(data.data, data.documentID);
    } catch (e) {
      return e.message;
    }
  }

  Stream listenToProductsRealTime() {
    // Register the handler for when the posts data changes
    _productsCollectionReference
        .orderBy('uploaddate', descending: true)
        .snapshots()
        .listen((productsSnapshot) {
      if (productsSnapshot.documents.isNotEmpty) {
        var products = productsSnapshot.documents
            .map((snapshot) {
              return Product.fromMap(snapshot.data, snapshot.documentID);
            })
            .where((mappedItem) => mappedItem.idprod != null)
            .toList();

        // Add the posts onto the controller
        _productsController.add(products);
      }
    });

    // Return the stream underlying our _postsController.
    return _productsController.stream;
  }

  final StreamController<Product> _productController =
      StreamController<Product>.broadcast();

  Stream listenToProductDetailRealTime(String idprod) {
    final DocumentReference _productDocumentReference =
        Firestore.instance.document('companies/Al-Hayya/Products/' + idprod);
    // Register the handler for when the posts data changes
    _productDocumentReference.snapshots().listen((productsSnapshot) {
      if (productsSnapshot.exists) {
        // Add the posts onto the controller
        Product product =
            Product.fromMap(productsSnapshot.data, productsSnapshot.documentID);
        _productController.add(product);
      }
    });

    // Return the stream underlying our _postsController.
    return _productController.stream;
  }

//-----------

  final StreamController<List<Variant>> _variantController =
      StreamController<List<Variant>>.broadcast();

  Stream listenToVariantRealTime(String idprod) {
    // Register the handler for when the posts data changes

    String s = sprintf(_variantPath, [idprod]);

    final CollectionReference _variantCollectionReference =
        Firestore.instance.collection(s);

    _variantCollectionReference
        .orderBy('no')
        .snapshots()
        .listen((variantSnapshot) {
      if (variantSnapshot.documents.isNotEmpty) {
        var variant = variantSnapshot.documents
            .map((snapshot) =>
                Variant.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.label != null)
            .toList();

        // Add the posts onto the controller
        _variantController.add(variant);
      }
    });

    // Return the stream underlying our _postsController.
    return _variantController.stream;
  }

  //-----------

  final StreamController<Variant> _variandetailController =
      StreamController<Variant>.broadcast();

  Stream listenToVarianDocumentRealTime(String idprod, String label) {
    // Register the handler for when the posts data changes

    final DocumentReference _variantDocumentReference = Firestore.instance
        .document(
            'companies/Al-Hayya/Products/' + idprod + '/Variant/' + label);

    _variantDocumentReference.snapshots().listen((variantSnapshot) {
      if (variantSnapshot.exists) {
        // var variant = variantSnapshot.documents
        //     .map((snapshot) =>
        //         Variant.fromMap(snapshot.data, snapshot.documentID))
        //     .where((mappedItem) => mappedItem.label != null)
        //     .toList();

        var variant =
            Variant.fromMap(variantSnapshot.data, variantSnapshot.documentID);

        // Add the posts onto the controller

        _variandetailController.add(variant);
      }
    });

    // Return the stream underlying our _postsController.
    return _variandetailController.stream;
  }

  //-----------

  final StreamController<List<Order>> _ordersController =
      StreamController<List<Order>>.broadcast();

  Stream listenToOrdersRealTime(String idprod, String label) {
    String s = sprintf(_ordersPath, [idprod, label]);
    final CollectionReference _ordersCollectionReference =
        Firestore.instance.collection(s);
    // Register the handler for when the posts data changes
    _ordersCollectionReference
        .orderBy('orderdate', descending: true)
        .snapshots()
        .listen((ordersSnapshot) {
      if (ordersSnapshot.documents.isNotEmpty) {
        var orders = ordersSnapshot.documents
            .map(
                (snapshot) => Order.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.orderid != null)
            .toList();

        // Add the posts onto the controller
        _ordersController.add(orders);
      }
    });

    // Return the stream underlying our _postsController.
    return _ordersController.stream;
  }

  //-----------

  final StreamController<List<Stock>> _stockController =
      StreamController<List<Stock>>.broadcast();

  Stream listenToStockCardRealTime(String idprod, String label) {
    String s = sprintf(_stockcardPath, [idprod, label]);
    final CollectionReference _stockcardCollectionReference =
        Firestore.instance.collection(s);
    // Register the handler for when the posts data changes
    _stockcardCollectionReference
        .orderBy('stockdate', descending: true)
        .snapshots()
        .listen((stockSnapshot) {
      if (stockSnapshot.documents.isNotEmpty) {
        var stockcard = stockSnapshot.documents
            .map(
                (snapshot) => Stock.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.stockid != null)
            .toList();

        // Add the posts onto the controller
        _stockController.add(stockcard);
      }
    });

    // Return the stream underlying our _postsController.
    return _stockController.stream;
  }

  Future addOrder(String idprod, String label, Order order) async {
    String s = sprintf(_ordersPath, [idprod, label]);

    final CollectionReference _ordersCollectionReference =
        Firestore.instance.collection(s);

    try {
      await _ordersCollectionReference.add(order.toMap());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateOrder(String idprod, String label, Order order) async {
    String s = sprintf(_ordersPath, [idprod, label]);
    final CollectionReference _ordersCollectionReference =
        Firestore.instance.collection(s);

    try {
      await _ordersCollectionReference
          .document(order.orderid)
          .updateData(order.toMap());
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  //----------------------------
  Future deleteOrder(String idprod, String label, String documentId) async {
    String s = sprintf(_ordersPath, [idprod, label]);
    final CollectionReference _ordersCollectionReference =
        Firestore.instance.collection(s);
    await _ordersCollectionReference.document(documentId).delete();
  }

  //---------------------------- INVOICE

  Future addInvoice( Invoice invoice) async {
  
    final CollectionReference _invoicesCollectionReference =
        Firestore.instance.collection(_invoicesPath);

    try {
      var docref = await _invoicesCollectionReference.add(invoice.toMap());
      return docref ;
    } catch (e) {
      return e.toString();
    }
  }

  

    //---------------------------- INVOICE DETAIL

  Future addInvoiceDetail(String invoiceID, InvoiceDetail invoiceDetail) async {
  
         String s = sprintf(_invoiceDetailsPath, [invoiceID]);
    final CollectionReference _invoicesCollectionReference =
        Firestore.instance.collection(s);

    try {
      await _invoicesCollectionReference.add(invoiceDetail.toMap());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  

  //-------------------------------

  Future addProduct(Product product) async {
    // String s = sprintf(_ordersPath, [idprod, label]);

    final CollectionReference _productsCollectionReference =
        Firestore.instance.collection(_productPath);

    try {
      DocumentReference docRef =
          await _productsCollectionReference.add(product.toMap());

      Variant s = Variant(
          label: 'S',
          no: 1,
          price: product.pricestd,
          weight: product.weightstd);
      await addVarian(docRef.documentID, s);

      Variant m = Variant(
          label: 'M',
          no: 2,
          price: product.pricestd,
          weight: product.weightstd);
      await addVarian(docRef.documentID, m);

      Variant l = Variant(
          label: 'L',
          no: 3,
          price: product.pricestd,
          weight: product.weightstd);
      await addVarian(docRef.documentID, l);

      Variant xl = Variant(
          label: 'XL',
          no: 4,
          price: product.pricestd,
          weight: product.weightstd);
      await addVarian(docRef.documentID, xl);

      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateProduct(Product product) async {
    final CollectionReference _ordersCollectionReference =
        Firestore.instance.collection(_productPath);

    try {
      await _ordersCollectionReference
          .document(product.idprod)
          .updateData(product.toMap());
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future deleteProduct(String idprod) async {
    final CollectionReference _ordersCollectionReference =
        Firestore.instance.collection(_productPath);
    await _ordersCollectionReference.document(idprod).delete();
  }

  //----------------------------
  Future addVarian(String idprod, Variant varian) async {
    String s = sprintf(_variantPath, [idprod]);

    final CollectionReference _variantCollectionReference =
        Firestore.instance.collection(s);

    try {
      // add with id
      //await _variantCollectionReference.add(varian.toMap());
      await _variantCollectionReference
          .document(varian.label)
          .setData(varian.toMap());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateVarian(String idprod, Variant varian) async {
    String s = sprintf(_variantPath, [idprod]);
    final CollectionReference _variantCollectionReference =
        Firestore.instance.collection(s);

    try {
      await _variantCollectionReference
          .document(varian.label)
          .updateData(varian.toMap());
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future deleteVarian(String idprod, String documentId) async {
    String s = sprintf(_variantPath, [idprod]);
    final CollectionReference _variantCollectionReference =
        Firestore.instance.collection(s);
    try {
      await _variantCollectionReference.document(documentId).delete();
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  //----------------------------
  Future deleteStock(String idprod, String label, String documentId) async {
    String s = sprintf(_stockcardPath, [idprod, label]);
    final CollectionReference _stockcardCollectionReference =
        Firestore.instance.collection(s);
    await _stockcardCollectionReference.document(documentId).delete();
  }

  //----------------------------
  Future addStock(String idprod, String label, Stock stock) async {
    String s = sprintf(_stockcardPath, [idprod, label]);

    final CollectionReference _stockcardCollectionReference =
        Firestore.instance.collection(s);

    try {
      await _stockcardCollectionReference.add(stock.toMap());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  //----------------------------
  Future updateStock(String idprod, String label, Stock stock) async {
    String s = sprintf(_stockcardPath, [idprod, label]);
    final CollectionReference _stockcardCollectionReference =
        Firestore.instance.collection(s);

    try {
      await _stockcardCollectionReference
          .document(stock.stockid)
          .updateData(stock.toMap());
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  //-----------------------
  Future addAlloc(
      String idprod, String label, String orderid, Alloc alloc) async {
    String s = sprintf(_allocsPath, [idprod, label, orderid]);

    final CollectionReference _allocsCollectionReference =
        Firestore.instance.collection(s);

    try {
      await _allocsCollectionReference.add(alloc.toMap());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateAlloc(
      String idprod, String label, String orderid, Alloc alloc) async {
    String s = sprintf(_allocsPath, [idprod, label, orderid]);
    final CollectionReference _allocsCollectionReference =
        Firestore.instance.collection(s);

    try {
      await _allocsCollectionReference
          .document(alloc.allocid)
          .updateData(alloc.toMap());
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  //----------------------------
  Future deleteAlloc(
      String idprod, String label, String orderid, String documentId) async {
    String s = sprintf(_allocsPath, [idprod, label, orderid]);
    final CollectionReference _allocsCollectionReference =
        Firestore.instance.collection(s);
    await _allocsCollectionReference.document(documentId).delete();
  }

  //-----------

  final StreamController<List<Alloc>> _allocsController =
      StreamController<List<Alloc>>.broadcast();

  Stream listenToAllocsRealTime(String idprod, String label, String orderid) {
    String s = sprintf(_allocsPath, [idprod, label, orderid]);
    final CollectionReference _allocsCollectionReference =
        Firestore.instance.collection(s);
    // Register the handler for when the posts data changes
    _allocsCollectionReference
        .orderBy('date', descending: true)
        .snapshots()
        .listen((allocsSnapshot) {
      //  if (allocsSnapshot.documents.isNotEmpty) {
      var allocs = allocsSnapshot.documents
          .map((snapshot) => Alloc.fromMap(snapshot.data, snapshot.documentID))
          .where((mappedItem) => mappedItem.allocid != null)
          .toList();

      // Add the posts onto the controller
      _allocsController.add(allocs);
      // }
    }
            // Return the stream underlying our _postsController.

            );

    return _allocsController.stream;
  }

  //-----------

  final StreamController<List<Order>> _billablesController =
      StreamController<List<Order>>.broadcast();

  Stream listenToBillablesRealTime({custid}) {
    var _billablesCollectionReference =
        Firestore.instance.collectionGroup('Orders');
    // Register the handler for when the posts data changes

    Query query = _billablesCollectionReference
        .where('unshipped', isGreaterThan: 0)
        .where("idcompany", isEqualTo: "Al-Hayya");

    // if (custid != null && custid.isNotEmpty) {
    //   query = query.where('custid', isEqualTo: custid);
    // }
    query.snapshots().listen((snapshot) async {
      var orders = snapshot.documents
          .map((snapshot) => Order.fromMap(snapshot.data, snapshot.documentID))
          .toList();

      // for (int i = 0; i < orders.length; ++i) {
      //   CollectionReference _collectionReference;

      //   //get product ref
      //   _collectionReference = Firestore.instance.collection(_productPath);
      //   await _collectionReference.document(orders[i].idprod).get().then(
      //       (snapshot) => orders[i].pname =
      //           Product.fromMap(snapshot.data, snapshot.documentID).pname);
      //   //get varian ref
      //   String s =
      //       sprintf(_variantPath, [orders[i].idprod]);
      //   _collectionReference = Firestore.instance.collection(s);
      //  await _collectionReference.document(orders[i].varian).get().then((snapshot) {
      //     Variant varian = Variant.fromMap(snapshot.data, snapshot.documentID);
      //     orders[i].price = varian.price;
      //     orders[i].weight = varian.weight;
      //   });
      // }

      _billablesController.add(orders);
    }
        // }
        // Return the stream underlying our _postsController.

        );

    return _billablesController.stream;
  }
}
