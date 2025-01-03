part of 'retirement_calculator_bloc.dart';

@immutable
abstract class RetirementCalculatorEvent {}

class RetirementData extends RetirementCalculatorEvent {
  final String name;
  final int currentAge;
  final int retirementAge;
  final int lifeExpectancy;
  final int monthlyExpenses;
  final double preRetirementReturn;
  final double postRetirementReturn;
  final int currentInvestment;
  final double inflationRate;

  RetirementData({
    required this.name,
    required this.currentAge,
    required this.retirementAge,
    required this.lifeExpectancy,
    required this.monthlyExpenses,
    required this.preRetirementReturn,
    required this.postRetirementReturn,
    required this.currentInvestment,
    required this.inflationRate,
  });
}
