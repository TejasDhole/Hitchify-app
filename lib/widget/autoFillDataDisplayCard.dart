import 'package:flutter/material.dart';

import '../constant/color.dart';

// ignore: must_be_immutable
class AutoFillDataDisplayCard extends StatelessWidget {
  String placeName;
  String placeCity;
  String? addresscomponent;
  String placeAddress;
  var onTap;

  AutoFillDataDisplayCard(
      this.placeName,
    this.addresscomponent,
    this.placeCity,
    this.placeAddress,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 0.5,
              color: greyBorderColor,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                Icons.location_on_outlined,
                color: darkBlueColor,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // height: 170,
                    child: Text(
                      '''$placeName''',
                        maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 14, color: liveasyBlackColor),
                    ),
                  ),
                  Container(
                    child: Text(
                      addresscomponent==null?
                      placeAddress==placeCity?'$placeCity':'$placeCity' + '$placeAddress':
                      '$addresscomponent'+','+ '$placeCity'+','+ '$placeAddress',
                      style: TextStyle(fontSize: 12, color: darkGreyColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
