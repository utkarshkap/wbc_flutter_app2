part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class GetDashboardData extends DashboardEvent {
  final String userId;
  GetDashboardData({required this.userId});
}

class UpdateTncData extends DashboardEvent {
  final String mobNo;
  final bool tnc;
  UpdateTncData({required this.mobNo,required this.tnc});
}

class SetFamilyMemberData extends DashboardEvent {
  final FamilyMemberModel familyMemberModel;
  SetFamilyMemberData({required this.familyMemberModel});
}