import 'dart:convert';

import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/core/api/api_handler.dart';
import 'package:wbc_connect_app/models/wealth_meter_score_model.dart';

class WealthMeterScoreRepo {
  setWealthMeterScore({
    required num userId,
    required String name,
    required String dob,
    required num age,
    required double interestRate,
    required num business,
    required num salary,
    required num professional,
    required num spouseIncome,
    required num otherIncome,
    required num houseHoldMonthly,
    required num totalMonthlyEmi,
    required num totalInsurancePremiumYearly,
    required num childrenEducationYearly,
    required num otherExpenseYearly,
    required num vehicle,
    required num gold,
    required num savingAccount,
    required num cash,
    required num emergencyFunds,
    required num otherAsset,
    required num mutualFunds,
    required num pPF,
    required num sIPMonthly,
    required num pPFMonthly,
    required num debenture,
    required num fixedDeposite,
    required num stockPortfolio,
    required num guided,
    required num unguided,
    required num postOfficeOrVikasPatra,
    required num pMS,
    required num privateInvestmentScheme,
    required num realEstate,
    required num termInsurance,
    required num traditionalInsurance,
    required num uLIP,
    required num vehicleInsurance,
    required num otherInsurance,
    required num healthInsurance,
    required num housingLoan,
    required num mortgageLoan,
    required num educationLoan,
    required num personalLoan,
    required num vehicleLoan,
    required num overdraft,
    required num otherLoan,
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
