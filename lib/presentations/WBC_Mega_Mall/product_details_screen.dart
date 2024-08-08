import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/resources/resource.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../models/cart_model.dart';
import '../../models/expanded_category_model.dart';
import '../../widgets/appbarButton.dart';
import 'buy_now_screen.dart';
import 'cart_screen.dart';

class ProductDetailData {
  final int categoryId;
  final ProductList product;

  ProductDetailData({required this.categoryId, required this.product});
}

class ProductDetailScreen extends StatefulWidget {
  static const route = '/Product-Detail';

  final ProductDetailData data;

  const ProductDetailScreen({required this.data, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final controller = PageController();
  int id = 1;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        top: true,
        child: Scaffold(
            backgroundColor: colorWhite,
            appBar: AppBar(
              toolbarHeight: 8.h,
              backgroundColor: colorTransparent,
              elevation: 0,
              leadingWidth: 15.w,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Image.asset(icBack, color: colorText3D3D, width: 6.w)),
              actions: [
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
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        if (state is CartListLoadedState) {
                          return state.cartList.isNotEmpty
                              ? cartDataView(state.cartList)
                              : Container();
                        }
                        return cartItemList.isNotEmpty
                            ? cartDataView(cartItemList)
                            : Container();
                      },
                    )
                  ],
                ),
                SizedBox(width: 5.w)
              ],
            ),
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 60.h,
                        width: 100.w,
                        decoration:
                            BoxDecoration(color: colorWhite, boxShadow: [
                          BoxShadow(
                              color: colorTextBCBC.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 3))
                        ]),
                        child: PageView.builder(
                          controller: controller,
                          itemCount: widget.data.product.img.length,
                          itemBuilder: (_, index) {
                            return Image.network(
                                imgNewBaseUrl +
                                    widget.data.product.img[index].imgPath,
                                fit: BoxFit.contain);
                          },
                        ),
                      ),
                      Positioned(
                          right: 4.w,
                          top: 54.5.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.6.h, horizontal: 2.w),
                            decoration: BoxDecoration(
                                color: colorWhite.withOpacity(0.5),
                                border:
                                    Border.all(color: colorTextBCBC, width: 1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Text(widget.data.product.rate.toString(),
                                    style: textStyle11Bold(colorText3D3D)),
                                SizedBox(width: 1.w),
                                Icon(Icons.star,
                                    size: 4.w, color: colorText7070)
                              ],
                            ),
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: widget.data.product.img.length,
                        effect: WormEffect(
                          dotHeight: 1.7.w,
                          dotWidth: 1.7.w,
                          dotColor: colorTextBCBC,
                          activeDotColor: colorText4747,
                          spacing: 1.2.w,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.data.product.name,
                            style: textStyle14Bold(colorBlack)),
                        SizedBox(
                            height: widget.data.product.description.isNotEmpty
                                ? 0.5.h
                                : 1.5.h),
                        if (widget.data.product.description.isNotEmpty)
                          Text(widget.data.product.description,
                              style: textStyle12(colorText7070)),
                        if (widget.data.product.description.isNotEmpty)
                          SizedBox(height: 1.5.h),
                        Row(
                          children: [
                            Image.asset(icGoldCoin, width: 4.w),
                            SizedBox(width: 1.w),
                            Text(
                                '${widget.data.product.price.toInt() - ((widget.data.product.price.toInt() * widget.data.product.discount) ~/ 100).toInt()}GP',
                                style: textStyle11Bold(colorTextFFC1)),
                            SizedBox(width: 2.w),
                            Image.asset(icGoldCoin, width: 4.w),
                            SizedBox(width: 1.w),
                            Text('${widget.data.product.price.toInt()}GP',
                                style: textStyle11(colorText7070).copyWith(
                                    decoration: TextDecoration.lineThrough)),
                            SizedBox(width: 2.w),
                            Text('(${widget.data.product.discount}% off)',
                                style: textStyle10(colorGreen)),
                          ],
                        ),
                        SizedBox(height: 1.5.h),
                        if (widget.data.product.availableQty == 0)
                          Text('Out of Stock',
                              style: textStyle10Medium(colorRed)),
                        if (widget.data.product.availableQty > 0)
                          Text(
                              widget.data.product.availableQty > 4
                                  ? 'in Stock'
                                  : 'only ${widget.data.product.availableQty} item in Stock',
                              style: textStyle10Medium(colorRed)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Stack(
              children: [
                Container(
                  height: 8.h,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: colorTextBCBC.withOpacity(0.3),
                      offset: const Offset(0.0, -3.0),
                      blurRadius: 6.0,
                    )
                  ]),
                ),
                Container(
                  height: 8.h,
                  color: colorWhite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          if (state is CartListLoadedState) {
                            return addToCartButton(state.cartList);
                          }
                          return addToCartButton(cartItemList);
                        },
                      ),
                      Container(
                          height: 9.h,
                          width: 1,
                          color: colorText7070.withOpacity(0.3)),
                      GestureDetector(
                        onTap: () async {
                          if (widget.data.product.availableQty > 0) {
                            Navigator.of(context).pushNamed(BuyNowScreen.route,
                                arguments: BuyNowData(
                                    quantity: 1, product: widget.data.product));
                          } else {}
                        },
                        child: Container(
                            width: 50.w - 0.5,
                            color: colorWhite,
                            alignment: Alignment.center,
                            child: Text('BUY NOW',
                                style: textStyle11Bold(colorBlack))),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  cartDataView(List<CartItem> cartList) {
    return Positioned(
      right: 0,
      top: 1.h,
      child: Container(
        height: 3.h,
        width: 3.w,
        decoration:
            const BoxDecoration(color: colorRed, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: FittedBox(
          child: Text(
            cartList.length.toString(),
            textAlign: TextAlign.center,
            style: textStyle6Bold(colorWhite),
          ),
        ),
      ),
    );
  }

  addToCartButton(List<CartItem> cartList) {
    print('-----cartList-=22=----$cartList-----${widget.data.product.id}');
    if (cartList.isNotEmpty) {
      bool isContain = false;
      for (int i = 0; i < cartList.length; i++) {
        print(
            '--match--product--id---${widget.data.product.id}--==--${cartList[i].productId}---x---${widget.data.product.id == cartList[i].productId}');
        if (widget.data.product.id == cartList[i].productId) {
          print(
              '--match---id---${cartList[i].categoryId}--==--${widget.data.categoryId}---x---${cartList[i].categoryId == widget.data.categoryId}');
          if (cartList[i].categoryId == widget.data.categoryId) {
            print('--match--product-name---${cartList[i].name}');
            isContain = true;
            break;
          } else {
            print('--don\'t-match--product-name---${cartList[i].name}');
            isContain = false;
          }
        }
      }
      if (isContain) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(CartScreen.route);
          },
          child: Container(
              width: 50.w - 0.5,
              color: colorWhite,
              alignment: Alignment.center,
              child: Text('GO TO CART', style: textStyle11Bold(colorBlack))),
        );
      } else {
        return GestureDetector(
          onTap: () {
            if (widget.data.product.availableQty > 0) {
              setState(() {
                if (cartList.isNotEmpty) {
                  id = cartList.last.id;
                }
                id = id + 1;
              });
              print('----product--add11---${widget.data.product.name}---$id');
              BlocProvider.of<CartBloc>(context).add(LoadAddCartEvent(
                  cartItem: CartItem(
                id: id,
                categoryId: widget.data.categoryId,
                productId: widget.data.product.id,
                img: widget.data.product.img.first.imgPath,
                name: widget.data.product.name,
                price: widget.data.product.price,
                discount: widget.data.product.discount,
                quantity: 1,
              )));
              BlocProvider.of<CartBloc>(context).add(LoadCartListEvent());
            } else {}
          },
          child: Container(
              width: 50.w - 0.5,
              color: colorWhite,
              alignment: Alignment.center,
              child: Text('ADD TO CART', style: textStyle11Bold(colorBlack))),
        );
      }
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (cartList.isNotEmpty) {
              id = cartList.last.id;
            }
            id = id + 1;
          });
          print('----product--add11---${widget.data.product.name}---$id');
          BlocProvider.of<CartBloc>(context).add(LoadAddCartEvent(
              cartItem: CartItem(
            id: id,
            categoryId: widget.data.categoryId,
            productId: widget.data.product.id,
            img: widget.data.product.img.first.imgPath,
            name: widget.data.product.name,
            price: widget.data.product.price,
            discount: widget.data.product.discount,
            quantity: 1,
          )));
          BlocProvider.of<CartBloc>(context).add(LoadCartListEvent());
        },
        child: Container(
            width: 50.w - 0.5,
            color: colorWhite,
            alignment: Alignment.center,
            child: Text('ADD TO CART', style: textStyle11Bold(colorBlack))),
      );
    }
  }
}
