import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../models/insurance_calculator_model.dart';
import '../../repositories/insurance_calculator_repo.dart';

part 'insurance_calculator_event.dart';
part 'insurance_calculator_state.dart';

class InsuranceCalculatorBloc extends Bloc<InsuranceCalculatorEvent, InsuranceCalculatorState> {
  InsuranceCalculatorBloc() : super(InsuranceCalculatorInitial()) {
    on<PostInsuranceData>((event, emit) async {
      emit(InsuranceCalculatorDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final insCalRepo = InsuranceCalculatorRepo();

        final response = await insCalRepo.setInsuranceCalculator(
            name: event.name,
            gender: event.gender,
            annualincome: event.annualincome,
            existinglifecoverunt: event.existinglifecover,
            totalloandue: event.totalloandue,
            totalsaving: event.totalsaving,
            insDate: event.insDate,
            homeloandue: event.totalHomeLoanDue,
        );

        final data = insurancecaluculatorFromJson(response.body);

        print('----insurancecalculator-----data--=---${data.requiredinsurance}');
        print('----insurancecalculator-----statuscode--=---${response.statusCode}');

        response.statusCode == 200
            ? emit(InsuranceCalculatorAdded(
                requiredInsurance: data.requiredinsurance.toString(),
                isDataPosted: true))
            : emit(InsuranceCalculatorFailed());
        // TODO: implement event handler);
      });
    });
  }
}