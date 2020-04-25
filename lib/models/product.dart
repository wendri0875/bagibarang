

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String idprod;
 final String image;
  final String pdesc;
  final String pname;
  final double pricestd;
  final Timestamp uploaddate;
  final double weightstd;
  Product({
        this.idprod,
        this.image,
      this.pdesc,
      this.pname,
      this.pricestd,
      this.uploaddate,
      this.weightstd
  });


  Map<String, dynamic> toMap() {
    return {
      'idprod': idprod,
      'image': image,
      'pdesc': pdesc,
      'pname': pname,
      'pricestd': pricestd,
      'uploaddate': uploaddate,
      'weightstd': weightstd,
    };
  }

  static Product fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Product(
    idprod : documentId,
    image : map["image"],
    pdesc : map["pdesc"],
    pname : map["pname"],
    pricestd : map["pricestd"].toDouble(),
    uploaddate : map["uploaddate"],
    weightstd : map["weightstd"].toDouble(),
    );
  }
}

//  class Product {
//   final String idprod;
//  final String image;
//   final String pdesc;
//   final String pname;
//   final double pricestd;
//   final Timestamp uploaddate;
//   final double weightstd;

//   Product(
      // { 
      //   this.idprod,
      //   this.image,
      // this.pdesc,
      // this.pname,
      // this.pricestd,
      // this.uploaddate,
      // this.weightstd
      // });




//   static Product fromMap(Map<String, dynamic> map) {
//     if (map == null) return null;

//     return Product(
//    idprod = map["image"]?.toString() ?? null,
//     image = map["image"]?.toString() ?? null,
//     pdesc = map["pdesc"]?.toString() ?? null,
//     pname = map["pname"]?.toString() ?? null,
//     pricestd = map["pricestd"]?.toDouble() ?? null,
//     uploaddate = map["uploaddate"] ?? null,
//     weightstd = map["weightstd"]?.toDouble() ?? null,
//     );
//   }
//}
