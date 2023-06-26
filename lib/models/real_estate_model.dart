import 'dart:convert';

RealEstate realEstateFromJson(String str) =>
    RealEstate.fromJson(json.decode(str));

String realEstateToJson(RealEstate data) => json.encode(data.toJson());

class RealEstate {
  RealEstate({
    required this.propertyType,
    required this.carpetArea,
    required this.BuiltupArea,
    required this.Location,
    required this.ProjectName,
    required this.carParking,
    required this.enterFacing,
    required this.Year,
    required this.Price,
    required this.userId,
    required this.Imgs,
  });

  String propertyType;
  int carpetArea;
  int BuiltupArea;
  String Location;
  String ProjectName;
  String carParking;
  String enterFacing;
  int Year;
  num Price;
  int userId;
  List<String> Imgs;

  factory RealEstate.fromJson(Map<String, dynamic> json) => RealEstate(
    propertyType: json["propertyType"],
    carpetArea: json["carpetArea"],
    BuiltupArea: json["BuiltupArea"],
    Location: json["Location"],
    ProjectName: json['ProjectName'],
    carParking: json["carParking"],
    enterFacing: json["enterFacing"],
    Year: json["Year"],
    Price: json["Price"],
    userId: json["userId"],
    Imgs: json["Imgs"],
  );

  Map<String, dynamic> toJson() => {
    "propertyType": propertyType,
    "carpetArea": carpetArea,
    "BuiltupArea": BuiltupArea,
    "Location": Location,
    "ProjectName": ProjectName,
    "carParking": carParking,
    "enterFacing": enterFacing,
    "Year": Year,
    "Price": Price,
    "userId": userId,
    "Imgs": Imgs,
  };

  @override
  String toString() {
    return 'RealEstate{propertyType: $propertyType, carpetArea: $carpetArea, BuiltupArea: $BuiltupArea, Location: $Location, ProjectName: $ProjectName, carParking: $carParking, enterFacing: $enterFacing, Year: $Year, Price: $Price, userId: $userId, Imgs: $Imgs}';
  }
}
