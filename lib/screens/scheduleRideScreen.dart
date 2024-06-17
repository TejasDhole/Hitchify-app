import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hitchify_app/constant/color.dart';
import 'package:provider/provider.dart';

import '../constant/providerData.dart';

class ScheduleRideScreen extends StatefulWidget {
  @override
  _ScheduleRideScreenState createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(backgroundColor: white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scheduled Ride',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildRideLocation('${providerData.loadingPointCityPostLoad}',
                "${providerData.loadingPointPostLoad},${providerData.loadingPointCityPostLoad},${providerData.loadingPointStatePostLoad}"),
            _buildVerticalDottedLine(),
            _buildRideLocation('${providerData.unloadingPointCityPostLoad}',
                "${providerData.destinationPointAddress}"),
            const SizedBox(height: 30),
            _buildSelectDate(context),
            const SizedBox(height: 30),

            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRideLocation(String title, String address) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 3),
        ),
        const Icon(Icons.location_pin, color: Color.fromARGB(255, 52, 68, 207)),
        const SizedBox(width: 10),
        Expanded(
          // Wrap the Column with Expanded to allow the address text to take available space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                address,
                style: const TextStyle(fontSize: 16),
                softWrap: true,
              ),
            ],
          ),
        ),
        // Spacer(),
        // const Icon(Icons.edit, color: Colors.grey),
      ],
    );
  }

  Widget _buildVerticalDottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        children: [
          Container(
            width: 30,
            alignment: Alignment.center,
            child: const DottedLine(
              direction: Axis.vertical,
              lineLength: 40,
              lineThickness: 2.0,
              dashLength: 3.0,
              dashColor: Color.fromARGB(255, 52, 68, 207),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectDate(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Divider(
          color: Colors.grey, // Change to your desired color
          thickness: 1, // Change to your desired thickness
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('Select Date',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          color: Colors.grey, // Change to your desired color
          thickness: 1, // Change to your desired thickness
          indent: 20,
          endIndent: 20,
        ),
        DatePicker(
          height: 90,
          DateTime.now(),
          initialSelectedDate: DateTime.now(),
          selectionColor: const Color.fromARGB(255, 52, 68, 207),
          selectedTextColor: Colors.white,
          onDateChange: (date) {
            // New date selected
            setState(() {
              selectedDate = date;
            });
          },
        ),
      ],
    );
  }


  Widget _buildConfirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Get.back();
          // Save the selected date and time
          print('Selected date: ${selectedDate.toLocal()}');
          print('Selected time: ${selectedTime.format(context)}');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color.fromARGB(255, 52, 68, 207),
        ),
        child: const Text(
          'Confirm',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
