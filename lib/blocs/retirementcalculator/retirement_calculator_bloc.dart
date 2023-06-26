import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/retirement_calculator_model.dart';
import '../../repositories/retirement_calculator_repositories.dart';
part 'retirement_calculator_event.dart';
part 'retirement_calculator_state.dart';

class RetirementCalculatorBloc extends Bloc<RetirementCalculatorEvent, RetirementCalculatorState> {
  RetirementCalculatorBloc() : super(RetirementCalculatorInitial()) {
    on<RetirementData>((event, emit) async {
      emit(RetirementCalculatorDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final retirementCalRepo = RetirementCalculatorRepo();

        final response = await retirementCalRepo.setRetirementCalculator(
          name: event.name,
          currentAge: event.currentAge,
          retirementAge: event.retirementAge,
          lifeExpectancy: event.lifeExpectancy,
          monthlyExpenses: event.monthlyExpenses,
          preRetirementReturn: event.preRetirementReturn,
          postRetirementReturn: event.postRetirementReturn,
          currentInvestment: event.currentInvestment,
          inflationRate: event.inflationRate,
        );

        final data = retirementCalculatorFromJson(response.body);

        print('----retirementCalculator-----statuscode--=---${response.statusCode}');

        response.statusCode == 200
            ? emit(RetirementCalculatorAdded(
            isDataPosted: true,
            corpusAfterRetirement: data.corpusAfterRetirement,
            investmentRequired: data.investmentRequired,
            inflationAdjustedExpense: data.inflationAdjustedExpense
        )) : emit(RetirementCalculatorFailed());
      });
    });
  }
}
