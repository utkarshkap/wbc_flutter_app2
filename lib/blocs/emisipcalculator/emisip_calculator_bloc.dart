import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/models/emi_sip_calcularor_model.dart';
import '../../repositories/emisip_calculator_repositories.dart';
part 'emisip_calculator_event.dart';
part 'emisip_calculator_state.dart';

class EMISIPCalculatorBloc
    extends Bloc<EMISIPCalculatorEvent, EMISIPCalculatorState> {
  EMISIPCalculatorBloc() : super(EMISIPCalculatorInitial()) {
    on<EMISIPData>((event, emit) async {
      emit(EMISIPCalculatorDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final emiSipCalRepo = EMISIPCalculatorRepo();

        final response = await emiSipCalRepo.setSIPCalculator(
          name: event.name,
          loanAmount: event.loanAmount,
          noOfYear: event.noOfYear,
          loanInterestRate: event.loanInterestRate,
          interestRateOnInvestment: event.interestRateOnInvestment,
        );
        print('----insurancecalculator-----data--=---${response}');

        final data = emiSIPCalculatorFromJson(response.body);

        print(
            '----insurancecalculator-----statuscode--=---${response.statusCode}');

        response.statusCode == 200
            ? emit(EMISIPCalculatorAdded(
                isDataPosted: true,
                principalAmount: data.principalAmount.toString(),
                interestAmount: data.interestAmount.toString(),
                emiAmount: data.emiAmount.toString(),
                sipAmount: data.sipAmount.toString(),
                totalPayableAmount: data.totalPayableAmount.toString(),
              ))
            : emit(EMISIPCalculatorFailed());
      });
    });
  }
}
