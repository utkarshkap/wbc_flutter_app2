part of 'emisip_calculator_bloc.dart';

@immutable
abstract class EMISIPCalculatorState {}

class EMISIPCalculatorInitial extends EMISIPCalculatorState {}

class EMISIPCalculatorDataAdding extends EMISIPCalculatorState {}

class EMISIPCalculatorAdded extends EMISIPCalculatorState {
  final String principalAmount;
  final String interestAmount;
  final String emiAmount;
  final String sipAmount;
  final String totalPayableAmount;
  final bool isDataPosted;

  EMISIPCalculatorAdded({
    required this.principalAmount,
    required this.interestAmount,
    required this.emiAmount,
    required this.sipAmount,
    required this.totalPayableAmount,
    this.isDataPosted = false
  });
}

class EMISIPCalculatorFailed extends EMISIPCalculatorState {}