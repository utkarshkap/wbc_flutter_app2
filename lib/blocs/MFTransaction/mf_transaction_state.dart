part of 'mf_transaction_bloc.dart';

@immutable
abstract class MFTransactionState {}

class MFTransactionInitial extends MFTransactionState {
  @override
  List<Object> get props => [];
}

class MFTransactionLoadedState extends MFTransactionState {
  final InvestmentTransaction investmentTransaction;

  MFTransactionLoadedState(this.investmentTransaction);

  @override
  List<Object?> get props => [investmentTransaction];
}

class MFTransactionErrorState extends MFTransactionState {
  final String error;

  MFTransactionErrorState(this.error);

  @override
  List<Object?> get props => [error];
}