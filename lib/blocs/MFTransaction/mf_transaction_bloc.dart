import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/models/investment_transaction_model.dart';

import '../../core/fetching_api.dart';
part 'mf_transaction_event.dart';
part 'mf_transaction_state.dart';

class MFTransactionBloc extends Bloc<MFTransactionEvent, MFTransactionState> {
  MFTransactionBloc() : super(MFTransactionInitial()) {
    on<LoadMFTransactionEvent>((event, emit) async {
      emit(MFTransactionInitial());
      try {
        final mfTransaction = await FetchingApi().getMFTransaction(event.userId,event.folioNo,event.schemeName);
        // log('-----mfData---$mfTransaction');
        emit(MFTransactionLoadedState(mfTransaction));
      } catch (e) {
        emit(MFTransactionErrorState(e.toString()));
      }
    });
  }
}