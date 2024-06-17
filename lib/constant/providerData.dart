import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../cache/locationCache.dart';
import '../model/autoFillMMIModel.dart';
import 'color.dart';

//In provider data class variables that will be required across different screens are declared . These variables are updated by defining respective function for them.
//Right now variable declaration and function definition are writing without any specific order but later on change this , there are two options
// 1 Either declare the variables and its functions one below another so that developers immediately know which function updates what variable
// 2 First declare all variables and then declare all functions
//This is effective way for maintenance of code for long term.
//P.S Care should be taken that provider should only be used for updating variables and not processing their values.

// enum class for language selection
enum LanguageItem { English, Hindi }

class ProviderData extends ChangeNotifier {


  AutoFillMMIModel? ArrivalPointLocationModel;
  AutoFillMMIModel? DestinationPointLocationModel;
 String? startingPointAddress;
 String? destinationPointAddress;

  String loadingPointCityFindLoad = "";
  String loadingPointStateFindLoad = "";

  String unloadingPointCityFindLoad = "";
  String unloadingPointStateFindLoad = "";

  String loadingPointCityPostLoad = "";
  String loadingPointStatePostLoad = "";
  String loadingPointPostLoad = "";
  String loadingPointCityPostLoad2 = "";
  String loadingPointStatePostLoad2 = "";
  String loadingPointPostLoad2 = "";

  String unloadingPointCityPostLoad = "";
  String unloadingPointStatePostLoad = "";
  String unloadingPointPostLoad = "";
  String unloadingPointCityPostLoad2 = "";
  String unloadingPointStatePostLoad2 = "";
  String unloadingPointPostLoad2 = "";


  String controller = "";
  String controller1 = "";
  String controller2 = "";

  //------------------------FUNCTIONS--------------------------------------------------------------------------
  void updateArrivalPointLocationModel(AutoFillMMIModel model) {
    ArrivalPointLocationModel = model;
    notifyListeners();
  }

  void updateDestinationPointLocationModel(AutoFillMMIModel model) {
    DestinationPointLocationModel = model;
    notifyListeners();
  }
  void clearLoadingPointFindLoad() {
    loadingPointPostLoad = "";
    loadingPointCityFindLoad = "";
    loadingPointStateFindLoad = "";
    notifyListeners();
  }

  void clearUnloadingPointFindLoad() {
    unloadingPointPostLoad = "";
    unloadingPointCityFindLoad = "";
    unloadingPointStateFindLoad = "";
    notifyListeners();
  }

  void updateLoadingPointFindLoad(
      {required String place, required String city, required String state}) {
    loadingPointPostLoad = place;
    loadingPointCityFindLoad = city;
    loadingPointStateFindLoad = state;
    notifyListeners();
  }

  void updateUnloadingPointFindLoad(
      {required String place, required String city, required String state}) {
    unloadingPointPostLoad = place;
    unloadingPointCityFindLoad = city;
    unloadingPointStateFindLoad = state;
    notifyListeners();
  }

  updateControllerOne(value) {
    controller1 = value;
    notifyListeners();
  }

  updateControllerTwo(value) {
    controller2 = value;
    notifyListeners();
  }

  //////////////
  void clearLoadingPointPostLoad() {
    loadingPointPostLoad = "";
    loadingPointCityPostLoad = "";
    loadingPointStatePostLoad = "";
    notifyListeners();
  }

  void clearLoadingPointPostLoad2() {
    loadingPointPostLoad2 = "";
    loadingPointCityPostLoad2 = "";
    loadingPointStatePostLoad2 = "";
    notifyListeners();
  }

  void clearUnloadingPointPostLoad() {
    unloadingPointPostLoad = "";
    unloadingPointCityPostLoad = "";
    unloadingPointStatePostLoad = "";
    notifyListeners();
  }

  void clearUnloadingPointPostLoad2() {
    unloadingPointPostLoad2 = "";
    unloadingPointCityPostLoad2 = "";
    unloadingPointStatePostLoad2 = "";
  }

  void updateLoadingPointPostLoad(
      {required String place, required String city, required String state}) {
    loadingPointPostLoad = place;
    loadingPointCityPostLoad = city;
    loadingPointStatePostLoad = state;


    notifyListeners();
  }


  void updateLoadingPointPostLoad2(
      {required String place, required String city, required String state}) {
    loadingPointPostLoad2 = place;
    loadingPointCityPostLoad2 = city;
    loadingPointStatePostLoad2 = state;
    notifyListeners();
  }

  void updateUnloadingPointPostLoad(
      {required String place, required String city, required String state}) {
    unloadingPointPostLoad = place;
    unloadingPointCityPostLoad = city;
    unloadingPointStatePostLoad = state;

    notifyListeners();
  }

  void updateUnloadingPointPostLoad2(
      {required String place, required String city, required String state}) {
    unloadingPointPostLoad2 = place;
    unloadingPointCityPostLoad2 = city;
    unloadingPointStatePostLoad2 = state;

  }

//-------------------------------------
  Future<void> getCurrentPosition() async {
    if (LocationCache().currentPosition != null) {
      // If cached position exists, use it
      notifyListeners();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LocationCache().currentPosition = position; // Store the current position in the cache
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
