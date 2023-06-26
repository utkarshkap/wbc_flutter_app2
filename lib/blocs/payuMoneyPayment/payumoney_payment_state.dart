part of 'payumoney_payment_bloc.dart';

@immutable
abstract class PayumoneyPaymentState {}

class PayumoneyHashKeyInitial extends PayumoneyPaymentState {
  @override
  List<Object> get props => [];
}

class PayumoneyHashKeyLoadedState extends PayumoneyPaymentState {
  final CustomPayumoneyHashkeyModel customPayumoneyHashkeyModel;

  PayumoneyHashKeyLoadedState(this.customPayumoneyHashkeyModel);

  @override
  List<Object?> get props => [customPayumoneyHashkeyModel];
}

class PayumoneyHashKeyErrorState extends PayumoneyPaymentState {
  final String error;
  PayumoneyHashKeyErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class UpdateFastTrackUserAdding extends PayumoneyPaymentState {}

class UpdateFastTrackUserAdded extends PayumoneyPaymentState {
  final Response data;
  UpdateFastTrackUserAdded(this.data);
}

class UpdateFastTrackUserFailed extends PayumoneyPaymentState {}