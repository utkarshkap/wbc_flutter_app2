part of 'fetching_data_bloc.dart';

abstract class FetchingDataState extends Equatable {
  const FetchingDataState();
}

class FetchingDataInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class ProductCategoryInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class ProductCategoryLoadedState extends FetchingDataState {
  final ProductCategory productCategory;

  const ProductCategoryLoadedState(this.productCategory);

  @override
  List<Object?> get props => [productCategory];
}

class ProductCategoryErrorState extends FetchingDataState {
  final String error;

  const ProductCategoryErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class ExpandedCategoryInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class ExpandedCategoryLoadedState extends FetchingDataState {
  final ExpandedCategory expandedCategory;

  const ExpandedCategoryLoadedState(this.expandedCategory);

  @override
  List<Object?> get props => [expandedCategory];
}

class ExpandedCategoryErrorState extends FetchingDataState {
  final String error;

  const ExpandedCategoryErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class StatesInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class StatesLoadedState extends FetchingDataState {
  final List<States> states;

  const StatesLoadedState(this.states);

  @override
  List<Object?> get props => [states];
}

class StatesErrorState extends FetchingDataState {
  final String error;

  const StatesErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class CountriesInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class CountriesLoadedState extends FetchingDataState {
  final List<Country> countries;

  const CountriesLoadedState(this.countries);

  @override
  List<Object?> get props => [countries];
}

class CountriesErrorState extends FetchingDataState {
  final String error;

  const CountriesErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class LoanBanksInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class LoanBanksLoadedState extends FetchingDataState {
  final List<LoanBanks> loanBanks;

  const LoanBanksLoadedState(this.loanBanks);

  @override
  List<Object?> get props => [loanBanks];
}

class LoanBanksErrorState extends FetchingDataState {
  final String error;

  const LoanBanksErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class InsuranceCompanyInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class InsuranceCompanyLoadedState extends FetchingDataState {
  final List<InsuranceCompany> insuranceCompany;

  const InsuranceCompanyLoadedState(this.insuranceCompany);

  @override
  List<Object?> get props => [insuranceCompany];
}

class InsuranceCompanyErrorState extends FetchingDataState {
  final String error;

  const InsuranceCompanyErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class InsuranceCategoryInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class InsuranceCategoryLoadedState extends FetchingDataState {
  final List<InsuranceCategory> insuranceCategory;

  const InsuranceCategoryLoadedState(this.insuranceCategory);

  @override
  List<Object?> get props => [insuranceCategory];
}

class InsuranceCategoryErrorState extends FetchingDataState {
  final String error;

  const InsuranceCategoryErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class MGainInvestmentInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class MGainInvestmentLoadedState extends FetchingDataState {
  final MGainInvestment mGainInvestment;

  const MGainInvestmentLoadedState(this.mGainInvestment);

  @override
  List<Object?> get props => [mGainInvestment];
}

class MGainInvestmentErrorState extends FetchingDataState {
  final String error;

  const MGainInvestmentErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class MGainLedgerInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class MGainLedgerLoadedState extends FetchingDataState {
  final MGainLedger mGainLedger;

  const MGainLedgerLoadedState(this.mGainLedger);

  @override
  List<Object?> get props => [mGainLedger];
}

class MGainLedgerErrorState extends FetchingDataState {
  final String error;

  const MGainLedgerErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class StockInvestmentInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class StockInvestmentLoadedState extends FetchingDataState {
  final StockInvestmentModel stockInvestmentPortfolio;
  const StockInvestmentLoadedState(this.stockInvestmentPortfolio);

  @override
  List<Object?> get props => [stockInvestmentPortfolio];
}

class StockInvestmentErrorState extends FetchingDataState {
  final String error;
  const StockInvestmentErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class LoanInvestmentInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class LoanInvestmentLoadedState extends FetchingDataState {
  final LoanInvestment loanInvestment;

  const LoanInvestmentLoadedState(this.loanInvestment);

  @override
  List<Object?> get props => [loanInvestment];
}

class LoanInvestmentErrorState extends FetchingDataState {
  final String error;

  const LoanInvestmentErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class MunafeKiClassInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class MunafeKiClassLoadedState extends FetchingDataState {
  final MunafeKiClass munafeKiClass;

  const MunafeKiClassLoadedState(this.munafeKiClass);

  @override
  List<Object?> get props => [munafeKiClass];
}

class MunafeKiClassErrorState extends FetchingDataState {
  final String error;

  const MunafeKiClassErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class TermsConditionsInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class TermsConditionsLoadedState extends FetchingDataState {
  final TermsConditions termsConditions;

  const TermsConditionsLoadedState(this.termsConditions);

  @override
  List<Object?> get props => [termsConditions];
}

class TermsConditionsErrorState extends FetchingDataState {
  final String error;

  const TermsConditionsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class FAQInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class FAQLoadedState extends FetchingDataState {
  final Faq faq;

  const FAQLoadedState(this.faq);

  @override
  List<Object?> get props => [faq];
}

class FAQErrorState extends FetchingDataState {
  final String error;

  const FAQErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class GetGmailInboxInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class GetGmailInboxLoadedState extends FetchingDataState {
  final GetGmailInboxModel gmailInbox;

  const GetGmailInboxLoadedState(this.gmailInbox);

  @override
  List<Object?> get props => [gmailInbox];
}

class GetGmailInboxErrorState extends FetchingDataState {
  final String error;

  const GetGmailInboxErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class GetFyersAccessTokenInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class GetFyersAccessTokenLoadedState extends FetchingDataState {
  final GetFyersAccessTokenModel getFyersAccessToken;

  const GetFyersAccessTokenLoadedState(this.getFyersAccessToken);

  @override
  List<Object?> get props => [getFyersAccessToken];
}

class GetFyersAccessTokenErrorState extends FetchingDataState {
  final String error;

  const GetFyersAccessTokenErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class GetFyersHoldingsInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class GetFyersHoldingsLoadedState extends FetchingDataState {
  final GetFyersHoldingsModel getFyersHoldings;

  const GetFyersHoldingsLoadedState(this.getFyersHoldings);

  @override
  List<Object?> get props => [getFyersHoldings];
}

class GetFyersHoldingsErrorState extends FetchingDataState {
  final String error;

  const GetFyersHoldingsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class Get5PaisaAccessTokenInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class Get5PaisaAccessTokenLoadedState extends FetchingDataState {
  final String accessToken;
  final String clientId;

  Get5PaisaAccessTokenLoadedState({
    required this.accessToken,
    required this.clientId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class Get5PaisaAccessTokenErrorState extends FetchingDataState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class Get5PaisaHoldingsInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class Get5PaisaHoldingsLoadedState extends FetchingDataState {
  final Get5PaisaHoldingModel get5PaisaHolding;
  const Get5PaisaHoldingsLoadedState(this.get5PaisaHolding);
  @override
  List<Object?> get props => [get5PaisaHolding];
}

class Get5PaisaHoldingsErrorState extends FetchingDataState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetAngelHoldingsInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class GetAngelHoldingsLoadedState extends FetchingDataState {
  final getAngelHoldings;

  const GetAngelHoldingsLoadedState(this.getAngelHoldings);

  @override
  List<Object?> get props => [getAngelHoldings];
}

class GetAngelHoldingsErrorState extends FetchingDataState {
  final String error;

  const GetAngelHoldingsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class GetICICISessionTokenInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class GetICICISessionTokenLoadedState extends FetchingDataState {
  final GetIciciSessionTokenModel getIciciSessionToken;

  const GetICICISessionTokenLoadedState(this.getIciciSessionToken);

  @override
  List<Object?> get props => [getIciciSessionToken];
}

class GetICICISessionTokenErrorState extends FetchingDataState {
  final String error;

  const GetICICISessionTokenErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class GetICICIHoldingDataInitial extends FetchingDataState {
  @override
  List<Object> get props => [];
}

class GetICICIHoldingDataLoadedState extends FetchingDataState {
  final GetIciciHoldingDataModel getICICIHoldingData;

  const GetICICIHoldingDataLoadedState(this.getICICIHoldingData);

  @override
  List<Object?> get props => [getICICIHoldingData];
}

class GetICICIHoldingDataErrorState extends FetchingDataState {
  final String error;

  const GetICICIHoldingDataErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
