part of 'add_brokers_holding_data_bloc.dart';

abstract class AddBrokersHoldingDataEvent {}

class AddBrokerholdingsDataEvent extends AddBrokersHoldingDataEvent {
  final List<AddbrokerholdingsModel> holdings;

  AddBrokerholdingsDataEvent({required this.holdings});
}
