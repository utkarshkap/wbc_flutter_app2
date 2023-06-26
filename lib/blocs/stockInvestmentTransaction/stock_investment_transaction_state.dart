part of 'stock_investment_transaction_bloc.dart';

@immutable
abstract class StockTransactionState {}

class StockTransactionInitial extends StockTransactionState {
  @override
  List<Object> get props => [];
}

class StockTransactionLoadedState extends StockTransactionState {
  final StockInvestmentTransactionModel stockTransaction;

  StockTransactionLoadedState(this.stockTransaction);

  @override
  List<Object?> get props => [stockTransaction];
}

class StockTransactionErrorState extends StockTransactionState {
  final String error;

  StockTransactionErrorState(this.error);

  @override
  List<Object?> get props => [error];
}