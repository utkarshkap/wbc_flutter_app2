part of 'insurance_investment_bloc.dart';

@immutable
abstract class InsuranceInvestmentState {}

class InsuranceInvestmentInitial extends InsuranceInvestmentState {
  @override
  List<Object> get props => [];
}

class InsuranceInvestmentLoadedState extends InsuranceInvestmentState {
  final InsuranceInvestment insuranceInvestment;
  InsuranceInvestmentLoadedState(this.insuranceInvestment);

  @override
  List<Object?> get props => [insuranceInvestment];
}

class InsuranceInvestmentErrorState extends InsuranceInvestmentState {
  final String error;
  InsuranceInvestmentErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
