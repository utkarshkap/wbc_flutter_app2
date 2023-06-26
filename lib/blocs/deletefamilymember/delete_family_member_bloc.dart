import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repositories/dashboard_repositories.dart';

part 'delete_family_member_event.dart';

part 'delete_family_member_state.dart';

class DeleteFamilyMemberBloc
    extends Bloc<DeleteFamilyMemberEvent, DeleteFamilyMemberState> {
  DeleteFamilyMemberBloc() : super(DeleteFamilyMemberInitial()) {

    on<DeleteFamilyMember>((event, emit) async {
      emit(DeleteFamilyMemberLoading());
      await Future.delayed(const Duration(seconds: 3), () async {
        final dashboardRepo = DashboardRepo();

        print('userId---------${event.mobNo}');

        final response =
            await dashboardRepo.deleteFamilyMemberData(mobileNo: event.mobNo);
        print('responsebody---------${response.body}');
        print('----familyMember-----statuscode--=---${response.statusCode}');

        response.statusCode == 200
            ? emit(DeletedFamilyMember(mobNo: event.mobNo))
            : emit(DeleteFamilyMemberFailed());
      });
    });
  }
}
