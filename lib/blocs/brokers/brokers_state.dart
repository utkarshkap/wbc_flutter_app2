part of 'brokers_bloc.dart';

abstract class BrokersState extends Equatable {
  const BrokersState();
}

class BrokersInitial extends BrokersState {
  @override
  List<Object> get props => [];
}

class GetBrokersListInitial extends BrokersState {
  @override
  List<Object> get props => [];
}

class GetBrokersListLoadedState extends BrokersState {
  final GetBrokerListModel getBroker;

  const GetBrokersListLoadedState(this.getBroker);

  @override
  List<Object?> get props => [getBroker];
}

class GetBrokersListErrorState extends BrokersState {
  final String error;

  const GetBrokersListErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
