import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../model/autoFillMMIModel.dart';

String kGoogleApiKey = "AIzaSyB7SgtlI6rusxig8RGFw2abZQxdIsw3t9w";

Future<List<AutoFillMMIModel>> fillCityGoogle(
    String cityName, Position position) async {
  final autocompleteUrl = Uri.parse(
    'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'input=$cityName&location=${position.latitude},${position.longitude}&radius=50000&language=en&components=country:in&key=$kGoogleApiKey',
  );

  var response = await http.get(autocompleteUrl);

  List<AutoFillMMIModel> card = [];

  if (response.statusCode == 200) {
    var address = json.decode(response.body);
    var predictions = address["predictions"];
    for (var prediction in predictions) {
      debugPrint(prediction["description"]);
      List<String> result = prediction["description"].split(",");
      String fullAddress = prediction["description"];

      String placeId = prediction["place_id"];

      // Fetch place details to get coordinates
      final detailsUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?'
            'place_id=$placeId&key=$kGoogleApiKey',
      );

      var detailsResponse = await http.get(detailsUrl);

      if (detailsResponse.statusCode == 200) {

        var details = json.decode(detailsResponse.body);
        var location = details["result"]["geometry"]["location"];
        double lat = location["lat"];
        double lng = location["lng"];

        int resultLength = result.length;
        String placeName = result[0].trim();
        String placeCityName = resultLength >= 3 ? result[resultLength - 3].trim() : placeName;
        String placeStateName = resultLength >= 2 ? result[resultLength - 2].trim() : placeName;
        String addrescomponent = "${result[1].toString()}";
        AutoFillMMIModel locationCardsModal = AutoFillMMIModel(
          placeName: placeName,
          addresscomponent: addrescomponent,
          placeCityName: placeCityName,
          placeStateName: placeStateName,
          latitude: lat,
          longitude: lng,
          fullAddress: fullAddress,
        );
        card.add(locationCardsModal);
      }
    }
    return card;
  } else {
    return [];
  }
}
