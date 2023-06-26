part of 'delete_family_member_bloc.dart';

@immutable
abstract class DeleteFamilyMemberState {}


class DeleteFamilyMemberInitial extends DeleteFamilyMemberState {}

class DeleteFamilyMemberLoading extends DeleteFamilyMemberState {}

class DeletedFamilyMember extends DeleteFamilyMemberState {
  final String mobNo;
  DeletedFamilyMember({required this.mobNo});
}

class DeleteFamilyMemberFailed extends DeleteFamilyMemberState {}
