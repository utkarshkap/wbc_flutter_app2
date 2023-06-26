part of 'retirement_calculator_bloc.dart';

@immutable
abstract class RetirementCalculatorState {}

class RetirementCalculatorInitial extends RetirementCalculatorState {}

class RetirementCalculatorDataAdding extends RetirementCalculatorState {}

class RetirementCalculatorAdded extends RetirementCalculatorState {
  final String corpusAfterRetirement;
  final String investmentRequired;
  final String inflationAdjustedExpense;
  final bool isDataPosted;

  RetirementCalculatorAdded({required this.corpusAfterRetirement,required this.investmentRequired,required this.inflationAdjustedExpense, this.isDataPosted = false});
}

class RetirementCalculatorFailed extends RetirementCalculatorState {}
