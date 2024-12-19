part of 'emisip_calculator_bloc.dart';

@immutable
abstract class EMISIPCalculatorEvent {}

class EMISIPData extends EMISIPCalculatorEvent {
  final String name;
  final int loanAmount;
  final int noOfYear;
  final double loanInterestRate;
  final double interestRateOnInvestment;

  EMISIPData({
    required this.name,
    required this.loanAmount,
    required this.noOfYear,
    required this.loanInterestRate,
    required this.interestRateOnInvestment,
  });
}
