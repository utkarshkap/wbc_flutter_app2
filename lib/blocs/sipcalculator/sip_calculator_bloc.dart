import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/models/sip_calculator_model.dart';
import 'package:wbc_connect_app/repositories/sip_calculator_repositories.dart';
part 'sip_calculator_event.dart';
part 'sip_calculator_state.dart';

class SIPCalculatorBloc extends Bloc<SIPCalculatorEvent, SIPCalculatorState> {
  SIPCalculatorBloc() : super(SIPCalculatorInitial()) {
    on<SIPInsuranceData>((event, emit) async {
      emit(SIPCalculatorDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final sipCalRepo = SIPCalculatorRepo();

        final response = await sipCalRepo.setSIPCalculator(
          name: "",
          sipAmount: event.sipAmount,
          noOfYear: event.noOfYear,
          expectedReturn: event.expectedReturn,
        );

        final data = sipCalculatorFromJson(response.body);

        print('----sipCalculator-----statusCode--=---${response.statusCode}');

        response.statusCode == 200
            ? emit(SIPCalculatorAdded(
                maturityValue: data.maturityValue.toString(),
                investedAmount: data.investedAmount.toString(),
                returnValue: data.returnValue.toString(),
                isDataPosted: true))
            : emit(SIPCalculatorFailed());
      });
    });
  }
}
