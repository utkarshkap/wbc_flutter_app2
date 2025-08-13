import 'package:wbc_connect_app/models/getuser_model.dart';
import '../../models/dashboard.dart';

const setUser = 'setUser';
const addContact = 'addContacts';
const getUserKey = 'getUser?MobileNo=';
const getPendingDeleteUserKey = 'pendingdeleteuser?mobileNo=';
const setFcmIdAndDeviceId = 'setFcmIdAndDeviceId';
const getDashboardKey = 'getGPDashboard?userid=';
const getContactKey = 'getContact?id=';
const setOrderKey = 'wbcOrder';
const getAllOrderKey = 'getallorder?userid=';
const deleteAccountKey = 'deleteaccount?mobileno=';

const setInsuranceReviewKey =
    'https://wbcapi.kagroup.in/api/User/addreviewInsurance';

const reviewLoanUrl = 'https://wbcapi.kagroup.in/api/User/addreviewLoanEMI';
const setFamilyMember = 'addfamilymember';

const insuranceKey = 'insurancecalculator';
const sipCalculator = 'sipcalculator';
const emiSipCalculator = 'emisipcalculator';
const retirementCalculator = 'retirementcalculator';

const getAllReviewKey =
    'https://wbcapi.kagroup.in/api/User/getAllReviewRequestList?mobileNo=';
const uploadMfReviewBaseUrl =
    'https://wbcapi.kagroup.in/api/User/uploadMFHoliding';

const uploadStockReviewBaseUrl =
    'https://wbcapi.kagroup.in/api/User/uploadStockFolio';

const addRealEstateBaseUrl =
    'https://wbcapi.kagroup.in/api/User/addRealEastatereview';

const String baseUrl = "https://wbcapi.kagroup.in/api/User/";
const String imgBaseUrl = 'https://wbcapi.kagroup.in/';
const String imgNewBaseUrl = 'https://wbcapi.kagroup.in';

const String popularUrl = "${baseUrl}popular";
const String newArrivalUrl = "${baseUrl}newarrival";
const String trendingUrl = "${baseUrl}trending";

const String productCategoryUrl = "${baseUrl}getProductCategory";
const String expandedCategoryUrl = "${baseUrl}getProductList?cat_id=";

const String countriesUrl = "${baseUrl}getCountrylist";
const String statesUrl = "${baseUrl}getStatelist";

const String loanBanksUrl = "${baseUrl}getBankListForLoan";
const String insuranceCompanyUrl = "${baseUrl}getInsuranceCompanyList";
const String insuranceCategoryUrl =
    "${baseUrl}getInsurancecategory_list?insurancetype=";
const String realEstateUrl = "${baseUrl}getRealtyData?userid=";

const String mGainInvestmentUrl = "${baseUrl}getMGainInvestment?userId=";
const String mGainLedgerUrl = "${baseUrl}getMGainLedger?mGainId=";

const String setMFReviewKey = "addreviewPortfolioMF";
const String setStockReviewKey = "${baseUrl}addreviewPortfolioMF";

const String getReviewHistoryUrl =
    "${baseUrl}getAllReviewRequestList?mobileNo=";

const String mfDashboardUrl = "${baseUrl}getMFDashboard?userid=";
const String mfTransactionUrl = "${baseUrl}getMFTransaction?userid=";
const String stockDashboardUrl = "${baseUrl}getStockDashboardNew?userid=";
const String stockTransactionUrl = "${baseUrl}getStockTransaction?userid=";
const String insuranceDashboardUrl = "${baseUrl}getinsurancedashboard?userid=";
const String loanDashboardUrl = "${baseUrl}getloandashboard?userid=";

const String munafeKiClassUrl = "${baseUrl}getMunafeKiClass";
const String termsConditionsUrl = "${baseUrl}getTermsConditions";

const String faqsUrl = "${baseUrl}getQuestions";

const updateTncKey = 'updatetermsandcondition?mobileno=';

const deleteMemberKey = 'removefamilymember?MobileNo=';

const updateFastTrackUser = 'updateFasttrackUser';

const wealthMeterScoreUrl = "wealthmeterscore";

//Gmail APIS
const getGmailInbox = 'https://gmail.googleapis.com/gmail/v1/users/me/messages';

//PayuMoney Credential
const merchantKey = 'WUJqyB';
const merchantSalt = 'zZXljP5qk0xvLeYg40HWCJIbjv55pVkF';
const fastTrackAmount = '3600';
const fastTrackGST = '648';
const createPayUMoneyHashKeyUrl =
    'http://api2.kafinsec.in/api/WebApi/CustomPayUMoneyHashKey?';

//RazorpayPayment Credential
const razorpayKey = 'rzp_live_kYXFJgsJOfnffn';
// rzp_test_4vj76FZqWURAwF - test key

const getBrokerListUrl = "${baseUrl}GetBrokerList";
const addbrokerholdings = "addbrokerholdings";
const getBrokerholdingsUrl = "${baseUrl}GetBrokerHolding";

//Fyers Credential
const clientId = 'FP38PDERY5-100';
const clientSecret = 'UJI8FJ7B8N';
const fyersRedirectUrl = "https://wbcapi.kagroup.in/api/User/fyersresponse";

const generateAuthCodeUrl = "https://api.fyers.in/api/v2/generate-authcode?";
const getFyersAccessTokenUrl =
    "https://wbcapi.kagroup.in/api/user/fyersaccesstoken?userid=";
const getHoldingsUrl = "https://api.fyers.in/api/v2/holdings";

//5Paisa Credential
const userKey = 'prHVVKtF4UnIedJJfN8Xo70KfwQHO83l';
const userId = '2KCxRS0whf4';
const encryKey = 'tTDlvbSGnKSX2dea5OV75fFxKxDTGYAa';
const paisaRedirectUrl = "https://wbcapi.kagroup.in/api/User/5paisaresponse";
const generateRequestTokenUrl =
    "https://dev-openapi.5paisa.com/WebVendorLogin/VLogin/Index?";
//
const get5PaisaAccessTokenUrl =
    "https://Openapi.5paisa.com/VendorsAPI/Service1.svc/GetAccessToken";
const get5PaisaHoldingUrl =
    "https://Openapi.5paisa.com/VendorsAPI/Service1.svc/V3/Holding";

//IIFL Credential
const iiflEncKey =
    "lpesfrRtUEc7TIaDoV0A8472IuS3DSLClczffSh0Ffpv0r3xbROrjVLsuRwtbQOa";
const iiflLoginUrl = 'https://dataservice.iifl.in/openapi/prod/LoginRequest';
const iiflHoldingUrl = 'https://dataservice.iifl.in/openapi/prod/Holding';
const iiflSubscriptionKey = 'fc714d8e5b82438a93a95baa493ff45b';
const iiflAppName = 'IIFLMarUTKARSH';
const iiflkey = 'sUsDmof74N4D6aGiKXgIJ7AZcq5rps4c';
const iifluserId = 'p0UVqrzkt3s';
const iiflpassword = 'VMkhSrOsASt';

// Angel
const angelApiKey = 'DzKZ7p2x';
const getAngelHoldingsUrl =
    'https://apiconnect.angelbroking.com/rest/secure/angelbroking/portfolio/v1/getAllHolding';
// const angelRedirectUrl =
//     "https://wbcapi.kagroup.in/api/User/angleTokenResponse";
// https://wbcapi.kagroup.in/api/User/angleToken

// ICICI

const iCICIApiKey = '32o929~59w732884j4012f3451M\$x68d';
const iCICISecretKey = '27K09&hD88158+63106b3%00u15Y82U2';
const getICICISessionTokenUrl =
    'https://api.icicidirect.com/breezeapi/api/v1/customerdetails';
const getICICIHoldingUrl =
    'https://api.icicidirect.com/breezeapi/api/v1/dematholdings';

class ApiUser {
  static String userId = "";
  static String userName = "";
  static String userDob = "";
  static String emailId = "";
  static String mobileNo = "";
  static List<GoldReferral>? myContactsList = [];
  static List<Offer> offersList = [];
  static List<Memberlist> membersList = [];
  static bool termNdCondition = false;
  static List numberList = [];
  static double wealthMeterScore = 0;
  static String uploadMFHolidingApiMessage = '';
  static String wbcMall = '';
  static String wbcGp = '';
  static String appUpdateShow = '';
}

class GpDashBoardData {
  static List<History>? history;
  static List<ContactBase>? contactBase;
  static List<InActive>? inActiveClients;
  static int? availableContacts;
  static int? goldPoint;
  static double? fastTrackEarning;
  static List<Earning>? earning;
  static int? redeemable;
  static int? nonRedeemable;
  static int? onTheSpot;
  static int? maxContactPermittedPerMonth;
}
