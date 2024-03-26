part of 'wealth_meter_bloc.dart';

@immutable
abstract class WealthMeterEvent {}

class WealthMeterDataEvent extends WealthMeterEvent {
  final int userId;
  final String name;
  final String dob;
  final int age;
  final double interestRate;
  final int business;
  final int salary;
  final int professional;
  final int spouseIncome;
  final int otherIncome;
  final int houseHoldMonthly;
  final int totalMonthlyEmi;
  final int totalInsurancePremiumYearly;
  final int childrenEducationYearly;
  final int otherExpenseYearly;
  final int vehicle;
  final int gold;
  final int savingAccount;
  final int cash;
  final int emergencyFunds;
  final int otherAsset;
  final int mutualFunds;
  final int pPF;
  final int sIPMonthly;
  final int pPFMonthly;
  final int debenture;
  final int fixedDeposite;
  final int stockPortfolio;
  final int guided;
  final int unguided;
  final int postOfficeOrVikasPatra;
  final int pMS;
  final int privateInvestmentScheme;
  final int realEstate;
  final int termInsurance;
  final int traditionalInsurance;
  final int uLIP;
  final int vehicleInsurance;
  final int otherInsurance;
  final int healthInsurance;
  final int housingLoan;
  final int mortgageLoan;
  final int educationLoan;
  final int personalLoan;
  final int vehicleLoan;
  final int overdraft;
  final int otherLoan;

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
