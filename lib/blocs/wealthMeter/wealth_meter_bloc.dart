import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/models/wealth_meter_score_model.dart';
import 'package:wbc_connect_app/repositories/wealth_meter_score_repositories.dart';

part 'wealth_meter_event.dart';
part 'wealth_meter_state.dart';

class WealthMeterBloc extends Bloc<WealthMeterEvent, WealthMeterState> {
  WealthMeterBloc() : super(WealthMeterInitial()) {
    on<WealthMeterDataEvent>((event, emit) async {
      emit(WealthMeterDataDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final wealthMeterRepo = WealthMeterScoreRepo();
        final response = await wealthMeterRepo.setWealthMeterScore(
            userId: event.userId,
            name: event.name,
            dob: event.dob,
            age: event.age,
            interestRate: event.interestRate,
            business: event.business,
            salary: event.salary,
            professional: event.professional,
            spouseIncome: event.spouseIncome,
            otherIncome: event.otherIncome,
            houseHoldMonthly: event.houseHoldMonthly,
            totalMonthlyEmi: event.totalMonthlyEmi,
            totalInsurancePremiumYearly: event.totalInsurancePremiumYearly,
            childrenEducationYearly: event.childrenEducationYearly,
            otherExpenseYearly: event.otherExpenseYearly,
            vehicle: event.vehicle,
            gold: event.gold,
            savingAccount: event.savingAccount,
            cash: event.cash,
            emergencyFunds: event.emergencyFunds,
            otherAsset: event.otherAsset,
            mutualFunds: event.mutualFunds,
            pPF: event.pPF,
            sIPMonthly: event.sIPMonthly,
            pPFMonthly: event.pPFMonthly,
            debenture: event.debenture,
            fixedDeposite: event.fixedDeposite,
            stockPortfolio: event.stockPortfolio,
            guided: event.guided,
            unguided: event.unguided,
            postOfficeOrVikasPatra: event.postOfficeOrVikasPatra,
            pMS: event.pMS,
            privateInvestmentScheme: event.privateInvestmentScheme,
            realEstate: event.realEstate,
            termInsurance: event.termInsurance,
            traditionalInsurance: event.traditionalInsurance,
            uLIP: event.uLIP,
            vehicleInsurance: event.vehicleInsurance,
            otherInsurance: event.otherInsurance,
            healthInsurance: event.healthInsurance,
            housingLoan: event.housingLoan,
            mortgageLoan: event.mortgageLoan,
            educationLoan: event.educationLoan,
            personalLoan: event.personalLoan,
            vehicleLoan: event.vehicleLoan,
            overdraft: event.overdraft,
            otherLoan: event.otherLoan);

        final data = wealthMeterScoreModelFromJson(response.body);

        response.statusCode == 200
            ? emit(WealthMeterDataAdded(totalScore: data.scores.totalScore))
            : emit(WealthMeterFailed());
      });
    });
  }
}
