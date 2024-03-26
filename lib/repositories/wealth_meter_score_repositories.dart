import 'dart:convert';

import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/core/api/api_handler.dart';
import 'package:wbc_connect_app/models/wealth_meter_score_model.dart';

class WealthMeterScoreRepo {
  setWealthMeterScore({
    required int userId,
    required String name,
    required String dob,
    required int age,
    required double interestRate,
    required int business,
    required int salary,
    required int professional,
    required int spouseIncome,
    required int otherIncome,
    required int houseHoldMonthly,
    required int totalMonthlyEmi,
    required int totalInsurancePremiumYearly,
    required int childrenEducationYearly,
    required int otherExpenseYearly,
    required int vehicle,
    required int gold,
    required int savingAccount,
    required int cash,
    required int emergencyFunds,
    required int otherAsset,
    required int mutualFunds,
    required int pPF,
    required int sIPMonthly,
    required int pPFMonthly,
    required int debenture,
    required int fixedDeposite,
    required int stockPortfolio,
    required int guided,
    required int unguided,
    required int postOfficeOrVikasPatra,
    required int pMS,
    required int privateInvestmentScheme,
    required int realEstate,
    required int termInsurance,
    required int traditionalInsurance,
    required int uLIP,
    required int vehicleInsurance,
    required int otherInsurance,
    required int healthInsurance,
    required int housingLoan,
    required int mortgageLoan,
    required int educationLoan,
    required int personalLoan,
    required int vehicleLoan,
    required int overdraft,
    required int otherLoan,
  }) async {
    try {
      final data = jsonEncode(WealthMeterData(
          userId: userId,
          name: name,
          doB: dob,
          age: age,
          interestRate: interestRate,
          business: business,
          salary: salary,
          professional: professional,
          spouseIncome: spouseIncome,
          otherIncome: otherIncome,
          houseHoldMonthly: houseHoldMonthly,
          totalMonthlyEmi: totalMonthlyEmi,
          totalInsurancePremiumYearly: totalInsurancePremiumYearly,
          childrenEducationYearly: childrenEducationYearly,
          otherExpenseYearly: otherExpenseYearly,
          vehicle: vehicle,
          gold: gold,
          savingAccount: savingAccount,
          cash: cash,
          emergencyFunds: emergencyFunds,
          otherAsset: otherAsset,
          mutualFunds: mutualFunds,
          pPF: pPF,
          sIPMonthly: sIPMonthly,
          pPFMonthly: pPFMonthly,
          debenture: debenture,
          fixedDeposite: fixedDeposite,
          stockPortfolio: stockPortfolio,
          guided: guided,
          unguided: unguided,
          postOfficeOrVikasPatra: postOfficeOrVikasPatra,
          pMS: pMS,
          privateInvestmentScheme: privateInvestmentScheme,
          realEstate: realEstate,
          termInsurance: termInsurance,
          traditionalInsurance: traditionalInsurance,
          uLIP: uLIP,
          vehicleInsurance: vehicleInsurance,
          otherInsurance: otherInsurance,
          healthInsurance: healthInsurance,
          housingLoan: housingLoan,
          mortgageLoan: mortgageLoan,
          educationLoan: educationLoan,
          personalLoan: personalLoan,
          vehicleLoan: vehicleLoan,
          overdraft: overdraft,
          otherLoan: otherLoan));

      final response =
          await ApiHandler.post(url: wealthMeterScoreUrl, body: data);

      return response;
    } on BadRequestException {
      return ApiResponse.withError('Something went wrong', statusCode: 400);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to load page');
    }
  }
}
