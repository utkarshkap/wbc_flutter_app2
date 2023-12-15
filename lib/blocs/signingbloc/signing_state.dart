part of 'signing_bloc.dart';

@immutable
abstract class SigningState {}

class SigningInitial extends SigningState {}

class SigningDataAdding extends SigningState {}

class SigningDataAdded extends SigningState {
  final Response data;

  SigningDataAdded(this.data);
}

class SigningFailed extends SigningState {}

class AddContactLoading extends SigningState {}

class AddContactLoaded extends SigningState {
  final Response data;
  final String userId;
  final String acceptedContacts;
  final String acceptedNRIContacts;
  final List<GoldReferral> myContacts;

  AddContactLoaded(
      this.data, this.userId, this.acceptedContacts,this.acceptedNRIContacts, this.myContacts);
}

class AddContactFailed extends SigningState {}

class GetUserLoading extends SigningState {}

class GetUserLoaded extends SigningState {
  final GetUser? data;

  GetUserLoaded(this.data);
}

class GetUserFailed extends SigningState {}

class UserIdLoading extends SigningState {}

class UserIdLoaded extends SigningState {
  final GetUser? data;

  UserIdLoaded(this.data);
}

class UserIdFailed extends SigningState {}

class PendingDeleteUserDataAdding extends SigningState {}

class PendingDeleteUserDataAdded extends SigningState {
  final String message;

  PendingDeleteUserDataAdded(this.message);
}

class PendingDeleteUserFailed extends SigningState {}

class DeleteUserAccountDataAdding extends SigningState {}

class DeleteUserAccountDataAdded extends SigningState {
  final int code;

  DeleteUserAccountDataAdded(this.code);
}

class DeleteUserAccountFailed extends SigningState {}
