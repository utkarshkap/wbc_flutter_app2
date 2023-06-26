import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/fetching_api.dart';
import '../../models/stock_investment_transaction_model.dart';

part 'stock_investment_transaction_event.dart';
part 'stock_investment_transaction_state.dart';

class StockTransactionBloc extends Bloc<StockTransactionEvent, StockTransactionState> {
  StockTransactionBloc() : super(StockTransactionInitial()) {
    on<LoadStockTransactionEvent>((event, emit) async {
      emit(StockTransactionInitial());
      try {
        final stockTransaction = await FetchingApi().getStockTransaction(event.userId,event.stockName);
        // log('-----mfData---$mfTransaction');
        emit(StockTransactionLoadedState(stockTransaction));
      } catch (e) {
        emit(StockTransactionErrorState(e.toString()));
      }
    });
  }
}