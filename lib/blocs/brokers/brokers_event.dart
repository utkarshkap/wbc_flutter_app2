part of 'brokers_bloc.dart';

abstract class BrokersEvent {}

class LoadGetBrokersListEvent extends BrokersEvent {
  final GetBrokerListModel getBrokersList;

  LoadGetBrokersListEvent({required this.getBrokersList});
}
