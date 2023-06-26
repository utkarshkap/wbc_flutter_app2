part of 'sip_calculator_bloc.dart';

@immutable
abstract class SIPCalculatorEvent {}

class SIPInsuranceData extends SIPCalculatorEvent {
  final int sipAmount;
  final int noOfYear;
  final int expectedReturn;

  SIPInsuranceData({
        required this.sipAmount,
        required this.noOfYear,
        required this.expectedReturn,
      });
}