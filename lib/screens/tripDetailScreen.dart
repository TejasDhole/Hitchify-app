import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchify_app/constant/color.dart';

import '../constant/statusBarColor.dart';
import '../widget/dottedLine.dart';

class BookingScreen extends StatelessWidget {
  final String driverName;
  final double driverRating;
  final String vehicleNumber;
  final String vehicleModel;
  final String fromLocation;
  final String toLocation;
  final String duration;
  final String pickUpTime;
  final String dropTime;
  final String price;
  final List<String> coPassengers;
  final int availableSeats;

  const BookingScreen({
    super.key,
    required this.driverName,
    required this.driverRating,
    required this.vehicleNumber,
    required this.vehicleModel,
    this.fromLocation = 'New York, NY - 31 St & Av',
    this.toLocation = 'New York, NY - 31 St & Av',
    this.duration = '4h 30min',
    this.pickUpTime = '07:30 AM',
    this.dropTime = '06:30 PM',
    required this.price,
    required this.coPassengers,
    required this.availableSeats,
  });

  initState() {

    setStatusBarStyle(
      // Set your desired background color
      iconBrightness: Brightness.dark, // Set text/icon color
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(228, 231, 251, 1),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Status bar color
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/img/man.png'), // Replace with actual image URL
                              radius: 30,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(driverName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text('${driverRating}',
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Vehicle Number',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                                Text(vehicleNumber,
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Text(price,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(vehicleModel,
                                style: const TextStyle(fontSize: 16)),
                            Image.asset(
                              'assets/img/car-swift.png', // Replace with actual image URL
                              width: 100,
                              height: 50,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(fromLocation,
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(pickUpTime),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 30,
                              alignment: Alignment.center,
                              child: const DottedLineWidget(
                                direction: Axis.vertical,
                                lineLength: 40,
                                lineThickness: 2.0,
                                dashLength: 3.0,
                                dashColor: Color.fromARGB(255, 52, 68, 207),
                                width: 15,
                              ),
                            ),
                            Text('Duration $duration',
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(toLocation,
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(dropTime),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Co-Passengers',
                                    style: TextStyle(fontSize: 14)),
                                Row(
                                  children: coPassengers
                                      .map((url) => Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(url),
                                              radius: 15,
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Available Seats',
                                    style: TextStyle(fontSize: 14)),
                                Row(
                                  children: List.generate(
                                      4,
                                      (index) => Icon(
                                            index < availableSeats
                                                ? Icons.event_seat
                                                : Icons.event_seat_outlined,
                                            color: index < availableSeats
                                                ? Colors.blue
                                                : Colors.grey,
                                          )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Handle confirm button press
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kLiveasyColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
