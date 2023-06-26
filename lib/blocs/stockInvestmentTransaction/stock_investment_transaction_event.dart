part of 'stock_investment_transaction_bloc.dart';

@immutable
abstract class StockTransactionEvent {}

class LoadStockTransactionEvent extends StockTransactionEvent {
  final String userId;
  final String stockName;
  final StockInvestmentTransactionModel stockTransaction;

  LoadStockTransactionEvent({required this.userId,required this.stockName,required this.stockTransaction});
}