part of 'insurance_calculator_bloc.dart';

@immutable
abstract class InsuranceCalculatorState {}

class InsuranceCalculatorInitial extends InsuranceCalculatorState {}

class InsuranceCalculatorDataAdding extends InsuranceCalculatorState {}

class InsuranceCalculatorAdded extends InsuranceCalculatorState {
  final String requiredInsurance;
  final bool isDataPosted;

  InsuranceCalculatorAdded({required this.requiredInsurance, this.isDataPosted = false});
}

class InsuranceCalculatorFailed extends InsuranceCalculatorState {}
