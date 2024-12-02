import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/blocs/cart/cart_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/blocs/mall/mall_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/cart_model.dart';
import 'package:wbc_connect_app/models/expanded_category_model.dart';
import 'package:wbc_connect_app/models/newArrival_data_model.dart';
import 'package:wbc_connect_app/models/popular_data_model.dart';
import 'package:wbc_connect_app/models/product_category_model.dart';
import 'package:wbc_connect_app/models/trending_data_model.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/cart_screen.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/product_details_screen.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/wbc_mega_mall.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import 'package:wbc_connect_app/widgets/appbarButton.dart';

class ProductExpandData {
  final String title;
  final List<Product> product;

  ProductExpandData({required this.title, required this.product});
}

class ExpandProductScreen extends StatefulWidget {
  static const route = '/Expand-Product';
  final ProductExpandData product;

  const ExpandProductScreen({super.key, required this.product});

  @override
  State<ExpandProductScreen> createState() => _ExpandProductScreenState();
}

class _ExpandProductScreenState extends State<ExpandProductScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartListLoadedState) {
              return scaffoldWidget(state.cartList);
            }
            return scaffoldWidget(cartItemList);
          },
        ));
  }

  scaffoldWidget(List<CartItem> cartList) {
    return Scaffold(
      backgroundColor: colorBG,
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: colorWhite,
        elevation: 6,
        shadowColor: colorTextBCBC.withOpacity(0.3),
        leadingWidth: 15.w,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(WbcMegaMall.route);
              BlocProvider.of<FetchingDataBloc>(context).add(
                  LoadProductCategoryEvent(
                      productCategory: ProductCategory(
                          code: 0, message: '', categories: [])));
              BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                  popular: Popular(code: 0, message: '', products: []),
                  newArrival: NewArrival(code: 0, message: '', products: []),
                  trending: Trending(code: 0, message: '', products: [])));
            },
            icon: Image.asset(icBack, color: colorRed, width: 6.w)),
        titleSpacing: 0,
        title: Text(widget.product.title, style: textStyle14Bold(colorBlack)),
        actions: [
          AppBarButton(
              splashColor: colorWhite,
              bgColor: colorF3F3,
              icon: icNotification,
              iconColor: colorText7070,
              onClick: () {
                Navigator.of(context).pushNamed(NotificationScreen.route);
              }),
          SizedBox(width: 2.w),
          Stack(
            children: [
              AppBarButton(
                  splashColor: colorWhite,
                  bgColor: colorF3F3,
                  icon: icAddToCart,
                  iconColor: colorText7070,
                  onClick: () {
                    Navigator.of(context).pushNamed(CartScreen.route);
                  }),
              if (cartList.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 1.h,
                  child: Container(
                    height: 3.h,
                    width: 3.w,
                    decoration: const BoxDecoration(
                        color: colorRed, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text(
                        cartList.length.toString(),
                        textAlign: TextAlign.center,
                        style: textStyle6Bold(colorWhite),
                      ),
                    ),
                  ),
                )
            ],
          ),
          SizedBox(width: 2.w),
          AppBarButton(
              splashColor: colorWhite,
              bgColor: colorF3F3,
              icon: icProfile,
              iconColor: colorText7070,
              onClick: () {}),
          SizedBox(width: 5.w)
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed(WbcMegaMall.route);
          BlocProvider.of<FetchingDataBloc>(context).add(
              LoadProductCategoryEvent(
                  productCategory:
                      ProductCategory(code: 0, message: '', categories: [])));
          BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
              popular: Popular(code: 0, message: '', products: []),
              newArrival: NewArrival(code: 0, message: '', products: []),
              trending: Trending(code: 0, message: '', products: [])));
          return false;
        },
        child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
                crossAxisCount: 2),
            itemCount: widget.product.product.length,
            itemBuilder: (context, index) {
              return widget.product.product[index].img.isEmpty
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            ProductDetailScreen.route,
                            arguments: ProductDetailData(
                                categoryId: widget.product.product[index].catId,
                                product: ProductList(
                                    id: widget.product.product[index].id,
                                    name: widget.product.product[index].name,
                                    price: widget.product.product[index].price,
                                    discount:
                                        widget.product.product[index].discount,
                                    availableQty: widget
                                        .product.product[index].availableQty,
                                    description: widget
                                        .product.product[index].description,
                                    rate: widget.product.product[index].rate,
                                    img: widget.product.product[index].img)));
                      },
                      child: Container(
                        height: 125,
                        width: 21.8.w,
                        decoration: decoration(colorWhite),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 19.h,
                                  // width: 30.w,
                                  child: Image.network(
                                    imgNewBaseUrl +
                                        widget.product.product[index].img[0]
                                            .imgPath,
                                    fit: BoxFit.contain,
                                  )),
                                                            SizedBox(height: 1.h),

                              Text(widget.product.product[index].name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle8(colorBlack).copyWith(
                                      fontWeight: FontWeight.w600, height: 1.2)),
                            ],
                          ),
                        ),
                      ));
            }),
      ),
    );
  }

  BoxDecoration decoration(Color bgColor) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          if (bgColor == colorWhite)
            BoxShadow(
                color: colorTextBCBC.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 6))
        ]);
  }
}
