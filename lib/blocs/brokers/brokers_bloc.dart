import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wbc_connect_app/core/fetching_api.dart';
import 'package:wbc_connect_app/models/get_brokerList_model.dart';

part 'brokers_event.dart';
part 'brokers_state.dart';

class BrokersBloc extends Bloc<BrokersEvent, BrokersState> {
  BrokersBloc() : super(BrokersInitial()) {
    on<BrokersEvent>((event, emit) async {
      emit(GetBrokersListInitial());
      try {
        final faqData = await FetchingApi().getBrokerList();
        emit(GetBrokersListLoadedState(faqData));
      } catch (e) {
        emit(GetBrokersListErrorState(e.toString()));
      }
    });
  }
}
