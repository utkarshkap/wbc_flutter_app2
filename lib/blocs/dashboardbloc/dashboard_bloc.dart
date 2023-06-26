import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wbc_connect_app/models/family_member_model.dart';
import '../../core/api/api_consts.dart';
import '../../models/dashboard.dart';
import '../../repositories/dashboard_repositories.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<GetDashboardData>((event, emit) async {
      emit(DashboardDataLoading());
      await Future.delayed(const Duration(seconds: 3), () async {
        final dashboardRepo = DashboardRepo();
        final response = await dashboardRepo.getDashboardData(event.userId);

        final data = dashboardFromJson(response.data!.body);

        print('datafg-------${response.data!.statusCode}');

        print('getDashboard Response------$data');
        print('goldpoint------${data.data.goldPoint}');
        print('available contact------${data.data.availableContacts}');

        ApiUser.goldReferralPoint = data.data.goldPoint;
        response.data!.statusCode == 200
            ? emit(DashboardDataLoaded(data))
            : emit(DashboardFailed());
      });
    });

    on<UpdateTncData>((event, emit) async {
      emit(TNCValueAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final dashboardRepo = DashboardRepo();

        print('mobNo---------${event.mobNo}');
        print('tnc---------${event.tnc}');

        final response = await dashboardRepo.updateTNCValue(
            mobileNo: event.mobNo,
            tnc: event.tnc
        );

        final data = jsonDecode(response.body);

        print('responsebody---------${response.body}');
        print('responsebody---------${data["message"]}');
        print('----familyMember-----statuscode--=---${response.statusCode}');

        response.statusCode == 200
            ? emit(TNCValueUpdated())
            : emit(TNCValueFailed());
      });
    });

    on<SetFamilyMemberData>((event, emit) async {
      emit(FamilyMemberDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final dashboardRepo = DashboardRepo();

        print('userId---------${event.familyMemberModel.userid}');

        final response = await dashboardRepo.setFamilyMemberData(
            userId: event.familyMemberModel.userid,
            name: event.familyMemberModel.name,
            mobileNo: event.familyMemberModel.mobileNo,
            relation: event.familyMemberModel.relation);

        final data = jsonDecode(response.body);

        print('responsebody---------${response.body}');
        print('responsebody---------${data["message"]}');
        print('----familyMember-----statuscode--=---${response.statusCode}');

        response.statusCode == 200
            ? emit(FamilyMemberAdded(data["message"].toString()))
            : emit(FamilyMemberFailed());
      });
    });

  }
}