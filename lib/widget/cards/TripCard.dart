import 'package:flutter/material.dart';

import '../dottedLine.dart';

class TripCard extends StatelessWidget {
  final String driverName;
  final double rating;
  final double price;
  final String fromLocation;
  final String toLocation;
  final String duration;
  final String pickUpTime;
  final String dropTime;
  final List<String> coPassengersImages;
  final int availableSeats;

  const TripCard({
    Key? key,
    this.driverName = 'Cody Armer',
    this.rating = 4.5,
    this.price = 120,
    this.fromLocation = 'New York, NY - 31 St & Av',
    this.toLocation = 'New York, NY - 31 St & Av',
    this.duration = '4h 30min',
    this.pickUpTime = '07:30 AM',
    this.dropTime = '06:30 PM',
    this.coPassengersImages = const [],
    this.availableSeats = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,

// backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/img/man.png'), // Add your image asset here
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driverName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(rating.toString()),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text('₹${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(fromLocation, style: const TextStyle(fontSize: 18)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue),
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
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(toLocation, style: const TextStyle(fontSize: 18)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(dropTime),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // const SizedBox(height: 16),
            const Row(
              children: [
                Text('CO-PASSENGERS',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                Text('AVAILABLE SEATS',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ...coPassengersImages.map((image) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(image),
                        radius: 15,
                      ),
                    )),
                const Spacer(),
                Row(
                  children: List.generate(4, (index) {
                    return Icon(
                      Icons.event_seat,
                      color: index < availableSeats ? Colors.blue : Colors.grey,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
