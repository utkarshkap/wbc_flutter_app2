part of 'fetching_data_bloc.dart';

@immutable
abstract class FetchingDataEvent {}

class LoadProductCategoryEvent extends FetchingDataEvent {
  final ProductCategory productCategory;

  LoadProductCategoryEvent({required this.productCategory});
}

class LoadExpandedCategoryEvent extends FetchingDataEvent {
  final int id;
  final ExpandedCategory expandedCategory;

  LoadExpandedCategoryEvent({required this.id, required this.expandedCategory});
}

class LoadStatesEvent extends FetchingDataEvent {
  final List<States> states;

  LoadStatesEvent({required this.states});
}

class LoadCountriesEvent extends FetchingDataEvent {
  final List<Country> countries;

  LoadCountriesEvent({required this.countries});
}

class LoadLoanBanksEvent extends FetchingDataEvent {
  final List<LoanBanks> loanBanks;

  LoadLoanBanksEvent({required this.loanBanks});
}

class LoadInsuranceCompanyEvent extends FetchingDataEvent {
  final List<InsuranceCompany> insuranceCompany;

  LoadInsuranceCompanyEvent({required this.insuranceCompany});
}

class LoadInsuranceCategoryEvent extends FetchingDataEvent {
  final List<InsuranceCategory> insuranceCategory;

  LoadInsuranceCategoryEvent({required this.insuranceCategory});
}

class LoadMGainInvestmentEvent extends FetchingDataEvent {
  final String userId;
  final MGainInvestment mGainInvestment;

  LoadMGainInvestmentEvent({required this.userId, required this.mGainInvestment});
}

class LoadMGainLedgerEvent extends FetchingDataEvent {
  final int mGainId;
  final MGainLedger mGainLedger;

  LoadMGainLedgerEvent({required this.mGainId,required this.mGainLedger});
}

class LoadStockInvestmentEvent extends FetchingDataEvent {
  final String userId;
  final StockInvestmentModel investmentPortfolio;

  LoadStockInvestmentEvent({required this.userId,required this.investmentPortfolio});
}

class LoadLoanInvestmentEvent extends FetchingDataEvent {
  final String userId;
  final LoanInvestment loanInvestment;

  LoadLoanInvestmentEvent({required this.userId,required this.loanInvestment});
}

class LoadMunafeKiClassEvent extends FetchingDataEvent {
  final MunafeKiClass munafeKiClass;

  LoadMunafeKiClassEvent({required this.munafeKiClass});
}

class LoadTermsConditionsEvent extends FetchingDataEvent {
  final TermsConditions termsConditions;

  LoadTermsConditionsEvent({required this.termsConditions});
}

class LoadFAQEvent extends FetchingDataEvent {
  final Faq faq;

  LoadFAQEvent({required this.faq});
}

class LoadGmailInboxEvent extends FetchingDataEvent {
  final GetGmailInboxModel gmailInbox;
  final String accessToken;

  LoadGmailInboxEvent({required this.gmailInbox,required this.accessToken});
}

class LoadFyersAccessTokenEvent extends FetchingDataEvent {
  final GetFyersAccessTokenModel getFyersAccessToken;

  LoadFyersAccessTokenEvent({required this.getFyersAccessToken});
}

class LoadFyersHoldingsEvent extends FetchingDataEvent {
  final GetFyersHoldingsModel getFyersHoldings;
  final String fyersAccessToken;

  LoadFyersHoldingsEvent({required this.getFyersHoldings,required this.fyersAccessToken});
}

class Load5PaisaAccessTokenEvent extends FetchingDataEvent {
  final Get5PaisaAccessTokenModel get5PaisaAccessToken;
  final String requestToken;

  Load5PaisaAccessTokenEvent({required this.get5PaisaAccessToken,required this.requestToken});
}

class Load5PaisaHoldingsEvent extends FetchingDataEvent {
  final Get5PaisaHoldingModel get5PaisaHolding;
  final String clientCode;
  final String accessToken;

  Load5PaisaHoldingsEvent({required this.get5PaisaHolding,required this.clientCode,required this.accessToken});
}
