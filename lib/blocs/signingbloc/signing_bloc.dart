import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import '../../models/add_contacts_model.dart';
import '../../models/add_contacts_response_model.dart';
import '../../models/getuser_model.dart';
import '../../repositories/signing_repositories.dart';

part 'signing_event.dart';
part 'signing_state.dart';

class SigningBloc extends Bloc<SigningEvent, SigningState> {
  SigningBloc() : super(SigningInitial()) {
    on<CreateUser>((event, emit) async {
      emit(SigningDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final signingRepo = SigningRepository();

        final response = await signingRepo.setLoginUser(
            email: event.email,
            mobileNo: event.mobileNo,
            name: event.name,
            dob: event.dob,
            pincode: event.pincode,
            country: event.country,
            city: event.city,
            area: event.area,
            address: event.address,
            deviceId: event.deviceId,
            tnc: event.tnc);

        print('Create user status code-----${response.statusCode}');

        response.statusCode == 200
            ? emit(SigningDataAdded(response))
            : emit(SigningFailed());
      });

      // TODO: implement event handler
    });

    on<AddContactList>((event, emit) async {
      emit(AddContactLoading());
      await Future.delayed(const Duration(seconds: 3), () async {
        final signingRepo = SigningRepository();
        int count = 0;
        int nRIContactCount = 0;
        ApiUser.numberList = [];

        final response = await signingRepo.postContactsData(
            mobileNo: event.mobileNo,
            date: event.date,
            contacts: event.contacts);
        print("event.mobileNo:::::::::-::::::-::::${event.contacts}");

        final addContactResponse = addContactResponseFromJson(response.body);

        for (var element in addContactResponse.contacts) {
          if (element.status == "Accepted") {
            if (element.nriRefferal == true &&
                (element.country == '+91' || element.country == '')) {
              count++;
            } else if (element.nriRefferal == false) {
              count++;
            } else {
              nRIContactCount++;
            }
          } else {
            ApiUser.numberList.add(element.mobileNo);
          }
        }
        print('accepted contact count-----$count');

        final getUserData = await signingRepo.getUser(event.mobileNo);

        final data = getUserFromJson(getUserData.data!.body);

        response.statusCode == 200
            ? emit(AddContactLoaded(
                response,
                data.data!.uid.toString(),
                count.toString(),
                nRIContactCount.toString(),
                data.goldReferrals!))
            : emit(AddContactFailed());
      });

      // TODO: implement event handler
    });

    on<GetUserData>((event, emit) async {
      print('GetUser data call-------${event.mobileNo}-');

      emit(GetUserLoading());
      await Future.delayed(const Duration(seconds: 3), () async {
        final signingRepo = SigningRepository();
        final response = await signingRepo.getUser(event.mobileNo);

        final data = getUserFromJson(response.data!.body);

        print('data-------${response.data!.statusCode}');

        print('getUser Response------$data');
        print('contactData------${data.goldReferrals}');

        response.data!.statusCode == 200
            ? emit(GetUserLoaded(data))
            : emit(GetUserFailed());
      });

      // TODO: implement event handler
    });

    on<UserIdData>((event, emit) async {
      print('GetUser data call--------');

      emit(UserIdLoading());
      await Future.delayed(const Duration(seconds: 3), () async {
        final signingRepo = SigningRepository();
        final response = await signingRepo.getUser(event.mobileNo);

        final data = getUserFromJson(response.data!.body);

        print('data-------${response.data!.statusCode}');

        print('getUser Response------$data');
        print('contactData------${data.goldReferrals}');

        response.data!.statusCode == 200
            ? emit(UserIdLoaded(data))
            : emit(UserIdFailed());
      });
    });

    on<DeleteUserAccount>((event, emit) async {
      emit(DeleteUserAccountDataAdding());
      final signingRepo = SigningRepository();

      final response = await signingRepo.deleteUserAccount(event.mobileNo);
      emit(DeleteUserAccountDataAdded(response));
    });

    on<GetPendingDeleteUser>((event, emit) async {
      emit(PendingDeleteUserDataAdding());
      final signingRepo = SigningRepository();

      final response = await signingRepo.getPendingDeleteUser(event.mobileNo);
      emit(PendingDeleteUserDataAdded(response));
    });
  }
}
