// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wbc_connect_app/models/add_broker_holdings_data_model.dart';
import 'package:wbc_connect_app/repositories/brokers_repositories.dart';

part 'add_brokers_holding_data_event.dart';
part 'add_brokers_holding_data_state.dart';

class AddBrokersHoldingDataBloc
    extends Bloc<AddBrokersHoldingDataEvent, AddBrokersHoldingDataState> {
  AddBrokersHoldingDataBloc() : super(AddBrokersHoldingDataInitial()) {
    on<AddBrokerholdingsDataEvent>((event, emit) async {
      emit(AddBrokersHoldingDataAdding());
      try {
        final brokersRepo = BrokersRepo();
        final response =
            await brokersRepo.postBrokerholdingsData(holdings: event.holdings);

        if (response.statusCode == 200) {
          emit(AddBrokersHoldingDataLoaded(response.statusCode));
        } else {
          emit(const AddBrokersHoldingDataFailed());
        }
      } catch (error) {
        emit(const AddBrokersHoldingDataFailed());
      }
    });
  }
}
