import '../core/api/api_consts.dart';
import 'package:http/http.dart' as http;

class ReviewLoanRepository {
  setReviewLoan(
      {required String userid,
      required String mobile,
      required String bankname,
      required String loantype,
      required String loanamount,
      required String emi,
      required String rateofinterest,
      required String tenure,
      required String note,
      required String uploadFilePath}) async {
    var request = http.MultipartRequest('POST', Uri.parse(reviewLoanUrl));
    request.fields.addAll({
      'userid': userid,
      'mobile': mobile,
      'bankname': bankname,
      'loantype': loantype,
      'loanamount': loanamount,
      'emi': emi,
      'rateofinterest': rateofinterest,
      'tenure': tenure,
      'note': note
    });

    request.files
        .add(await http.MultipartFile.fromPath('PdfFile', uploadFilePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return response;
    } else {
      print(response.reasonPhrase);
    }
    return response;
  }
}
