part of 'mall_bloc.dart';

@immutable
abstract class MallEvent {}

class LoadMallDataEvent extends MallEvent {
  final Popular popular;
  final NewArrival newArrival;
  final Trending trending;

  LoadMallDataEvent({required this.popular,required this.newArrival,required this.trending});
}