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
  final List<GoldReferral> myContacts;

  AddContactLoaded(this.data, this.userId,this.acceptedContacts,this.myContacts);
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
