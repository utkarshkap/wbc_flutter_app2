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
    request.fields['propertyType'] = propertyType;
    request.fields['carpetArea'] = carpetArea;
    request.fields['BuiltupArea'] = BuiltUpArea;
    request.fields['Location'] = Location;
    request.fields['ProjectName'] = ProjectName;
    request.fields['carParking'] = carParking;
    request.fields['enterFacing'] = enterFacing;
    request.fields['Year'] = Year;
    request.fields['Price'] = Price;
    request.fields['userId'] = userId;
    List<http.MultipartFile> newList=[];

    for (int i = 0; i < imgPath.length; i++) {
      File imageFile = File(imgPath[i]);

      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile("Imgs", stream, length,
          filename: imageFile.path.split('/').last);

      newList.add(multipartFile);

    }

    request.files.addAll(newList);
    final response = await request.send().then((response) {
      if (response.statusCode == 200) {
        print('upload images successfully.');

        return response;
      }
    });
    return response;
  }
}
