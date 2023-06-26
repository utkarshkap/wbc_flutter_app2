import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/fetching_api.dart';
import '../../models/insurance_investment_model.dart';

part 'insurance_investment_event.dart';
part 'insurance_investment_state.dart';

class InsuranceInvestmentBloc extends Bloc<InsuranceInvestmentEvent, InsuranceInvestmentState> {
  InsuranceInvestmentBloc() : super(InsuranceInvestmentInitial()) {
    on<LoadInsuranceInvestmentEvent>((event, emit) async {
      emit(InsuranceInvestmentInitial());
      try {
        final insuranceData = await FetchingApi().getInsuranceInvestment(event.userId,event.typeId,event.subTypeId);
        // log('-----mfData---$mfTransaction');
        emit(InsuranceInvestmentLoadedState(insuranceData));
      } catch (e) {
        emit(InsuranceInvestmentErrorState(e.toString()));
      }
    });
  }
}