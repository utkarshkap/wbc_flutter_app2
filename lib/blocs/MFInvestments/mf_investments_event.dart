part of 'mf_investments_bloc.dart';

@immutable
abstract class MFInvestmentsEvent {}

class LoadMFInvestmentsEvent extends MFInvestmentsEvent {
  final String userId;
  final InvestmentPortfolio investmentPortfolio;

  LoadMFInvestmentsEvent({required this.userId,required this.investmentPortfolio});
}