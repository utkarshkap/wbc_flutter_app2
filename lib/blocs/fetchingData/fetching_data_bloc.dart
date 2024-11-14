import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/models/add_broker_holdings_data_model.dart';
import 'package:wbc_connect_app/models/country_model.dart';
import 'package:wbc_connect_app/models/get_brokerList_model.dart';
import 'package:wbc_connect_app/models/get_broker_holding_model.dart';
import 'package:wbc_connect_app/models/get_icici_holdingData_model.dart';
import 'package:wbc_connect_app/models/get_icici_session_token_model.dart';
import 'package:wbc_connect_app/models/get_iifl_holding_model.dart';
import 'package:wbc_connect_app/models/insurance_company_model.dart';
import 'package:wbc_connect_app/models/loan_banks_model.dart';
import '../../core/fetching_api.dart';
import '../../models/expanded_category_model.dart';
import '../../models/faq_model.dart';
import '../../models/get_5Paisa_holding_model.dart';
import '../../models/get_5paisa_access_token_model.dart';
import '../../models/get_fyers_access_token_model.dart';
import '../../models/get_fyers_holdings_model.dart';
import '../../models/get_gmail_inbox_model.dart';
import '../../models/insurance_category_model.dart';
import '../../models/loan_investment_model.dart';
import '../../models/mGain_investment_model.dart';
import '../../models/mGain_ledger_model.dart';
import '../../models/munafe_ki_class_model.dart';
import '../../models/product_category_model.dart';
import '../../models/state_model.dart';
import '../../models/stock_investment_model.dart';
import '../../models/terms_conditions_model.dart';
import '../../repositories/brokers_repositories.dart';

part 'fetching_data_event.dart';
part 'fetching_data_state.dart';

class FetchingDataBloc extends Bloc<FetchingDataEvent, FetchingDataState> {
  FetchingDataBloc() : super(FetchingDataInitial()) {
    on<LoadProductCategoryEvent>((event, emit) async {
      emit(ProductCategoryInitial());
      try {
        print('-=-------productCategory');
        final productCategoryData = await FetchingApi().getProductCategory();
        emit(ProductCategoryLoadedState(productCategoryData));
      } catch (e) {
        emit(ProductCategoryErrorState(e.toString()));
      }
    });

    on<LoadExpandedCategoryEvent>((event, emit) async {
      emit(ExpandedCategoryInitial());
      try {
        print('-=-------expandedCategory----${event.id}');
        final expandedCategoryData =
            await FetchingApi().getExpandedCategory(event.id);
        emit(ExpandedCategoryLoadedState(expandedCategoryData));
      } catch (e) {
        emit(ExpandedCategoryErrorState(e.toString()));
      }
    });

    on<LoadStatesEvent>((event, emit) async {
      emit(StatesInitial());
      try {
        print('-=-------states');
        final statesData = await FetchingApi().getStates();
        emit(StatesLoadedState(statesData));
      } catch (e) {
        emit(StatesErrorState(e.toString()));
      }
    });

    on<LoadCountriesEvent>((event, emit) async {
      emit(CountriesInitial());
      try {
        print('-=-------Countries');
        final countriesData = await FetchingApi().getCountries();
        emit(CountriesLoadedState(countriesData));
      } catch (e) {
        emit(CountriesErrorState(e.toString()));
      }
    });

    on<LoadLoanBanksEvent>((event, emit) async {
      emit(LoanBanksInitial());
      try {
        print('-=-------Loan Banks');

        final banksData = await FetchingApi().getLoanBanks();
        emit(LoanBanksLoadedState(banksData));
      } catch (e) {
        emit(LoanBanksErrorState(e.toString()));
      }
    });

    on<LoadInsuranceCompanyEvent>((event, emit) async {
      emit(InsuranceCompanyInitial());
      try {
        print('-=-------Insurance Company');
        final companyData = await FetchingApi().getInsuranceCompany();
        emit(InsuranceCompanyLoadedState(companyData));
      } catch (e) {
        emit(InsuranceCompanyErrorState(e.toString()));
      }
    });

    on<LoadInsuranceCategoryEvent>((event, emit) async {
      emit(InsuranceCategoryInitial());
      try {
        print('-=-------Insurance Category');
        final categoryData = await FetchingApi().getInsuranceCategory();
        emit(InsuranceCategoryLoadedState(categoryData));
      } catch (e) {
        emit(InsuranceCategoryErrorState(e.toString()));
      }
    });

    on<LoadMGainInvestmentEvent>((event, emit) async {
      emit(MGainInvestmentInitial());
      try {
        final investmentData =
            await FetchingApi().getMGainInvestment(event.userId);
        emit(MGainInvestmentLoadedState(investmentData));
      } catch (e) {
        emit(MGainInvestmentErrorState(e.toString()));
      }
    });

    on<LoadMGainLedgerEvent>((event, emit) async {
      emit(MGainLedgerInitial());
      try {
        print('---=----mGainId--=----${event.mGainId}');
        final ledgerData = await FetchingApi()
            .getMGainLedger(event.mGainId, event.accountId, event.docType);
        emit(MGainLedgerLoadedState(ledgerData));
      } catch (e) {
        emit(MGainLedgerErrorState(e.toString()));
      }
    });

    on<LoadStockInvestmentEvent>((event, emit) async {
      print('----LoadStockInvestmentEvent');

      emit(StockInvestmentInitial());
      try {
        final stockData = await FetchingApi().getStockInvestment(event.userId);
        log('-----stockData---$stockData');

        emit(StockInvestmentLoadedState(stockData));
      } catch (e) {
        log("StockInvestmentErrorState--->");
        emit(StockInvestmentErrorState(e.toString()));
      }
    });

    on<LoadLoanInvestmentEvent>((event, emit) async {
      emit(LoanInvestmentInitial());
      try {
        final loanData = await FetchingApi().getLoanInvestment(event.userId);

        print('loandata-------$loanData');
        emit(LoanInvestmentLoadedState(loanData));
      } catch (e) {
        emit(LoanInvestmentErrorState(e.toString()));
      }
    });

    on<LoadMunafeKiClassEvent>((event, emit) async {
      emit(MunafeKiClassInitial());
      try {
        final mkcData = await FetchingApi().getMunafeKiClass();
        emit(MunafeKiClassLoadedState(mkcData));
      } catch (e) {
        emit(MunafeKiClassErrorState(e.toString()));
      }
    });

    on<LoadTermsConditionsEvent>((event, emit) async {
      emit(TermsConditionsInitial());
      try {
        final tcData = await FetchingApi().getTermsConditions();
        emit(TermsConditionsLoadedState(tcData));
      } catch (e) {
        emit(TermsConditionsErrorState(e.toString()));
      }
    });

    on<LoadFAQEvent>((event, emit) async {
      emit(TermsConditionsInitial());
      try {
        final faqData = await FetchingApi().getFaqs();
        emit(FAQLoadedState(faqData));
      } catch (e) {
        emit(FAQErrorState(e.toString()));
      }
    });

    on<LoadGmailInboxEvent>((event, emit) async {
      emit(GetGmailInboxInitial());
      try {
        final gmailInboxData =
            await FetchingApi().getGmailInboxAPI(event.accessToken);
        emit(GetGmailInboxLoadedState(gmailInboxData));
      } catch (e) {
        emit(GetGmailInboxErrorState(e.toString()));
      }
    });

    on<LoadFyersAccessTokenEvent>((event, emit) async {
      emit(GetFyersAccessTokenInitial());
      try {
        final fyersAccessTokenData =
            await FetchingApi().getFyersAccessTokenAPI();
        emit(GetFyersAccessTokenLoadedState(fyersAccessTokenData));
      } catch (e) {
        emit(GetFyersAccessTokenErrorState(e.toString()));
      }
    });

    on<LoadFyersHoldingsEvent>((event, emit) async {
      emit(GetFyersHoldingsInitial());
      try {
        final fyersAccessTokenData =
            await FetchingApi().getFyersHoldingsAPI(event.fyersAccessToken);
        emit(GetFyersHoldingsLoadedState(fyersAccessTokenData));
      } catch (e) {
        emit(GetFyersHoldingsErrorState(e.toString()));
      }
    });

    on<Load5PaisaAccessTokenEvent>((event, emit) async {
      emit(Get5PaisaAccessTokenInitial());
      await Future.delayed(const Duration(seconds: 3), () async {
        final brokersRepo = BrokersRepo();
        final response = await brokersRepo.get5PaisaAccessTokenData(
            RequestToken: event.requestToken);
        print('----5PAisaAccessToken-----data--=---${response}');
        final data = get5PaisaAccessTokenFromJson(response.body);

        print(
            '----5PAisaAccessToken-----statuscode--=---${response.statusCode}');
        response.statusCode == 200
            ? emit(Get5PaisaAccessTokenLoadedState(
                accessToken: data.body!.accessToken.toString(),
                clientId: data.body!.clientCode.toString()))
            : emit(Get5PaisaAccessTokenErrorState());
      });
    });

    on<Load5PaisaHoldingsEvent>((event, emit) async {
      emit(Get5PaisaHoldingsInitial());
      await Future.delayed(const Duration(seconds: 3), () async {
        final brokersRepo = BrokersRepo();

        print("event.clientCode--->${event.clientCode}");
        print("event.accessToken--->${event.accessToken}");
        final response = await brokersRepo.get5PaisaHoldingsData(
            ClientCode: event.clientCode, AccessToken: event.accessToken);

        print('----5PaisaHoldings-----statuscode--=---${response.statusCode}');
        print("-------5PaisaHoldings-----Response-${response}");
        if (response.statusCode == 200) {
          var responseData = get5PaisaHoldingFromJson(response.body);
          emit(Get5PaisaHoldingsLoadedState(responseData));
        } else {
          emit(Get5PaisaHoldingsErrorState());
        }
        // response.statusCode == 200
        //     ? emit(Get5PaisaHoldingsLoadedState(response))
        //     : emit(Get5PaisaHoldingsErrorState());
      });
    });

    on<LoadAngelHoldingsEvent>((event, emit) async {
      emit(GetAngelHoldingsInitial());
      try {
        final angelHoldingData =
            await FetchingApi().getAngelHoldingsApi(event.angelAuthToken);

        print(
            "Angel bloc response :::::::::::::::::::::::::::::::::$angelHoldingData");
        emit(GetAngelHoldingsLoadedState(angelHoldingData));
      } catch (e) {
        emit(GetAngelHoldingsErrorState(e.toString()));
      }
    });

    on<LoadICICISessionTokenEvent>((event, emit) async {
      emit(GetICICISessionTokenInitial());
      try {
        final getICICISessionTokenData =
            await FetchingApi().getICICISessionTokenAPI(event.sessionToken);

        print(
            "ICICI bloc response :::::::::::::::::::::::::::::::::${getICICISessionTokenData.success!.sessionToken}");
        emit(GetICICISessionTokenLoadedState(getICICISessionTokenData));
      } catch (e) {
        emit(GetICICISessionTokenErrorState(e.toString()));
      }
    });
    on<LoadICICIHoldingDataEvent>((event, emit) async {
      emit(GetICICIHoldingDataInitial());
      try {
        final getICICIHoldingData =
            await FetchingApi().getICICIHoldingApi(event.sessionToken);
        print(
            "ICICI bloc response :::::::::::::::::::::::::::::::::$getICICIHoldingData");
        emit(GetICICIHoldingDataLoadedState(getICICIHoldingData));
      } catch (e) {
        emit(GetICICIHoldingDataErrorState(e.toString()));
      }
    });
    on<AddBrokerholdingsEvent>((event, emit) async {
      print("AddHoldingsDataInitial::::::::::::::::::::::::::::::");

      // emit(AddHoldingsDataInitial());
      final brokersRepo = BrokersRepo();

      try {
        final response =
            await brokersRepo.postBrokerholdingsData(holdings: event.holdings);
      } catch (e) {
        // emit(AddHoldingsDataFailed(e.toString()));
      }
    });

    on<GetBrokerholdingsEvent>((event, emit) async {
      emit(GetHoldingsDataInitial());

      try {
        final response = await FetchingApi().getBrokerHoldingData();

        print(
            "response::::::::::::::::::::::::::::------------${response.data} ");

        emit(GetHoldingsDataLoaded(response));
      } catch (e) {
        emit(AddHoldingsDataFailed(e.toString()));
      }
    });
//
    on<LoadIIFLLoginEvent>((event, emit) async {
      emit(IIFLLoginInitial());

      try {
        final brokersRepo = BrokersRepo();

        final response = await brokersRepo.loginIIFLBroker(
            event.clientCode, event.password, event.dob);

        print("RESPONSE:::::::::::::::::::-----${response}");

        emit(IIFLLoginLoaded(response.toString()));
      } catch (e) {
        emit(IIFLLoginFailed(e.toString()));
      }
    });
    on<LoadIIFLHoldingEvent>((event, emit) async {
      emit(IIFLHoldingitial());

      final brokersRepo = BrokersRepo();

      final response =
          await brokersRepo.getIIFLHoldingData(event.clientCode, event.cookie);

      print("response::::::::::::::::::::::::::${response}");

      if (response.isNotEmpty) {
        var responseData = getIiflHoldingModelFromJson(response);
        print(
            "response::::::::::::::::::::::::::::------------${responseData}");

        emit(IIFLHoldingLoaded(responseData));
      } else {
        emit(const IIFLHoldingFailed('Error'));
      }
    });
  }
}
