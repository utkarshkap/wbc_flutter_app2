import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/models/investment_transaction_model.dart';

import '../../core/fetching_api.dart';
import '../../models/investment_portfolio_model.dart';
part 'mf_investments_event.dart';
part 'mf_investments_state.dart';

class MFInvestmentsBloc extends Bloc<MFInvestmentsEvent, MFInvestmentsState> {
  MFInvestmentsBloc() : super(MFInvestmentsInitial()) {
    on<LoadMFInvestmentsEvent>((event, emit) async {
      emit(MFInvestmentsInitial());
      try {
        final mfInvestments = await FetchingApi().getMFInvestment(event.userId);
        print('-----mfData---$mfInvestments');
        emit(MFInvestmentsLoadedState(mfInvestments));
      } catch (e) {
        emit(MFInvestmentsErrorState(e.toString()));
      }
    });
  }
}
