import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../../core/fetching_api.dart';
import '../../models/custom_payumoney_hashkey_model.dart';
import '../../repositories/fasttrack_repositories.dart';
part 'payumoney_payment_event.dart';
part 'payumoney_payment_state.dart';

class PayumoneyPaymentBloc extends Bloc<PayumoneyPaymentEvent, PayumoneyPaymentState> {
  PayumoneyPaymentBloc() : super(PayumoneyHashKeyInitial()) {

    on<LoadPayumoneyPaymentEvent>((event, emit) async {
      emit(PayumoneyHashKeyInitial());
      try {
        final createPayumoneyHashKey = await FetchingApi().createPayumoneyHashKeyAPI(event.amount,event.txnid,event.email,event.productinfo,event.firstname,event.user_credentials);
        print('-----mfData---$createPayumoneyHashKey');
        emit(PayumoneyHashKeyLoadedState(createPayumoneyHashKey));
      } catch (e) {
        emit(PayumoneyHashKeyErrorState(e.toString()));
      }
    });

    on<UpdateFastTrackUserEvent>((event, emit) async {
      emit(UpdateFastTrackUserAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final fastTrackRepo = FastTrackRepository();

        final response = await fastTrackRepo.updateFastTrackUserAPI(
            userId: event.userId,
            mobileNo: event.mobile,
            date: event.date,
            paymentAmount: event.paymentAmount
        );

        print('Create user status code-----${response.statusCode}');

        response.statusCode == 200
            ? emit(UpdateFastTrackUserAdded(response))
            : emit(UpdateFastTrackUserFailed());
      });
    });
  }

}