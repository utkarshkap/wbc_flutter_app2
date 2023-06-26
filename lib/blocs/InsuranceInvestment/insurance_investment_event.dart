part of 'insurance_investment_bloc.dart';

@immutable
abstract class InsuranceInvestmentEvent {}

class LoadInsuranceInvestmentEvent extends InsuranceInvestmentEvent {
  final String userId;
  final int typeId;
  final int subTypeId;
  final InsuranceInvestment insuranceInvestment;

  LoadInsuranceInvestmentEvent({required this.userId,required this.insuranceInvestment, required this.typeId, required this.subTypeId});
}