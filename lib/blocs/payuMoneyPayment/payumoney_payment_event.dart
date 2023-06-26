part of 'payumoney_payment_bloc.dart';

@immutable
abstract class PayumoneyPaymentEvent {}

class LoadPayumoneyPaymentEvent extends PayumoneyPaymentEvent {
  final String amount;
  final String taxAmount;
  final String txnid;
  final String email;
  final String productinfo;
  final String firstname;
  final String user_credentials;

  LoadPayumoneyPaymentEvent({required this.amount,required this.taxAmount,required this.txnid,required this.email,required this.productinfo,
    required this.firstname,required this.user_credentials});
}

class UpdateFastTrackUserEvent extends PayumoneyPaymentEvent {
  final int userId;
  final String mobile;
  final String date;
  final String paymentAmount;
  final String taxAmount;

  UpdateFastTrackUserEvent({required this.userId,required this.mobile,required this.date,required this.paymentAmount,required this.taxAmount});
}
