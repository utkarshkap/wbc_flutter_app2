import 'dart:convert';

WealthMeterScoreModel wealthMeterScoreModelFromJson(String str) =>
    WealthMeterScoreModel.fromJson(json.decode(str));

String wealthMeterScoreModelToJson(WealthMeterScoreModel data) =>
    json.encode(data.toJson());

class WealthMeterScoreModel {
  int code;
  String message;
  Scores scores;

  WealthMeterScoreModel(
      {required this.code, required this.message, required this.scores});

  factory WealthMeterScoreModel.fromJson(Map<String, dynamic> json) =>
      WealthMeterScoreModel(
        code: json["code"],
        message: json["message"] ?? ' ',
        scores: Scores.fromJson(json["scores"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "scores": scores.toJson(),
      };
}

class Scores {
  int emergencyFactor;
  int insuranceFactor;
  int assetVsLiabityFactor;
  int incomveVsInvestmentFactor;
  int incomeVsHouseHoldExpenseFactor;
  int incomeVsEMIFactor;
  int assetVsInsuranceFactor;
  int sipVsEMIFactor;
  int ageFactor;
  int healthInsuranceFactor;
  int generalInsuranceFactor;
  int totalScore;

  Scores(
      {required this.emergencyFactor,
      required this.insuranceFactor,
      required this.assetVsLiabityFactor,
      required this.incomveVsInvestmentFactor,
      required this.incomeVsHouseHoldExpenseFactor,
      required this.incomeVsEMIFactor,
      required this.assetVsInsuranceFactor,
      required this.sipVsEMIFactor,
      required this.ageFactor,
      required this.healthInsuranceFactor,
      required this.generalInsuranceFactor,
      required this.totalScore});

  factory Scores.fromJson(Map<String, dynamic> json) => Scores(
        emergencyFactor: json['emergencyFactor'],
        insuranceFactor: json['insuranceFactor'],
        assetVsLiabityFactor: json['assetVsLiabityFactor'],
        incomveVsInvestmentFactor: json['incomveVsInvestmentFactor'],
        incomeVsHouseHoldExpenseFactor: json['incomeVsHouseHoldExpenseFactor'],
        incomeVsEMIFactor: json['incomeVsEMIFactor'],
        assetVsInsuranceFactor: json['assetVsInsuranceFactor'],
        sipVsEMIFactor: json['sipVsEMIFactor'],
        ageFactor: json['ageFactor'],
        healthInsuranceFactor: json['healthInsuranceFactor'],
        generalInsuranceFactor: json['generalInsuranceFactor'],
        totalScore: json['totalScore'],
      );

  Map<String, dynamic> toJson() => {
        'emergencyFactor': emergencyFactor,
        'insuranceFactor': insuranceFactor,
        'assetVsLiabityFactor': assetVsLiabityFactor,
        'incomveVsInvestmentFactor': incomveVsInvestmentFactor,
        'incomeVsHouseHoldExpenseFactor': incomeVsHouseHoldExpenseFactor,
        'incomeVsEMIFactor': incomeVsEMIFactor,
        'assetVsInsuranceFactor': assetVsInsuranceFactor,
        'sipVsEMIFactor': sipVsEMIFactor,
        'ageFactor': ageFactor,
        'healthInsuranceFactor': healthInsuranceFactor,
        'generalInsuranceFactor': generalInsuranceFactor,
        'totalScore': totalScore,
      };
}

//
//
//

class WealthMeterData {
  int userId;
  String name;
  String doB;
  int age;
  double interestRate;
  int business;
  int salary;
  int professional;
  int spouseIncome;
  int otherIncome;
  int houseHoldMonthly;
  int totalMonthlyEmi;
  int totalInsurancePremiumYearly;
  int childrenEducationYearly;
  int otherExpenseYearly;
  int vehicle;
  int gold;
  int savingAccount;
  int cash;
  int emergencyFunds;
  int otherAsset;
  int mutualFunds;
  int pPF;
  int sIPMonthly;
  int pPFMonthly;
  int debenture;
  int fixedDeposite;
  int stockPortfolio;
  int guided;
  int unguided;
  int postOfficeOrVikasPatra;
  int pMS;
  int privateInvestmentScheme;
  int realEstate;
  int termInsurance;
  int traditionalInsurance;
  int uLIP;
  int vehicleInsurance;
  int otherInsurance;
  int healthInsurance;
  int housingLoan;
  int mortgageLoan;
  int educationLoan;
  int personalLoan;
  int vehicleLoan;
  int overdraft;
  int otherLoan;

  WealthMeterData(
      {required this.userId,
      required this.name,
      required this.doB,
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
      required this.otherLoan});

  factory WealthMeterData.fromJson(Map<String, dynamic> json) =>
      WealthMeterData(
        userId: json['UserId'],
        name: json['Name'],
        doB: json['DoB'],
        age: json['Age'],
        interestRate: json['InterestRate'],
        business: json['Business'],
        salary: json['Salary'],
        professional: json['Professional'],
        spouseIncome: json['SpouseIncome'],
        otherIncome: json['OtherIncome'],
        houseHoldMonthly: json['HouseHoldMonthly'],
        totalMonthlyEmi: json['TotalMonthlyEmi'],
        totalInsurancePremiumYearly: json['TotalInsurancePremiumYearly'],
        childrenEducationYearly: json['ChildrenEducationYearly'],
        otherExpenseYearly: json['OtherExpenseYearly'],
        vehicle: json['Vehicle'],
        gold: json['Gold'],
        savingAccount: json['SavingAccount'],
        cash: json['Cash'],
        emergencyFunds: json['EmergencyFunds'],
        otherAsset: json['OtherAsset'],
        mutualFunds: json['MutualFunds'],
        pPF: json['PPF'],
        sIPMonthly: json['SIPMonthly'],
        pPFMonthly: json['PPFMonthly'],
        debenture: json['Debenture'],
        fixedDeposite: json['FixedDeposite'],
        stockPortfolio: json['StockPortfolio'],
        guided: json['Guided'],
        unguided: json['Unguided'],
        postOfficeOrVikasPatra: json['PostOfficeOrVikasPatra'],
        pMS: json['PMS'],
        privateInvestmentScheme: json['PrivateInvestmentScheme'],
        realEstate: json['RealEstate'],
        termInsurance: json['TermInsurance'],
        traditionalInsurance: json['TraditionalInsurance'],
        uLIP: json['ULIP'],
        vehicleInsurance: json['VehicleInsurance'],
        otherInsurance: json['OtherInsurance'],
        healthInsurance: json['HealthInsurance'],
        housingLoan: json['HousingLoan'],
        mortgageLoan: json['MortgageLoan'],
        educationLoan: json['EducationLoan'],
        personalLoan: json['PersonalLoan'],
        vehicleLoan: json['VehicleLoan'],
        overdraft: json['Overdraft'],
        otherLoan: json['OtherLoan'],
      );

  Map<String, dynamic> toJson() => {
        'UserId': userId,
        'Name': name,
        'DoB': doB,
        'Age': age,
        'InterestRate': interestRate,
        'Business': business,
        'Salary': salary,
        'Professional': professional,
        'SpouseIncome': spouseIncome,
        'OtherIncome': otherIncome,
        'HouseHoldMonthly': houseHoldMonthly,
        'TotalMonthlyEmi': totalMonthlyEmi,
        'TotalInsurancePremiumYearly': totalInsurancePremiumYearly,
        'ChildrenEducationYearly': childrenEducationYearly,
        'OtherExpenseYearly': otherExpenseYearly,
        'Vehicle': vehicle,
        'Gold': gold,
        'SavingAccount': savingAccount,
        'Cash': cash,
        'EmergencyFunds': emergencyFunds,
        'OtherAsset': otherAsset,
        'MutualFunds': mutualFunds,
        'PPF': pPF,
        'SIPMonthly': sIPMonthly,
        'PPFMonthly': pPFMonthly,
        'Debenture': debenture,
        'FixedDeposite': fixedDeposite,
        'StockPortfolio': stockPortfolio,
        'Guided': guided,
        'Unguided': unguided,
        'PostOfficeOrVikasPatra': postOfficeOrVikasPatra,
        'PMS': pMS,
        'PrivateInvestmentScheme': privateInvestmentScheme,
        'RealEstate': realEstate,
        'TermInsurance': termInsurance,
        'TraditionalInsurance': traditionalInsurance,
        'ULIP': uLIP,
        'VehicleInsurance': vehicleInsurance,
        'OtherInsurance': otherInsurance,
        'HealthInsurance': healthInsurance,
        'HousingLoan': housingLoan,
        'MortgageLoan': mortgageLoan,
        'EducationLoan': educationLoan,
        'PersonalLoan': personalLoan,
        'VehicleLoan': vehicleLoan,
        'Overdraft': overdraft,
        'OtherLoan': otherLoan,
      };
}
