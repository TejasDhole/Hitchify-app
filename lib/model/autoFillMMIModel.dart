class AutoFillMMIModel {
  String placeName;
  String? addresscomponent;
  String placeCityName;
  String placeStateName;
  double? latitude;
  double? longitude;
  String? fullAddress;

  AutoFillMMIModel({
    required this.placeName,
    required this.addresscomponent,
    required this.placeCityName,
    required this.placeStateName,
    this.latitude,
    this.longitude,
    this.fullAddress
  });

  @override
  String toString() {
    return 'AutoFillMMIModel{placeName: $placeName, addresscomponent: $addresscomponent, placeCityName: $placeCityName, placeStateName: $placeStateName, latitude: $latitude, longitude: $longitude, fullAddress: $fullAddress}';
  }
}
