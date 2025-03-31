part of 'mf_transaction_bloc.dart';

@immutable
abstract class MFTransactionEvent {}

class LoadMFTransactionEvent extends MFTransactionEvent {
  final String userId;
  // final String folioNo;
  final String schemeName;
  final InvestmentTransaction investmentTransaction;

  LoadMFTransactionEvent(
      {required this.userId,
      // required this.folioNo,
      required this.schemeName,
      required this.investmentTransaction});
}
