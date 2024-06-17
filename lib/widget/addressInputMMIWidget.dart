import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../screens/cityNameInputScreen.dart';
import '../constant/color.dart';

// ignore: must_be_immutable
class AddressInputMMIWidget extends StatefulWidget {
  final String page;
  final String hintText;
  final Widget icon;
  final TextEditingController controller;
  var onTap;

  AddressInputMMIWidget(
      {required this.page,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.onTap});

  @override
  State<AddressInputMMIWidget> createState() => _AddressInputMMIWidgetState();
}

class _AddressInputMMIWidgetState extends State<AddressInputMMIWidget> {
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),

        // color: widgetBackGroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: TextFormField(
        readOnly: true,
        onTap: () async {
          final hasPermission = await _handleLocationPermission();
          if (hasPermission) {
            // providerData.updateResetActive(true);
            FocusScope.of(context).requestFocus(FocusNode());
             await Get.to(() => CityNameInputScreen(
                widget.page, widget.hintText)); // for MapMyIndia api
          }
        },
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18
          ),
          hintText: widget.hintText,
          icon: widget.icon,
        ),
      ),
    );
  }
}
