import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/fetching_api.dart';
import '../../models/newArrival_data_model.dart';
import '../../models/popular_data_model.dart';
import '../../models/trending_data_model.dart';

part 'mall_event.dart';
part 'mall_state.dart';

class MallBloc extends Bloc<MallEvent, MallState> {
  MallBloc() : super(MallInitial()) {
    on<LoadMallDataEvent>((event, emit) async {
      emit(MallDataInitial());
      try {
        print('-=---mallData--=--');
        final popularData = await FetchingApi().getPopularProducts();
        final newArrivalData = await FetchingApi().getNewArrivalProducts();
        final trendingData = await FetchingApi().getTrendingProducts();
        emit(MallDataLoadedState(popularData,newArrivalData,trendingData));
      } catch (e) {
        emit(MallDataErrorState(e.toString()));
      }
    });
  }
}
