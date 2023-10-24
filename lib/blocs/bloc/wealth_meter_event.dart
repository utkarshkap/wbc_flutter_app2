part of 'wealth_meter_bloc.dart';

@immutable
abstract class WealthMeterEvent {}

class WealthMeterDataEvent extends WealthMeterEvent {
  final num userId;
  final String name;
  final String dob;
  final num age;
  final double interestRate;
  final num business;
  final num salary;
  final num professional;
  final num spouseIncome;
  final num otherIncome;
  final num houseHoldMonthly;
  final num totalMonthlyEmi;
  final num totalInsurancePremiumYearly;
  final num childrenEducationYearly;
  final num otherExpenseYearly;
  final num vehicle;
  final num gold;
  final num savingAccount;
  final num cash;
  final num emergencyFunds;
  final num otherAsset;
  final num mutualFunds;
  final num pPF;
  final num sIPMonthly;
  final num pPFMonthly;
  final num debenture;
  final num fixedDeposite;
  final num stockPortfolio;
  final num guided;
  final num unguided;
  final num postOfficeOrVikasPatra;
  final num pMS;
  final num privateInvestmentScheme;
  final num realEstate;
  final num termInsurance;
  final num traditionalInsurance;
  final num uLIP;
  final num vehicleInsurance;
  final num otherInsurance;
  final num healthInsurance;
  final num housingLoan;
  final num mortgageLoan;
  final num educationLoan;
  final num personalLoan;
  final num vehicleLoan;
  final num overdraft;
  final num otherLoan;

  WealthMeterDataEvent({
    required this.userId,
    required this.name,
    required this.dob,
    required this.age,
    required this.interestRate,
    required this.business,
    required this.salary,
    required this.professional,
    required this.spouseIncome,
    required this.otherIncome,
    required this.houseHoldMonthly,
    required this.totalMonthlyEmi,
    required this.totalInsurancePremiumYearly,
    required this.childrenEducationYearly,
    required this.otherExpenseYearly,
    required this.vehicle,
    required this.gold,
    required this.savingAccount,
    required this.cash,
    required this.emergencyFunds,
    required this.otherAsset,
    required this.mutualFunds,
    required this.pPF,
    required this.sIPMonthly,
    required this.pPFMonthly,
    required this.debenture,
    required this.fixedDeposite,
    required this.stockPortfolio,
    required this.guided,
    required this.unguided,
    required this.postOfficeOrVikasPatra,
    required this.pMS,
    required this.privateInvestmentScheme,
    required this.realEstate,
    required this.termInsurance,
    required this.traditionalInsurance,
    required this.uLIP,
    required this.vehicleInsurance,
    required this.otherInsurance,
    required this.healthInsurance,
    required this.housingLoan,
    required this.mortgageLoan,
    required this.educationLoan,
    required this.personalLoan,
    required this.vehicleLoan,
    required this.overdraft,
    required this.otherLoan,
  });
}
