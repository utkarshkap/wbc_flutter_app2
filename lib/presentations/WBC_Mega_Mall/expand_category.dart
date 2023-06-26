import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/blocs/cart/cart_bloc.dart';
import 'package:wbc_connect_app/models/cart_model.dart';
import 'package:wbc_connect_app/models/expanded_category_model.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/product_details_screen.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/wbc_mega_mall.dart';

import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../blocs/mall/mall_bloc.dart';
import '../../common_functions.dart';
import '../../core/api/api_consts.dart';
import '../../models/newArrival_data_model.dart';
import '../../models/popular_data_model.dart';
import '../../models/product_category_model.dart';
import '../../models/trending_data_model.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import 'cart_screen.dart';

class ExpandCategoryData {
  final int categoryId;
  final String categoryName;
  final bool isFromMall;

  ExpandCategoryData({required this.categoryId, required this.categoryName, required this.isFromMall});
}

class ExpandCategory extends StatefulWidget {
  static const route = '/Expand-Category';
  final ExpandCategoryData categoryData;

  const ExpandCategory({super.key, required this.categoryData});

  @override
  State<ExpandCategory> createState() => _ExpandCategoryState();
}

class _ExpandCategoryState extends State<ExpandCategory> {
  int id = 1;
  final TextEditingController _searchController = TextEditingController();
  List<ProductList> productsList = [];
  String filteredItem = '';

  @override
  void initState() {
    if (cartItemList.isNotEmpty) {
      setState(() {
        id = cartItemList.last.id;
      });
    }
    super.initState();
  }

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
      ),
    );
  }

  scaffoldWidget(List<CartItem> cartList) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: colorWhite,
        elevation: 6,
        shadowColor: colorTextBCBC.withOpacity(0.3),
        leadingWidth: 15.w,
        leading: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if(widget.categoryData.isFromMall){
                Navigator.of(context).pushReplacementNamed(WbcMegaMall.route);
                BlocProvider.of<FetchingDataBloc>(context).add(
                    LoadProductCategoryEvent(
                        productCategory: ProductCategory(
                            code: 0, message: '', categories: [])));
                BlocProvider.of<MallBloc>(context).add(
                    LoadMallDataEvent(
                        popular: Popular(code: 0, message: '', products: []),
                        newArrival: NewArrival(code: 0, message: '', products: []),
                        trending:
                        Trending(code: 0, message: '', products: [])));
              }else{
                Navigator.of(context).pop();
              }
            },
            icon: Image.asset(icBack, color: colorRed, width: 6.w)),
        titleSpacing: 0,
        title: Text(widget.categoryData.categoryName,
            style: textStyle13Bold(colorBlack)),
        actions: [
          AppBarButton(
              splashColor: colorWhite,
              bgColor: colorF3F3,
              icon: icNotification,
              iconColor: colorText7070,
              onClick: () {}),
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
        bottom: PreferredSize(
            preferredSize: Size(100.w, 8.h),
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Container(
                height: 6.h,
                width: 92.w,
                decoration: BoxDecoration(
                    color: colorF3F3, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Image.asset(icSearch, width: 5.w),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 3.w),
                        child: TextFormField(
                          controller: _searchController,
                          style: textStyle12(colorText7070),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Search Products Name',
                            hintStyle: textStyle12(colorText7070),
                            fillColor: colorF3F3,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                          onChanged: (val) {
                            filteredItem = val;
                            setState(() {});
                          },
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.of(context).pushReplacementNamed(WbcMegaMall.route);
          BlocProvider.of<FetchingDataBloc>(context).add(
              LoadProductCategoryEvent(
                  productCategory:
                      ProductCategory(code: 0, message: '', categories: [])));
          BlocProvider.of<MallBloc>(context).add(
              LoadMallDataEvent(
                  popular: Popular(code: 0, message: '', products: []),
                  newArrival: NewArrival(code: 0, message: '', products: []),
                  trending:
                  Trending(code: 0, message: '', products: [])));
          return false;
        },
        child: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is ExpandedCategoryErrorState) {
              AwesomeDialog(
                btnCancelColor: colorRed,
                padding: EdgeInsets.zero,
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                headerAnimationLoop: false,
                title: 'Something Went Wrong',
                btnOkOnPress: () {},
                btnOkColor: Colors.red,
              ).show();
            }
          },
          builder: (context, state) {
            if (state is ExpandedCategoryInitial) {
              if (kDebugMode) {
                print('state--=expand=-initial---$state');
              }
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            } else if (state is ExpandedCategoryLoadedState) {
              if (kDebugMode) {
                print('state--=expand=-loaded---$state');
              }
              productsList = state.expandedCategory.productList!;
              return productsList.isEmpty
                  ? Center(
                      child: Text('No Data Available',
                          style: textStyle13Medium(colorBlack)))
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                            productsList.length,
                            (index) => productsList[index]
                                    .name
                                    .toLowerCase()
                                    .contains(filteredItem.toLowerCase())
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 1.5),
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                ProductDetailScreen.route,
                                                arguments: ProductDetailData(
                                                    categoryId: widget
                                                        .categoryData
                                                        .categoryId,
                                                    product:
                                                        productsList[index]));
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: colorWhite,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: colorF3F3,
                                                      offset: Offset(3, 4),
                                                      blurRadius: 5)
                                                ]),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.w,
                                                  vertical: 2.h),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 7.h,
                                                    width: 10.w,
                                                    child: Image.network(
                                                        imgBaseUrl +
                                                            state
                                                                .expandedCategory
                                                                .productList![
                                                                    index]
                                                                .img
                                                                .first
                                                                .imgPath,
                                                        fit: BoxFit.contain),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 0.5.h),
                                                      Text(
                                                          state
                                                              .expandedCategory
                                                              .productList![
                                                                  index]
                                                              .name,
                                                          style:
                                                              textStyle10Bold(
                                                                  colorBlack)),
                                                      SizedBox(height: 0.5.h),
                                                      Text('1 Packet',
                                                          style: textStyle8(
                                                              colorText7070)),
                                                      SizedBox(height: 2.h),
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                              icGoldCoin,
                                                              width: 3.w),
                                                          SizedBox(width: 1.w),
                                                          Text(
                                                              '${productsList[index].price.toInt() - ((productsList[index].price.toInt() * productsList[index].discount) ~/ 100).toInt()}GP',
                                                              style: textStyle9Bold(
                                                                  colorTextFFC1)),
                                                          SizedBox(width: 2.w),
                                                          Image.asset(
                                                              icGoldCoin,
                                                              width: 3.w),
                                                          SizedBox(width: 1.w),
                                                          Text(
                                                              '${productsList[index].price.toInt()}GP',
                                                              style: textStyle8(
                                                                      colorText7070)
                                                                  .copyWith(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough)),
                                                          SizedBox(width: 2.w),
                                                          Text(
                                                              '${productsList[index].discount}% off',
                                                              style: textStyle7(
                                                                  colorGreen)),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        addToCartButton(
                                            cartList,
                                            state.expandedCategory
                                                .productList![index]),
                                      ],
                                    ),
                                  )
                                : Container()),
                      ),
                    );
            }
            return Container();
          },
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Image.asset(icSort, color: colorBlack, width: 4.w),
                    SizedBox(width: 0.7.w),
                    Text('SORT', style: textStyle11Bold(colorBlack)),
                  ],
                ),
                Container(
                    height: 9.h,
                    width: 1,
                    color: colorText7070.withOpacity(0.3)),
                Row(
                  children: [
                    Image.asset(icFilter, color: colorBlack, width: 4.w),
                    SizedBox(width: 1.w),
                    Text('FILTER', style: textStyle11Bold(colorBlack)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  addToCartButton(List<CartItem> cartList, ProductList productList) {
    print('-----cartList-=22=----$cartList-----${productList.id}');
    if (productList.availableQty == 0) {
      return Positioned(bottom: 2.h, right: 5.w, child: outOfStock());
    } else {
      if (cartList.isNotEmpty) {
        bool isContain = false;
        int id = 0;
        int quantity = 0;
        for (int i = 0; i < cartList.length; i++) {
          print(
              '--match--product--id---${productList.id}--==--${cartList[i].productId}---x---${productList.id == cartList[i].productId}');
          if (productList.id == cartList[i].productId) {
            print(
                '--match---id---${cartList[i].categoryId}--==--${widget.categoryData.categoryId}---x---${cartList[i].categoryId == widget.categoryData.categoryId}');
            if (cartList[i].categoryId == widget.categoryData.categoryId) {
              print('--match--product-name---${cartList[i].name}');
              isContain = true;
              id = cartList[i].id;
              quantity = cartList[i].quantity;
              break;
            } else {
              print('--don\'t-match--product-name---${cartList[i].name}');
              isContain = false;
              id = cartList[i].id;
              quantity = cartList[i].quantity;
            }
          }
        }
        if (isContain) {
          return Positioned(
              bottom: 2.h,
              right: 5.w,
              child: addItemButton(quantity, () {
                if (quantity == 1) {
                  CommonFunction().confirmationDialog(context,
                      'Are you sure you want to remove the selected product?',
                      () {
                    Navigator.of(context).pop();
                    BlocProvider.of<CartBloc>(context).add(
                        LoadSingleRemoveCartEvent(
                            cartItem: CartItem(
                                id: id,
                                categoryId: widget.categoryData.categoryId,
                                productId: productList.id,
                                img: productList.img.first.imgPath,
                                name: productList.name,
                                price: productList.price,
                                discount: productList.discount,
                                quantity: quantity)));
                    BlocProvider.of<CartBloc>(context).add(LoadCartListEvent());
                  });
                } else {
                  BlocProvider.of<CartBloc>(context).add(
                      LoadSingleRemoveCartEvent(
                          cartItem: CartItem(
                              id: id,
                              categoryId: widget.categoryData.categoryId,
                              productId: productList.id,
                              img: productList.img.first.imgPath,
                              name: productList.name,
                              price: productList.price,
                              discount: productList.discount,
                              quantity: quantity)));
                  BlocProvider.of<CartBloc>(context).add(LoadCartListEvent());
                }
              }, () {
                BlocProvider.of<CartBloc>(context).add(LoadAddCartEvent(
                    cartItem: CartItem(
                        id: id,
                        categoryId: widget.categoryData.categoryId,
                        productId: productList.id,
                        img: productList.img.first.imgPath,
                        name: productList.name,
                        price: productList.price,
                        discount: productList.discount,
                        quantity: quantity)));
                BlocProvider.of<CartBloc>(context).add(LoadCartListEvent());
              }));
        } else {
          return Positioned(
              bottom: 2.h,
              right: 5.w,
              child: addButton(() {
                setState(() {
                  if (cartList.isNotEmpty) {
                    id = cartList.last.id;
                  }
                  id = id + 1;
                });
                print('----product--add11---${productList.name}---$id');
                BlocProvider.of<CartBloc>(context).add(LoadAddCartEvent(
                    cartItem: CartItem(
                  id: id,
                  categoryId: widget.categoryData.categoryId,
                  productId: productList.id,
                  img: productList.img.first.imgPath,
                  name: productList.name,
                  price: productList.price,
                  discount: productList.discount,
                  quantity: 1,
                )));
                BlocProvider.of<CartBloc>(context).add(LoadCartListEvent());
              }));
        }
      } else {
        return Positioned(
            bottom: 2.h,
            right: 5.w,
            child: addButton(() {
              print('----product--add22---${productList.name}---$id');
              setState(() {
                if (cartList.isNotEmpty) {
                  id = cartList.last.id;
                }
                id = id + 1;
              });
              BlocProvider.of<CartBloc>(context).add(LoadAddCartEvent(
                  cartItem: CartItem(
                id: id,
                categoryId: widget.categoryData.categoryId,
                productId: productList.id,
                img: productList.img.first.imgPath,
                name: productList.name,
                price: productList.price,
                discount: productList.discount,
                quantity: 1,
              )));
              BlocProvider.of<CartBloc>(context).add(LoadCartListEvent());
            }));
      }
    }
  }

  outOfStock() {
    return Container(
        height: 4.h,
        width: 20.w,
        decoration: decoration(colorE5E5),
        alignment: Alignment.center,
        child: Text('Out of Stock',
            style: textStyle8Bold(colorText4747)
                .copyWith(fontWeight: FontWeight.w900)));
  }

  addButton(Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
          height: 4.h,
          width: 20.w,
          decoration: decoration(colorRed),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icAdd, color: colorWhite, width: 2.5.w),
              SizedBox(width: 2.w),
              Text('ADD', style: textStyle9Bold(colorWhite)),
            ],
          )),
    );
  }

  addItemButton(int itemCount, Function() onMinus, Function() onAdd) {
    return Container(
        height: 4.h,
        width: 20.w,
        decoration: decoration(colorWhite),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 2.5.w,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 2.5.w,
                  onPressed: onMinus,
                  icon: Image.asset(icMinus, color: colorRed, width: 2.5.w)),
            ),
            Text('$itemCount', style: textStyle9Bold(colorBlack)),
            SizedBox(
              width: 2.5.w,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 2.5.w,
                  onPressed: onAdd,
                  icon: Image.asset(icAdd, color: colorRed, width: 2.5.w)),
            ),
          ],
        ));
  }

  BoxDecoration decoration(Color bgColor) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: bgColor == colorWhite
            ? Border.all(color: colorRed, width: 1)
            : null,
        boxShadow: [
          if (bgColor != colorE5E5)
            BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 6,
                color: colorRed.withOpacity(0.35))
        ]);
  }
}
