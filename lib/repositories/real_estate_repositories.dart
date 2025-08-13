import 'dart:io';

import '../core/api/api_consts.dart';
import 'package:http/http.dart' as http;

class RealEstateRepository {
  uploadRealEstateData(
      {required String propertyType,
      required String carpetArea,
      required String BuiltUpArea,
      required String Location,
      required String ProjectName,
      required String carParking,
      required String enterFacing,
      required String Year,
      required String Price,
      required String userId,
      required List<String> imgPath}) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(addRealEstateBaseUrl));

    request.fields.addAll({
      'propertyType': propertyType,
      'carpetArea': carpetArea,
      'BuiltupArea': BuiltUpArea,
      'Location': Location,
      'ProjectName': ProjectName,
      'carParking': carParking,
      'enterFacing': enterFacing,
      'Year': Year,
      'Price': Price,
      'userId': userId,
    });
    List<http.MultipartFile> newList = [];

    for (int i = 0; i < imgPath.length; i++) {
      File imageFile = File(imgPath[i]);

      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile("Imgs", stream, length,
          filename: imageFile.path.split('/').last);

      newList.add(multipartFile);
    }

    request.files.addAll(newList);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('upload images successfully.');
      return response;
    } else {
      print(response.reasonPhrase);
    }

    return response;
  }
}
