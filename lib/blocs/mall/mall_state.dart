part of 'mall_bloc.dart';

abstract class MallState extends Equatable {
  const MallState();
}

class MallInitial extends MallState {
  @override
  List<Object> get props => [];
}

class MallDataInitial extends MallState {
  @override
  List<Object> get props => [];
}

class MallDataLoadedState extends MallState {
  final Popular popular;
  final NewArrival newArrival;
  final Trending trending;

  const MallDataLoadedState(this.popular,this.newArrival, this.trending);

  @override
  List<Object?> get props => [popular, newArrival, trending];
}

class MallDataErrorState extends MallState {
  final String error;

  const MallDataErrorState(this.error);

  @override
  List<Object?> get props => [error];
}