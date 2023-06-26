import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/wbc_mega_mall.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../blocs/mall/mall_bloc.dart';
import '../../core/api/api_consts.dart';
import '../../models/cart_model.dart';
import '../../models/expanded_category_model.dart';
import '../../models/newArrival_data_model.dart';
import '../../models/popular_data_model.dart';
import '../../models/product_category_model.dart';
import '../../models/trending_data_model.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import 'cart_screen.dart';
import 'expand_category.dart';

class CategoryData {
  final List<Category> categories;

  CategoryData({required this.categories});
}

class ProductCategoryScreen extends StatefulWidget {
  static const route = '/Product-Category';
  final CategoryData category;

  const ProductCategoryScreen({super.key, required this.category});

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
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
              BlocProvider.of<MallBloc>(context).add(
                  LoadMallDataEvent(
                      popular: Popular(code: 0, message: '', products: []),
                      newArrival: NewArrival(code: 0, message: '', products: []),
                      trending:
                      Trending(code: 0, message: '', products: [])));
            },
            icon: Image.asset(icBack, color: colorRed, width: 6.w)),
        titleSpacing: 0,
        title: Text('Categories', style: textStyle14Bold(colorBlack)),
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
      ),
      body: WillPopScope(
        onWillPop: ()async{
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
          return false;
        },
        child: GridView.builder(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
                crossAxisCount: 3),
            itemCount: widget.category.categories.length,
            itemBuilder: (context, index) {
              return widget.category.categories[index].imgPath.isEmpty
                  ? Container()
                  : GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        ExpandCategory.route,
                        arguments: ExpandCategoryData(
                            categoryId:
                            widget.category.categories[index].id,
                            categoryName:
                            widget.category.categories[index].name, isFromMall: false));
                    BlocProvider.of<FetchingDataBloc>(context).add(
                        LoadExpandedCategoryEvent(
                            id: widget.category.categories[index].id,
                            expandedCategory: ExpandedCategory(
                                code: 0, message: '', productList: [])));
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
                              height: 60,
                              width: 25.w,
                              child: Image.network(
                                imgBaseUrl +
                                    widget.category.categories[index]
                                        .imgPath,
                                fit: BoxFit.contain,
                              )),
                        ),
                        Text(widget.category.categories[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle8(colorBlack).copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.2)),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('300',
                                style: textStyle6Medium(colorRed)),
                            Text('+', style: textStyle8Medium(colorRed)),
                            Text(' Items',
                                style: textStyle6Medium(colorRed)),
                          ],
                        ),
                        SizedBox(height: 1.h),
                      ],
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
