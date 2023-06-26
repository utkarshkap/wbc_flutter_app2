part of 'mf_investments_bloc.dart';

@immutable
abstract class MFInvestmentsState {}

class MFInvestmentsInitial extends MFInvestmentsState {
  @override
  List<Object> get props => [];
}

class MFInvestmentsLoadedState extends MFInvestmentsState {
  final InvestmentPortfolio investmentPortfolio;
  MFInvestmentsLoadedState(this.investmentPortfolio);

  @override
  List<Object?> get props => [investmentPortfolio];
}

class MFInvestmentsErrorState extends MFInvestmentsState {
  final String error;

  MFInvestmentsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}