part of 'delete_family_member_bloc.dart';

@immutable
abstract class DeleteFamilyMemberEvent {}
class DeleteFamilyMember extends DeleteFamilyMemberEvent {
  final String mobNo;

  DeleteFamilyMember({required this.mobNo});
}
