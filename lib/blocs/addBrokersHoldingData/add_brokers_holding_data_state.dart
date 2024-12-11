part of 'add_brokers_holding_data_bloc.dart';

abstract class AddBrokersHoldingDataState extends Equatable {
  const AddBrokersHoldingDataState();
}

class AddBrokersHoldingDataInitial extends AddBrokersHoldingDataState {
  @override
  List<Object> get props => [];
}

class AddBrokersHoldingDataAdding extends AddBrokersHoldingDataState {
  @override
  List<Object?> get props => [];
}

class AddBrokersHoldingDataLoaded extends AddBrokersHoldingDataState {
  final int code;
  // final List<AddbrokerholdingsModel> addHoldings;

  const AddBrokersHoldingDataLoaded(this.code);

  @override
  List<Object?> get props => [code];
}

class AddBrokersHoldingDataFailed extends AddBrokersHoldingDataState {
  // final String error;

  const AddBrokersHoldingDataFailed();
  @override
  List<Object?> get props => [];
}
