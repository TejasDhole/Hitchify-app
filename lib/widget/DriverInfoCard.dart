
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriverInfoCard extends StatelessWidget {
  final String driverName;
  final String startPoint;
  final String endPoint;
  final List<double> startCoordinates;
  final List<double> endCoordinates;

  DriverInfoCard({
    required this.driverName,
    required this.startPoint,
    required this.endPoint,
    required this.startCoordinates,
    required this.endCoordinates,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Driver: $driverName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Start Point: $startPoint',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'End Point: $endPoint',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Start Coordinates: (${startCoordinates[0]}, ${startCoordinates[1]})',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'End Coordinates: (${endCoordinates[0]}, ${endCoordinates[1]})',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
