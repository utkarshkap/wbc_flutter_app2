part of 'insurance_calculator_bloc.dart';

@immutable
abstract class InsuranceCalculatorEvent {}

class PostInsuranceData extends InsuranceCalculatorEvent {

  final String name;
  final String gender;
  final int annualincome;
  final int existinglifecover;
  final int totalloandue;
  final int totalsaving;
  final DateTime insDate;
  final int totalHomeLoanDue;

  PostInsuranceData(
      {required this.name,
      required this.gender,
      required this.annualincome,
      required this.existinglifecover,
      required this.totalloandue,
      required this.totalsaving,
      required this.insDate,
      required this.totalHomeLoanDue,
      });
}