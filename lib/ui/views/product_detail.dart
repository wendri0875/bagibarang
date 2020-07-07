import 'dart:ui';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/ui/widgets/variant_selector.dart';
import 'package:bagi_barang/viewmodels/product_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class ProductDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    String idprod;
    Variant varian;

    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      idprod = arguments['idprod'];
   //   varian = arguments['varian'];
    }


    return ViewModelProvider<ProductDetailModel>.withConsumer(
      viewModel: ProductDetailModel(),
      onModelReady: (model) => model.listenToProduct(idprod),
      builder: (context, model, child) => DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Color(0xFFf9f9f7),
          body: Stack(
            children: <Widget>[
              Hero(
                tag: idprod,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 73),
                  child: CachedNetworkImage(
                    imageUrl: model.product.imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // child: Image.memory(
                  //   imageFile,
                  //   width: double.infinity,
                  // ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFdad9d5),
                      Color(0xFFdcd9d2).withOpacity(0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.3, 0.5],
                    tileMode: TileMode.clamp,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    height: ScreenUtil().setHeight(480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.product.pname.toUpperCase(),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(54),
                            fontFamily: "MB",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        VariantGridSelector(
                            product: model.product,
                         //   varian: varian
                         ), // masukkan juga label dari argumen bila mau auto show varian
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          model.close();
                        }),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
