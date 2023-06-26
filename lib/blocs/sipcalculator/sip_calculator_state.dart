part of 'sip_calculator_bloc.dart';

@immutable
abstract class SIPCalculatorState {}

class SIPCalculatorInitial extends SIPCalculatorState {}

class SIPCalculatorDataAdding extends SIPCalculatorState {}

class SIPCalculatorAdded extends SIPCalculatorState {
  final String investedAmount;
  final String maturityValue;
  final String returnValue;
  final bool isDataPosted;
  SIPCalculatorAdded({required this.maturityValue,required this.returnValue,required this.investedAmount, this.isDataPosted = false});
}

class SIPCalculatorFailed extends SIPCalculatorState {}