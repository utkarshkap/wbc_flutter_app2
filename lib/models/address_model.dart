class ShippingAddress {
  ShippingAddress({
    required this.id,
    required this.name,
    required this.num,
    required this.pinCode,
    required this.street,
    required this.subLocality,
    required this.city,
    required this.state,
    required this.country,
    required this.addressType,
    required this.isSelected,
  });

  int id;
  String name;
  String num;
  String pinCode;
  String street;
  String subLocality;
  String city;
  String state;
  String country;
  String addressType;
  int isSelected;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    id: json["id"],
    name: json["name"],
    num: json["num"],
    pinCode: json["pinCode"],
    street: json["street"],
    subLocality: json["subLocality"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    addressType: json["addressType"],
    isSelected: json["isSelected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "num": num,
    "pinCode": pinCode,
    "street": street,
    "subLocality": subLocality,
    "city": city,
    "state": state,
    "country": country,
    "addressType": addressType,
    "isSelected": isSelected,
  };

  @override
  String toString() {
    return 'ShippingAddress{id: $id, name: $name, num: $num, pinCode: $pinCode, street: $street, subLocality: $subLocality, city: $city, state: $state, country: $country, ShippingAddressType: $addressType, isSelected: $isSelected}';
  }
}