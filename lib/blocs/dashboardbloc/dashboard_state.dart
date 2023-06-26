part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardDataLoading extends DashboardState {}

class DashboardDataLoaded extends DashboardState {
  final Dashboard? data;

  DashboardDataLoaded(this.data);
}

class DashboardFailed extends DashboardState {}

class TNCInitial extends DashboardState {}

class TNCValueAdding extends DashboardState {}

class TNCValueUpdated extends DashboardState {}

class TNCValueFailed extends DashboardState {}

class FamilyMemberInitial extends DashboardState {}

class FamilyMemberDataAdding extends DashboardState {}

class FamilyMemberAdded extends DashboardState {
  final String message;

  FamilyMemberAdded(this.message);
}

class FamilyMemberFailed extends DashboardState {}
