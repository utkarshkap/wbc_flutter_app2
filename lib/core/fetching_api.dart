// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:wbc_connect_app/models/get_brokerList_model.dart';
import 'package:wbc_connect_app/models/get_broker_holding_model.dart';
import 'package:wbc_connect_app/models/get_icici_holdingData_model.dart';
import 'package:wbc_connect_app/models/get_icici_session_token_model.dart';
import 'package:wbc_connect_app/models/insurance_company_model.dart';
import 'package:wbc_connect_app/models/loan_banks_model.dart';
import 'package:wbc_connect_app/models/real_estate_property_model.dart';
import 'package:wbc_connect_app/models/stock_investment_model.dart';
import '../models/country_model.dart';
import '../models/custom_payumoney_hashkey_model.dart';
import '../models/expanded_category_model.dart';
import '../models/faq_model.dart';
import '../models/get_fyers_access_token_model.dart';
import '../models/get_fyers_holdings_model.dart';
import '../models/get_gmail_inbox_model.dart';
import '../models/insurance_category_model.dart';
import '../models/insurance_investment_model.dart';
import '../models/investment_portfolio_model.dart';
import '../models/investment_transaction_model.dart';
import '../models/loan_investment_model.dart';
import '../models/mGain_investment_model.dart';
import 'package:http/http.dart' as http;
import '../models/mGain_ledger_model.dart';
import '../models/munafe_ki_class_model.dart';
import '../models/newArrival_data_model.dart';
import '../models/popular_data_model.dart';
import '../models/product_category_model.dart';
import '../models/review_history_model.dart';
import '../models/state_model.dart';
import '../models/stock_investment_transaction_model.dart';
import '../models/terms_conditions_model.dart';
import '../models/trending_data_model.dart';
import 'api/api_consts.dart';

class FetchingApi {
  Future<Popular> getPopularProducts() async {
    final response = await http.get(Uri.parse(popularUrl));
    if (response.statusCode == 200) {
      log('--Popular--statusCode----${response.statusCode}');
      log('--Popular--body----${response.body}');
      return popularFromJson(response.body);
    } else {
      throw Exception("Failed to load Popular");
    }
  }

  Future<NewArrival> getNewArrivalProducts() async {
    final response = await http.get(Uri.parse(newArrivalUrl));
    if (response.statusCode == 200) {
      log('--NewArrival--statusCode----${response.statusCode}');
      log('--NewArrival--body----${response.body}');
      return newArrivalFromJson(response.body);
    } else {
      throw Exception("Failed to load NewArrival");
    }
  }

  Future<Trending> getTrendingProducts() async {
    final response = await http.get(Uri.parse(trendingUrl));
    if (response.statusCode == 200) {
      log('--Trending--statusCode----${response.statusCode}');
      log('--Trending--body----${response.body}');
      return trendingFromJson(response.body);
    } else {
      throw Exception("Failed to load Trending");
    }
  }

  Future<ProductCategory> getProductCategory() async {
    final response = await http.get(Uri.parse(productCategoryUrl));
    if (response.statusCode == 200) {
      log('--ProductCategory--statusCode----${response.statusCode}');
      log('--ProductCategory--body----${response.body}');
      return productCategoryFromJson(response.body);
    } else {
      throw Exception("Failed to load ProductCategory");
    }
  }

  Future<ExpandedCategory> getExpandedCategory(int id) async {
    final response = await http.get(Uri.parse('$expandedCategoryUrl$id'));
    if (response.statusCode == 200) {
      log('--ExpandedCategory--statusCode----${response.statusCode}');
      log('--ExpandedCategory--body----${response.body}');
      return expandedCategoryFromJson(response.body);
    } else {
      throw Exception("Failed to load ExpandedCategory");
    }
  }

  Future<List<States>> getStates() async {
    final response = await http.get(Uri.parse(statesUrl));
    if (response.statusCode == 200) {
      log('--States--statusCode----${response.statusCode}');
      log('--States--body----${response.body}');
      return statesFromJson(response.body);
    } else {
      throw Exception("Failed to load States");
    }
  }

  Future<List<Country>> getCountries() async {
    final response = await http.get(Uri.parse(countriesUrl));
    if (response.statusCode == 200) {
      log('--Country--statusCode----${response.statusCode}');
      log('--Country--body----${response.body}');
      return countryFromJson(response.body);
    } else {
      throw Exception("Failed to load Country");
    }
  }

  Future<List<LoanBanks>> getLoanBanks() async {
    final response = await http.get(Uri.parse(loanBanksUrl));
    if (response.statusCode == 200) {
      log('--LoanBanks--statusCode----${response.statusCode}');
      log('--LoanBanks--body----${response.body}');
      return loanBanksFromJson(response.body);
    } else {
      throw Exception("Failed to load banks");
    }
  }

  Future<List<InsuranceCompany>> getInsuranceCompany() async {
    final response = await http.get(Uri.parse(insuranceCompanyUrl));
    if (response.statusCode == 200) {
      log('--InsuranceCompany--statusCode----${response.statusCode}');
      log('--InsuranceCompany--body----${response.body}');
      return insuranceCompanyFromJson(response.body);
    } else {
      throw Exception("Failed to load insurance company data");
    }
  }

  Future<List<InsuranceCategory>> getInsuranceCategory() async {
    final response = await http.get(Uri.parse(insuranceCategoryUrl));
    if (response.statusCode == 200) {
      log('--InsuranceCategory--statusCode----${response.statusCode}');
      log('--InsuranceCategory--body----${response.body}');
      return insuranceCategoryFromJson(response.body);
    } else {
      throw Exception("Failed to load insurance category data");
    }
  }

  Future<RealEstatePropertyModel> getRealsEstate(String userid) async {
    log("URL-------------${realEstateUrl + userid}");
    final response = await http.get(Uri.parse("$realEstateUrl$userid"));
    if (response.statusCode == 200) {
      log('--RealnEstate--statusCode----${response.statusCode}');
      log('--RealnEstate--body----${response.body}');
      return realEstatePropertyModelFromJson(response.body);
    } else {
      throw Exception("Failed to load real estate propert data");
    }
  }

  Future<ReviewHistory> getReviewHistory(String mobNo) async {
    final response = await http.get(Uri.parse(getReviewHistoryUrl + mobNo));
    if (response.statusCode == 200) {
      log('--ReviewHistory--statusCode----${response.statusCode}');
      log('--ReviewHistory--body----${response.body}');
      return reviewHistoryFromJson(response.body);
    } else {
      throw Exception("Failed to load ReviewHistory");
    }
  }

  Future<MGainInvestment> getMGainInvestment(String userid) async {
    final response = await http.get(Uri.parse("$mGainInvestmentUrl$userid"));
    if (response.statusCode == 200) {
      print('--MGainInvestment--Uri----$mGainInvestmentUrl$userid');
      print('--MGainInvestment--statusCode----${response.statusCode}');
      print('--MGainInvestment--body----${response.body}');
      return mGainInvestmentFromJson(response.body);
    } else {
      throw Exception("Failed to load mGainInvestment data");
    }
  }

  Future<MGainLedger> getMGainLedger(
      int mGainId, int accountId, String docType) async {
    final response = await http.get(Uri.parse(
        "$mGainLedgerUrl$mGainId&accountid=$accountId&docType=$docType"));
    if (response.statusCode == 200) {
      print('--MGainLedger--statusCode----${response.statusCode}');
      print('--MGainLedger--body----${response.body}');
      return mGainLedgerFromJson(response.body);
    } else {
      throw Exception("Failed to load mGainLedger data");
    }
  }

  Future<InvestmentPortfolio> getMFInvestment(String userid) async {
    print('--getMFInvestment----URL---{$mfDashboardUrl$userid}');

    final response = await http.get(Uri.parse("$mfDashboardUrl$userid"));
    if (response.statusCode == 200) {
      print('--InvestmentPortfolio--statusCode----${response.statusCode}');
      print('--InvestmentPortfolio--body----${response.body}');
      return investmentPortfolioFromJson(response.body);
    } else {
      throw Exception("Failed to load mfInvestment data");
    }
  }

  Future<InvestmentTransaction> getMFTransaction(
      String userid,
      // String folioNo,
      String schemeName) async {
    print(
        '--getMFTransaction----URL--- $mfTransactionUrl$userid&schemename=${Uri.encodeComponent(schemeName)}');
    // &FolioNo=$folioNo
    final response = await http.get(Uri.parse(
        "$mfTransactionUrl$userid&schemename='${Uri.encodeComponent(schemeName)}'"));
    // &FolioNo='$folioNo'
    if (response.statusCode == 200) {
      print('--InvestmentTransaction--statusCode----${response.statusCode}');
      print('--InvestmentTransaction--body----${response.body}');
      return investmentTransactionFromJson(response.body);
    } else {
      throw Exception("Failed to load mfTransaction data");
    }
  }

  Future<StockInvestmentTransactionModel> getStockTransaction(
      String userid, String stockName) async {
    final response = await http
        .get(Uri.parse("$stockTransactionUrl$userid&stockname='$stockName'"));
    print(
        '--StockTransaction--URL----$stockTransactionUrl$userid&stockname=${Uri.encodeComponent(stockName)}');
    if (response.statusCode == 200) {
      print('--StockTransaction--statusCode----${response.statusCode}');
      log('--StockTransaction--body----${response.body}');
      return stockInvestmentTransactionFromJson(response.body);
    } else {
      throw Exception("Failed to load stockTransaction data");
    }
  }

  Future<CustomPayumoneyHashkeyModel> createPayumoneyHashKeyAPI(
      String amount,
      String txnid,
      String email,
      String productinfo,
      String firstname,
      String user_credentials) async {
    print('--createPayumoneyHashKey----URL---' +
        createPayUMoneyHashKeyUrl +
        "&key=" +
        merchantKey +
        "&amount=" +
        amount +
        "&txnid" +
        txnid +
        "&email=" +
        email +
        "&productinfo=" +
        productinfo +
        "&firstname=" +
        firstname +
        "&user_credentials=" +
        user_credentials);
    final response = await http.get(Uri.parse(
        "$createPayUMoneyHashKeyUrl&key=$merchantKey&amount=$amount&txnid=$txnid&email=$email&productinfo=$productinfo&firstname=$firstname&user_credentials=$user_credentials "));
    if (response.statusCode == 200) {
      print('--createPayumoneyHashKey--statusCode----${response.statusCode}');
      log('--createPayumoneyHashKey--body----${response.body}');
      return customPayumoneyHashKeyFromJson(response.body);
    } else {
      throw Exception("Failed to load mfTransaction data");
    }
  }

  Future<StockInvestmentModel> getStockInvestment(String userid) async {
    final response = await http.get(Uri.parse("$stockDashboardUrl$userid"));
    print('--StockInvestment--Url----$stockDashboardUrl$userid');
    if (response.statusCode == 200) {
      log('--StockInvestment--statusCode----${response.statusCode}');
      log('--StockInvestment--body123----${response.body}');
      return stockInvestmentFromJson(response.body);
    } else {
      throw Exception("Failed to load stockInvestment data");
    }
  }

  Future<InsuranceInvestment> getInsuranceInvestment(
      String userid, int typeId, int subTypeId) async {
    print('--InsuranceInvestment----URL---' +
        insuranceDashboardUrl +
        userid +
        "&typeId=" +
        typeId.toString() +
        "&subTypeId=" +
        subTypeId.toString());
    final response = await http.get(Uri.parse(
        "$insuranceDashboardUrl$userid&typeId=$typeId&subTypeId=$subTypeId"));
    if (response.statusCode == 200) {
      log('--InsuranceInvestment--statusCode----${response.statusCode}');
      log('--InsuranceInvestment--body----${response.body}');
      return insuranceInvestmentFromJson(response.body);
    } else {
      throw Exception("Failed to load stockInvestment data");
    }
  }

  Future<LoanInvestment> getLoanInvestment(String userid) async {
    final response = await http.get(Uri.parse("$loanDashboardUrl$userid"));
    log('--LoanInvestment--Uri----$loanDashboardUrl$userid');
    if (response.statusCode == 200) {
      log('--LoanInvestment--statusCode----${response.statusCode}');
      log('--LoanInvestment--body----${response.body}');
      return loanInvestmentFromJson(response.body);
    } else {
      throw Exception("Failed to load stockInvestment data");
    }
  }

  Future<MunafeKiClass> getMunafeKiClass() async {
    final response = await http.get(Uri.parse(munafeKiClassUrl));
    if (response.statusCode == 200) {
      print('--MunafeKiClass--statusCode----${response.statusCode}');
      print('--MunafeKiClass--body----${response.body}');
      return munafeKiClassFromJson(response.body);
    } else {
      throw Exception("Failed to load munafe ki class video");
    }
  }

  Future<TermsConditions> getTermsConditions() async {
    final response = await http.get(Uri.parse(termsConditionsUrl));
    if (response.statusCode == 200) {
      print('--TermsConditions--statusCode----${response.statusCode}');
      print('--TermsConditions--body----${response.body}');
      return termsConditionsFromJson(response.body);
    } else {
      throw Exception("Failed to load TermsConditions");
    }
  }

  Future<Faq> getFaqs() async {
    final response = await http.get(Uri.parse(faqsUrl));
    if (response.statusCode == 200) {
      print('--Faq--statusCode----${response.statusCode}');
      print('--Faq--body----${response.body}');
      return faqFromJson(response.body);
    } else {
      throw Exception("Failed to load Faq");
    }
  }

  Future<GetGmailInboxModel> getGmailInboxAPI(String accessToken) async {
    final response = await http.get(Uri.parse(getGmailInbox), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    });
    if (response.statusCode == 200) {
      print('--getGmailInboxAPI--body----${response.body}');
      return getGmailInboxFromJson(response.body);
    } else {
      throw Exception("Failed to load Gmail Inbox");
    }
  }

  Future<GetBrokerListModel> getBrokerList() async {
    final response = await http.get(Uri.parse(getBrokerListUrl));
    if (response.statusCode == 200) {
      print("Broker List statuscode----------------${response.statusCode}");
      print('get beoker list body*---------------------${response.body}');
      return getBrokerListModelFromJson(response.body);
    } else {
      throw Exception('Failed to load BrokersList');
    }
  }

  Future<GetFyersAccessTokenModel> getFyersAccessTokenAPI() async {
    final response =
        await http.get(Uri.parse(getFyersAccessTokenUrl + ApiUser.userId));
    if (response.statusCode == 200) {
      print('--FyersAccessToken--statusCode----${response.statusCode}');
      print('--FyersAccessToken--body----${response.body}');
      return getFyersAccessTokenFromJson(response.body);
    } else {
      throw Exception("Failed to load Faq");
    }
  }

  Future<GetFyersHoldingsModel> getFyersHoldingsAPI(fyersAccessToken) async {
    final response = await http.get(Uri.parse(getHoldingsUrl),
        headers: {"Authorization": "$clientId:$fyersAccessToken"});
    if (response.statusCode == 200) {
      print('--FyersHoldings--statusCode----${response.statusCode}');
      print('--FyersHoldings--body----${response.body}');
      return getFyersHoldingsModelFromJson(response.body);
    } else {
      throw Exception("Failed to load Faq");
    }
  }

  Future<GetBrokerHoldingModel> getBrokerHoldingData() async {
    final response = await http.get(
        Uri.parse('${getBrokerholdingsUrl}?userid=${ApiUser.userId}        '));
    // &brokerid=1

    print("response:::::::::::::::::::----${response.body}");

    if (response.statusCode == 200) {
      return getBrokerHoldingModelFromJson(response.body);
    } else {
      throw Exception('Failed to load GetBrokersHolding');
    }
  }

  Future getAngelHoldingsApi(angelAuthToken) async {
    final response = await http.get(Uri.parse(getAngelHoldingsUrl), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $angelAuthToken",
      "X-PrivateKey": "$angelApiKey",
    });
    if (response.statusCode == 200) {
      print('--AngelHoldings--statusCode----${response.statusCode}');
      print('--AngelHoldings--body----${response.body}');
    } else {
      throw Exception("Failed to load Faq");
    }
    print("ANGEL MAIN RESPONSE :::::::::$response");
  }

  Future<GetIciciSessionTokenModel> getICICISessionTokenAPI(
      String sessionToken) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'AlteonAPI=ARAscsdBEKwE0ZMhhZageA\$\$; nginx_srv_id=f42f4592ab0c731e8c7a9c000e57162e'
    };
    var request = http.Request('GET', Uri.parse(getICICISessionTokenUrl));
    request.body =
        json.encode({"SessionToken": sessionToken, "AppKey": iCICIApiKey});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("RESPONSE ICICIC::::::::${await response.stream.bytesToString()}");
    } else {
      print("RE::::::::::${response.reasonPhrase}");
    }

    return getIciciSessionTokenModelFromJson(
        response.stream.bytesToString().toString());
  }

  // Map<String, dynamic> body = {};

  // String calculateChecksum(String data) {
  //   try {
  //     var timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
  //     var rawChecksum = '$timeStamp\r\n$data';
  //     print("RAWCHECKSUM:-------------------------${rawChecksum}");

  //     var hmacSha256 = Hmac(sha256, utf8.encode(iCICISecretKey));
  //     Digest checksum = hmacSha256.convert(utf8.encode(rawChecksum));

  //     // print("checksum:::::::::${checksum}");

  //     return base64Encode(checksum.bytes);
  //   } catch (error) {
  //     throw Exception('Error calculating checksum: $error');
  //   }
  // }
  // String generateChecksum(String timeStamp, String secretKey) {
  //   String payload = jsonEncode({});
  //   String rawChecksum = timeStamp + payload + secretKey;
  //   List<int> bytes = utf8.encode(rawChecksum);
  //   Digest digest = sha256.convert(bytes);
  //   print("CHECKSUM :::::${digest}");
  //   return digest.toString();
  // }

  final date = '${DateTime.now().toUtc().toIso8601String().split(".")[0]}.000Z';

  String getChecksum() {
    // final bytes = utf8.encode(date + jsonEncode({}) + iCICISecretKey);
    // // final digest = sha256.convert(Uint8List.fromList(bytes));
    // final digest = sha256.convert(bytes).toString();

    // final checksum = digest.toString();
    String inputString = date + '{}' + iCICISecretKey;
    String checksum = sha256.convert(utf8.encode(inputString)).toString();

    print("checksum:::::$checksum");
    return checksum;
  }

  Future<GetIciciHoldingDataModel> getICICIHoldingApi(
      String sessionToken) async {
    // String checksum = calculateChecksum(jsonEncode(body));
    // Map<String, dynamic> payload = {};
    // String jsonString = jsonEncode(payload);

    // DateTime currentTime = DateTime.now().toUtc();
    // String timeStamp = '${currentTime.toIso8601String().substring(0, 19)}.000Z';
    // // print("timeStamp ::::${jsonString}::${timeStamp}");

    // final data = timeStamp + jsonString + iCICISecretKey;

    // final bytes = utf8.encode(data);
    // final digest = sha256.convert(bytes);
    // String checksum = sha256.convert(utf8.encode(data)).toString();
    // final dataBytes = utf8.encode(data);
    // final hash = sha256.convert(dataBytes);
    // final hexDigest = hex.encode(hash.bytes);

    // print("CHECKSUM::::::::::::::----------${hexDigest}");
    // final payload = jsonEncode({});
    String inputString = date + '{}' + iCICISecretKey;
    String checksum = sha256.convert(utf8.encode(inputString)).toString();
    var headers = {
      'Content-Type': 'application/json',
      'X-Checksum': 'token $checksum',
      'X-Timestamp': date,
      'X-AppKey': iCICIApiKey,
      'X-SessionToken': sessionToken,
      'Cookie':
          'AlteonAPI=AQPAdcdBEKw8FidzbhB5Ag\$\$; nginx_srv_id=bb517a54ab62dcf93e3ed6ba1191b7a1'
    };
    var request = http.Request('GET', Uri.parse(getICICIHoldingUrl));
    request.body = json.encode({});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print("HOLDING API statusCode::::::--:::${response.statusCode}");
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    return getIciciHoldingDataModelFromJson(
        response.stream.bytesToString().toString());

    // try {
    //   // Calculate checksum
    //   String checksum = calculateChecksum(jsonEncode(body));

    //   print("CHECKSUM::::::::::${checksum}");

    //   // Build headers with checksum and other required fields
    //   Map<String, String> headers = {
    //     'Content-Type': 'application/json',
    //     'X-Checksum': 'token $checksum',
    //     'X-Timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    //     'X-AppKey': iCICIApiKey,
    //     'X-SessionToken': sessionToken,
    //   };

    //   // Make the API call
    //   Uri url = Uri.parse(
    //       'https://api.icicidirect.com/breezeapi/api/v1/dematholdings');
    //   var response = await http.get(url, headers: headers);

    //   // Handle response
    //   if (response.statusCode == 200) {
    //     var data = jsonDecode(response.body);
    //     print(data);
    //     return getIciciHoldingDataModelFromJson(response.body);
    //   } else {
    //     print('Error: ${response.statusCode} - ${response.body}');
    //   }
    // } catch (error) {
    //   print('Error making API call: $error');
    // }
  }
}
