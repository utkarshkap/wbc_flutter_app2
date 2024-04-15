import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wbc_connect_app/models/expanded_category_model.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/product_category.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/product_details_screen.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/wealth_meter.dart';

import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../blocs/mall/mall_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../core/api/api_consts.dart';
import '../../models/newArrival_data_model.dart';
import '../../models/popular_data_model.dart';
import '../../models/product_category_model.dart';
import '../../models/trending_data_model.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../../widgets/main_drawer.dart';
import '../home_screen.dart';
import '../profile_screen.dart';
import 'cart_screen.dart';
import 'expand_category.dart';
import 'order_history.dart';

class WbcMegaMall extends StatefulWidget {
  static const route = '/WBC-Mega-Mall';

  const WbcMegaMall({Key? key}) : super(key: key);

  @override
  State<WbcMegaMall> createState() => _WbcMegaMallState();
}

class _WbcMegaMallState extends State<WbcMegaMall> {
  final TextEditingController _searchController = TextEditingController();
  List<Category> categories = [];
  int _selectedIndex = 1;
  bool isNewArrival = false;
  bool isPopular = false;
  bool isTrending = false;

  _onItemTapped(int index) async {
    if (_selectedIndex != index) {
      print('---index----$index');
      setState(() {
        _selectedIndex = index;
      });
      if (_selectedIndex == 3) {
        Navigator.of(context)
            .pushNamed(CartScreen.route)
            .then((value) => setState(() {
                  _selectedIndex = 1;
                }));
      }
      if (_selectedIndex == 4) {
        BlocProvider.of<OrderBloc>(context)
            .add(GetOrderHistory(userId: ApiUser.userId));
        Navigator.of(context)
            .pushNamed(OrderHistory.route, arguments: OrderHistoryData())
            .then((value) => setState(() {
                  _selectedIndex = 1;
                }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: colorBG,
          appBar: AppBar(
            toolbarHeight: 8.h,
            backgroundColor: colorRed,
            elevation: 6,
            shadowColor: colorTextBCBC.withOpacity(0.3),
            leadingWidth: 15.w,
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset(icMenu, color: colorWhite, width: 7.w));
            }),
            titleSpacing: 0,
            title: Text('WBC Mega Mall', style: textStyle15Bold(colorWhite)),
            actions: [
              AppBarButton(
                  splashColor: colorRed,
                  bgColor: colorRedFF6,
                  icon: icNotification,
                  iconColor: colorWhite,
                  onClick: () {
                    Navigator.of(context).pushNamed(NotificationScreen.route);
                  }),
              SizedBox(width: 2.w),
              AppBarButton(
                  splashColor: colorRed,
                  bgColor: colorRedFF6,
                  icon: icProfile,
                  iconColor: colorWhite,
                  onClick: () {
                    Navigator.of(context).pushNamed(ProfileScreen.route);
                  }),
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
                        color: colorF3F3,
                        borderRadius: BorderRadius.circular(10)),
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
                                hintText: 'Search Products & brands...',
                                hintStyle: textStyle12(colorText7070),
                                fillColor: colorF3F3,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                              ),
                              onChanged: (val) {},
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
          drawer: MainDrawer(reLoadHomePage: () async {
            Navigator.of(context).pop();
            final reLoadPage =
                await Navigator.of(context).pushNamed(WealthMeterScreen.route);
            if (reLoadPage == true) {
              setState(() {});
            }
          }),
          extendBody: true,
          body: WillPopScope(
            onWillPop: () async {
              print('----==-----==------=--------');
              BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                  popular: Popular(code: 0, message: '', products: []),
                  newArrival: NewArrival(code: 0, message: '', products: []),
                  trending: Trending(code: 0, message: '', products: [])));
              Navigator.of(context).pushReplacementNamed(HomeScreen.route,
                  arguments: HomeScreenData(acceptedContacts: ''));
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: colorWhite,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 2.5.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('BROWSE BY CATEGORIES',
                                  style: textStyle10Bold(colorBlack)
                                      .copyWith(letterSpacing: 0.7)),
                              Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: GestureDetector(
                                  onTap: () {
                                    if (categories.length > 8) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              ProductCategoryScreen.route,
                                              arguments: CategoryData(
                                                  categories: categories));
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text('View All',
                                          style: textStyle10(colorRed)),
                                      SizedBox(width: 2.2.w),
                                      Image.asset(icNext,
                                          color: colorRed, height: 1.5.h)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 1.5.h),
                          BlocConsumer<FetchingDataBloc, FetchingDataState>(
                            listener: (context, state) {
                              if (state is ProductCategoryLoadedState) {
                                categories = state.productCategory.categories;
                              }
                              if (state is ProductCategoryErrorState) {
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
                              if (state is ProductCategoryInitial) {
                                print('state--=product=-initial---$state');
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          loadingCategory(),
                                          loadingCategory(),
                                          loadingCategory(),
                                          loadingCategory(),
                                        ],
                                      ),
                                      SizedBox(height: 6.w / 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          loadingCategory(),
                                          loadingCategory(),
                                          loadingCategory(),
                                          loadingCategory(),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else if (state is ProductCategoryLoadedState) {
                                print('state--=product=-loaded---$state');
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (state.productCategory.categories
                                            .isNotEmpty)
                                          browseCategories(state
                                              .productCategory.categories[0]),
                                        if (state.productCategory.categories
                                                .length >
                                            1)
                                          browseCategories(state
                                              .productCategory.categories[1]),
                                        if (state.productCategory.categories
                                                .length >
                                            2)
                                          browseCategories(state
                                              .productCategory.categories[2]),
                                        if (state.productCategory.categories
                                                .length >
                                            3)
                                          browseCategories(state
                                              .productCategory.categories[3]),
                                      ],
                                    ),
                                    SizedBox(height: 6.w / 3),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (state.productCategory.categories
                                                .length >
                                            4)
                                          browseCategories(state
                                              .productCategory.categories[4]),
                                        if (state.productCategory.categories
                                                .length >
                                            5)
                                          browseCategories(state
                                              .productCategory.categories[5]),
                                        if (state.productCategory.categories
                                                .length >
                                            6)
                                          browseCategories(state
                                              .productCategory.categories[6]),
                                        if (state.productCategory.categories
                                                .length >
                                            7)
                                          browseCategories(state
                                              .productCategory.categories[7]),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return Container();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.5.h),
                  if (ApiUser.offersList.isNotEmpty)
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('PRODUCT BANNERS',
                                  style: textStyle10Bold(colorBlack)
                                      .copyWith(letterSpacing: 0.7)),
                              Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context)
                                    //     .pushNamed(WbcMegaMall.route);
                                  },
                                  child: Row(
                                    children: [
                                      Text('See More',
                                          style: textStyle10(colorRed)),
                                      SizedBox(width: 2.2.w),
                                      Image.asset(icNext,
                                          color: colorRed, height: 1.5.h)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                ApiUser.offersList.length,
                                (index) => Padding(
                                      padding: EdgeInsets.only(
                                          left: index == 0 ? 4.w : 0,
                                          right: 2.5.w,
                                          bottom: 2.h),
                                      child: Container(
                                        height: 15.h,
                                        width: 60.w,
                                        decoration: decoration(colorWhite),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                                imgBaseUrl +
                                                    ApiUser.offersList[index]
                                                        .imgUrl,
                                                fit: BoxFit.fill)),
                                      ),
                                    )),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 2.5.h),
                  if (!isNewArrival)
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('NEW ARRIVALS',
                                  style: textStyle10Bold(colorBlack)
                                      .copyWith(letterSpacing: 0.7)),
                              Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context)
                                    //     .pushNamed(WbcMegaMall.route);
                                  },
                                  child: Row(
                                    children: [
                                      Text('View All',
                                          style: textStyle10(colorRed)),
                                      SizedBox(width: 2.2.w),
                                      Image.asset(icNext,
                                          color: colorRed, height: 1.5.h)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                      ],
                    ),
                  BlocConsumer<MallBloc, MallState>(
                    listener: (context, state) {
                      if (state is MallDataLoadedState) {
                        if (state.newArrival.products.isEmpty) {
                          isNewArrival = true;
                        }
                      } else if (state is MallDataErrorState) {
                        isNewArrival = true;
                      }
                    },
                    builder: (context, state) {
                      print('------mallState--=---$state');
                      if (state is MallDataInitial) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: SingleChildScrollView(
                            physics: const PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  3,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(
                                            left: index == 0 ? 5.w : 0,
                                            right: 2.5.w,
                                            bottom: 2.h),
                                        child: Container(
                                          height: 25.h,
                                          width: 42.w,
                                          decoration: decoration(colorWhite),
                                        ),
                                      )),
                            ),
                          ),
                        );
                      }
                      if (state is MallDataLoadedState) {
                        return state.newArrival.products.isEmpty
                            ? Container()
                            : SingleChildScrollView(
                                physics: const PageScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      state.newArrival.products.length,
                                      (index) =>
                                          state.newArrival.products[index].img
                                                  .isEmpty
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                    left: index == 0 ? 5.w : 0,
                                                  ),
                                                  child: Container(),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          index == 0 ? 5.w : 0,
                                                      right: 2.5.w,
                                                      bottom: 2.h),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).pushNamed(ProductDetailScreen.route,
                                                          arguments: ProductDetailData(
                                                              categoryId: state
                                                                  .newArrival
                                                                  .products[
                                                                      index]
                                                                  .catId,
                                                              product: ProductList(
                                                                  id: state
                                                                      .newArrival
                                                                      .products[
                                                                          index]
                                                                      .id,
                                                                  name: state
                                                                      .newArrival
                                                                      .products[
                                                                          index]
                                                                      .name,
                                                                  price: state
                                                                      .newArrival
                                                                      .products[
                                                                          index]
                                                                      .price,
                                                                  discount: state
                                                                      .newArrival
                                                                      .products[
                                                                          index]
                                                                      .discount,
                                                                  availableQty: state
                                                                      .newArrival
                                                                      .products[index]
                                                                      .availableQty,
                                                                  description: state.newArrival.products[index].description,
                                                                  rate: state.newArrival.products[index].rate,
                                                                  img: state.newArrival.products[index].img)));
                                                    },
                                                    child: Container(
                                                      width: 42.w,
                                                      decoration: decoration(
                                                          colorWhite),
                                                      padding:
                                                          EdgeInsets.all(2.w),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        colorGreen,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          0.5.h,
                                                                      horizontal:
                                                                          1.w),
                                                                  child: Text(
                                                                      '${state.newArrival.products[index].discount}% off',
                                                                      style: textStyle8(
                                                                          colorWhite)),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(height: 1.h),
                                                          SizedBox(
                                                            height: 14.h,
                                                            width: 35.w,
                                                            child: Image.network(
                                                                imgBaseUrl +
                                                                    state
                                                                        .newArrival
                                                                        .products[
                                                                            index]
                                                                        .img
                                                                        .first
                                                                        .imgPath,
                                                                fit: BoxFit
                                                                    .contain),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 2.h,
                                                                    bottom:
                                                                        1.h),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 35.w,
                                                                  child: Text(
                                                                      state
                                                                          .newArrival
                                                                          .products[
                                                                              index]
                                                                          .name,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: textStyle9(colorBlack).copyWith(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          height:
                                                                              1.2)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Image.asset(
                                                                  icGoldCoin,
                                                                  width: 2.w),
                                                              SizedBox(
                                                                  width: 1.w),
                                                              Text(
                                                                  '${state.newArrival.products[index].price.toInt() - ((state.newArrival.products[index].price.toInt() * state.newArrival.products[index].discount) ~/ 100).toInt()}GP',
                                                                  style: textStyle9Bold(
                                                                      colorTextFFC1)),
                                                              SizedBox(
                                                                  width: 1.5.w),
                                                              Image.asset(
                                                                  icGoldCoin,
                                                                  width: 2.w),
                                                              SizedBox(
                                                                  width: 1.w),
                                                              Text(
                                                                  '${state.newArrival.products[index].price.toInt()}GP',
                                                                  style: textStyle8(
                                                                          colorText7070)
                                                                      .copyWith(
                                                                          decoration:
                                                                              TextDecoration.lineThrough)),
                                                            ],
                                                          ),
                                                          SizedBox(height: 1.h),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                ),
                              );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(height: 2.5.h),
                  if (!isPopular)
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('MOST POPULAR',
                                  style: textStyle10Bold(colorBlack)
                                      .copyWith(letterSpacing: 0.7)),
                              Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context)
                                    //     .pushNamed(WbcMegaMall.route);
                                  },
                                  child: Row(
                                    children: [
                                      Text('View All',
                                          style: textStyle10(colorRed)),
                                      SizedBox(width: 2.2.w),
                                      Image.asset(icNext,
                                          color: colorRed, height: 1.5.h)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                      ],
                    ),
                  BlocConsumer<MallBloc, MallState>(
                    listener: (context, state) {
                      if (state is MallDataLoadedState) {
                        if (state.popular.products.isEmpty) {
                          isPopular = true;
                        }
                      } else if (state is MallDataErrorState) {
                        isPopular = true;
                      }
                    },
                    builder: (context, state) {
                      print('------mallState--=---$state');
                      if (state is MallDataInitial) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: SingleChildScrollView(
                            physics: const PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  3,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(
                                            left: index == 0 ? 5.w : 0,
                                            right: 2.5.w,
                                            bottom: 2.h),
                                        child: Container(
                                          height: 25.h,
                                          width: 42.w,
                                          decoration: decoration(colorWhite),
                                        ),
                                      )),
                            ),
                          ),
                        );
                      }
                      if (state is MallDataLoadedState) {
                        return state.popular.products.isEmpty
                            ? Container()
                            : SingleChildScrollView(
                                physics: const PageScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      state.popular.products.length,
                                      (index) =>
                                          state.popular.products[index].img
                                                  .isEmpty
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                    left: index == 0 ? 5.w : 0,
                                                  ),
                                                  child: Container(),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          index == 0 ? 5.w : 0,
                                                      right: 2.5.w,
                                                      bottom: 2.h),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).pushNamed(ProductDetailScreen.route,
                                                          arguments: ProductDetailData(
                                                              categoryId: state
                                                                  .popular
                                                                  .products[
                                                                      index]
                                                                  .catId,
                                                              product: ProductList(
                                                                  id: state
                                                                      .popular
                                                                      .products[
                                                                          index]
                                                                      .id,
                                                                  name: state
                                                                      .popular
                                                                      .products[
                                                                          index]
                                                                      .name,
                                                                  price: state
                                                                      .popular
                                                                      .products[
                                                                          index]
                                                                      .price,
                                                                  discount: state
                                                                      .popular
                                                                      .products[
                                                                          index]
                                                                      .discount,
                                                                  availableQty: state
                                                                      .popular
                                                                      .products[index]
                                                                      .availableQty,
                                                                  description: state.popular.products[index].description,
                                                                  rate: state.popular.products[index].rate,
                                                                  img: state.popular.products[index].img)));
                                                    },
                                                    child: Container(
                                                      width: 42.w,
                                                      decoration: decoration(
                                                          colorWhite),
                                                      padding:
                                                          EdgeInsets.all(2.w),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        colorGreen,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          0.5.h,
                                                                      horizontal:
                                                                          1.w),
                                                                  child: Text(
                                                                      '${state.popular.products[index].discount}% off',
                                                                      style: textStyle8(
                                                                          colorWhite)),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(height: 1.h),
                                                          SizedBox(
                                                            height: 14.h,
                                                            width: 35.w,
                                                            child: Image.network(
                                                                imgBaseUrl +
                                                                    state
                                                                        .popular
                                                                        .products[
                                                                            index]
                                                                        .img
                                                                        .first
                                                                        .imgPath,
                                                                fit: BoxFit
                                                                    .contain),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 2.h,
                                                                    bottom:
                                                                        1.h),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 35.w,
                                                                  child: Text(
                                                                      state
                                                                          .popular
                                                                          .products[
                                                                              index]
                                                                          .name,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: textStyle9(colorBlack).copyWith(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          height:
                                                                              1.2)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Image.asset(
                                                                  icGoldCoin,
                                                                  width: 2.w),
                                                              SizedBox(
                                                                  width: 1.w),
                                                              Text(
                                                                  '${state.popular.products[index].price.toInt() - ((state.popular.products[index].price.toInt() * state.popular.products[index].discount) ~/ 100).toInt()}GP',
                                                                  style: textStyle9Bold(
                                                                      colorTextFFC1)),
                                                              SizedBox(
                                                                  width: 1.5.w),
                                                              Image.asset(
                                                                  icGoldCoin,
                                                                  width: 2.w),
                                                              SizedBox(
                                                                  width: 1.w),
                                                              Text(
                                                                  '${state.popular.products[index].price.toInt()}GP',
                                                                  style: textStyle8(
                                                                          colorText7070)
                                                                      .copyWith(
                                                                          decoration:
                                                                              TextDecoration.lineThrough)),
                                                            ],
                                                          ),
                                                          SizedBox(height: 1.h),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                ),
                              );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  // SizedBox(height: 1.h),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.w),
                  //   child: Container(
                  //     height: 25.h,
                  //     decoration: decoration(colorWhite),
                  //   ),
                  // ),
                  SizedBox(height: 2.5.h),
                  if (!isTrending)
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('TRENDING PRODUCTS',
                                  style: textStyle10Bold(colorBlack)
                                      .copyWith(letterSpacing: 0.7)),
                              Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context)
                                    //     .pushNamed(WbcMegaMall.route);
                                  },
                                  child: Row(
                                    children: [
                                      Text('View All',
                                          style: textStyle10(colorRed)),
                                      SizedBox(width: 2.2.w),
                                      Image.asset(icNext,
                                          color: colorRed, height: 1.5.h)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                      ],
                    ),
                  BlocConsumer<MallBloc, MallState>(
                    listener: (context, state) {
                      if (state is MallDataLoadedState) {
                        if (state.trending.products.isEmpty) {
                          isTrending = true;
                        }
                        state.trending.products
                            .removeWhere((element) => element.img.isEmpty);
                      } else if (state is MallDataErrorState) {
                        isTrending = true;
                      }
                    },
                    builder: (context, state) {
                      print('------mallState--=---$state');
                      if (state is MallDataInitial) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 70.h,
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 0.85,
                                        crossAxisCount: 2),
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return Container(
                                      height: 25.h,
                                      width: 44.5.w,
                                      decoration: decoration(colorWhite));
                                }),
                          ),
                        );
                      }
                      if (state is MallDataLoadedState) {
                        return state.trending.products.isEmpty
                            ? Container()
                            : SizedBox(
                                height: 70.h,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                                childAspectRatio: 0.85,
                                                crossAxisCount: 2),
                                        itemCount: 4,
                                        itemBuilder: (context, index) {
                                          return state.trending.products[index]
                                                  .img.isEmpty
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(
                                                        ProductDetailScreen
                                                            .route,
                                                        arguments: ProductDetailData(
                                                            categoryId: state
                                                                .trending
                                                                .products[index]
                                                                .catId,
                                                            product: ProductList(
                                                                id: state
                                                                    .trending
                                                                    .products[
                                                                        index]
                                                                    .id,
                                                                name: state
                                                                    .trending
                                                                    .products[
                                                                        index]
                                                                    .name,
                                                                price: state
                                                                    .trending
                                                                    .products[
                                                                        index]
                                                                    .price,
                                                                discount: state
                                                                    .trending
                                                                    .products[
                                                                        index]
                                                                    .discount,
                                                                availableQty:
                                                                    state.trending.products[index].availableQty,
                                                                description: state.trending.products[index].description,
                                                                rate: state.trending.products[index].rate,
                                                                img: state.trending.products[index].img)));
                                                  },
                                                  child: trendingProducts(state
                                                      .trending
                                                      .products[index]),
                                                );
                                        }),
                                  ),
                                ),
                              );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            height: 8.h,
            width: 8.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorWhite, width: 2)),
            child: Image.asset(icGoldCoin, fit: BoxFit.fill),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
            child: Container(
              height: 75,
              color: colorTransparent,
              child: BottomAppBar(
                color: colorRed,
                shape: const CircularNotchedRectangle(),
                notchMargin: 7,
                child: Row(
                  children: <Widget>[
                    bottomIcon(icHome, 'HOME', 1),
                    bottomIcon(icCategory, 'CATEGORY', 2),
                    Container(width: 20.w),
                    bottomIcon(icAddToCart, 'CART', 3),
                    bottomIcon(icFilledOrderHistory, 'HISTORY', 4),
                  ],
                ),
              ),
            ),
          )),
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

  loadingCategory() {
    return Container(
      height: 15.7.h,
      width: 21.8.w,
      decoration: decoration(colorECEC),
    );
  }

  browseCategories(Category list) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(ExpandCategory.route,
              arguments: ExpandCategoryData(
                  categoryId: list.id,
                  categoryName: list.name,
                  isFromMall: true));
          BlocProvider.of<FetchingDataBloc>(context).add(
              LoadExpandedCategoryEvent(
                  id: list.id,
                  expandedCategory:
                      ExpandedCategory(code: 0, message: '', productList: [])));
        },
        child: Container(
          height: 125,
          width: 21.8.w,
          decoration: decoration(colorECEC),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: SizedBox(
                    height: 50,
                    width: 20.w,
                    child: Image.network(
                      imgBaseUrl + list.imgPath,
                      fit: BoxFit.contain,
                    )),
              ),
              Text(list.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle8(colorBlack)
                      .copyWith(fontWeight: FontWeight.w600, height: 1.2)),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('300', style: textStyle6Medium(colorRed)),
                  Text('+', style: textStyle8Medium(colorRed)),
                  Text(' Items', style: textStyle6Medium(colorRed)),
                ],
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ));
  }

  trendingProducts(Product product) {
    return Container(
      width: 44.5.w,
      decoration: decoration(colorWhite),
      padding: EdgeInsets.all(2.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: colorGreen, borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                  child: Text('${product.discount}% off',
                      style: textStyle8(colorWhite)),
                ),
              )
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
              height: 13.h,
              width: 35.w,
              child: Image.network(imgBaseUrl + product.img.first.imgPath,
                  fit: BoxFit.contain)),
          Padding(
            padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
            child: Row(
              children: [
                SizedBox(
                  width: 35.w,
                  child: Text(product.name,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle9(colorBlack)
                          .copyWith(fontWeight: FontWeight.w600, height: 1.2)),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Image.asset(icGoldCoin, width: 3.w),
              SizedBox(width: 1.w),
              Text(
                  '${product.price.toInt() - ((product.price.toInt() * product.discount) ~/ 100).toInt()}GP',
                  style: textStyle9Bold(colorTextFFC1)),
              SizedBox(width: 1.5.w),
              Image.asset(icGoldCoin, width: 3.w),
              SizedBox(width: 1.w),
              Text('${product.price.toInt()}GP',
                  style: textStyle8(colorText7070)
                      .copyWith(decoration: TextDecoration.lineThrough)),
            ],
          ),
        ],
      ),
    );
  }

  bottomIcon(String icon, String title, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 20.w,
        color: colorTransparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon.isNotEmpty)
              Image.asset(icon,
                  color: _selectedIndex == index ? colorTextFFC1 : colorWhite,
                  alignment: Alignment.bottomCenter,
                  height: icon == icFilledOrderHistory ? 21 : 25),
            if (icon.isEmpty) Container(height: 25),
            Text(title,
                style: textStyle8Bold(
                    _selectedIndex == index ? colorTextFFC1 : colorWhite))
          ],
        ),
      ),
    );
  }
}
