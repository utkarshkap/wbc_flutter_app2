part of 'wealth_meter_bloc.dart';

@immutable
abstract class WealthMeterState {}

class WealthMeterInitial extends WealthMeterState {}

class WealthMeterDataDataAdding extends WealthMeterState {}

class WealthMeterDataAdded extends WealthMeterState {
  final int totalScore;
  WealthMeterDataAdded({required this.totalScore});
}

class WealthMeterFailed extends WealthMeterState {}
