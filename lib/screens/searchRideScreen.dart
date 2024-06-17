import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hitchify_app/constant/color.dart';
import 'package:hitchify_app/screens/tripDetailScreen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widget/cards/TripCard.dart';
import '../widget/addressInputMMIWidget.dart';
import '../widget/dottedLine.dart';
import '../widget/loadingPointImageIcon.dart';
import '../constant/providerData.dart';
import '../model/autoFillMMIModel.dart';

class SearchScreen extends StatefulWidget {
  final AutoFillMMIModel? loadPointModel;
  final AutoFillMMIModel? unloadPointModel;

  SearchScreen({this.loadPointModel, this.unloadPointModel});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  void dispose() {
    rides.clear();
    super.dispose();
  }

  List<dynamic> rides = [];
  @override
  void initState() {
    super.initState();

    // _fetchDriverInfo();
    //  fetchRides(73.6934,17.6791,73.8567,18.5204) ;
    fetchRides(
        widget.loadPointModel!.longitude!,
        widget.loadPointModel!.latitude!,
        widget.unloadPointModel!.longitude!,
        widget.unloadPointModel!.longitude!);
  }

  // Future<void> _fetchDriverInfo() async {
  //   final response = await http.get(Uri.parse('http://10.0.2.2:8080/Rides'));
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       rides = json.decode(response.body);
  //     });
  //   } else {
  //     throw Exception('Failed to load rides');
  //   }
  // }

  Future<void> fetchRides(double startLongitude, double startLatitude,
      double endLongitude, double endLatitude) async {
    final response = await http.get(
      // Uri.parse("http://10.0.2.2:8080/Rides1?startGeoPoint=$startLongitude,$startLatitude&endGeoPoint=$endLongitude,$endLatitude"),
      Uri.parse(
          'http://localhost:8080/Rides1?startGeoPoint=73.8567437,18.5204303&endGeoPoint=74.018261,17.6804639'),
    );

    if (response.statusCode == 200) {
      setState(() {
        rides = json.decode(response.body);
      });
      // print(rides);
    } else {
      throw Exception('Failed to load rides');
    }
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    if (providerData.loadingPointCityPostLoad != "") {
      controller1 = TextEditingController(
          text:
              ("${providerData.loadingPointPostLoad},${providerData.loadingPointCityPostLoad},${providerData.loadingPointStatePostLoad}"));
    } else {
      controller1 = TextEditingController(text: "");
    }
    if (providerData.unloadingPointCityPostLoad != "") {
      controller2 = TextEditingController(
          text:
              (" ${providerData.unloadingPointPostLoad},${providerData.unloadingPointCityPostLoad},${providerData.unloadingPointStatePostLoad}"));
    } else {
      controller2 = TextEditingController(text: "");
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(228, 231, 251, 1),
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
        child: Column(
          children: <Widget>[
            Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              // padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
             margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 20, 0),
                    child: AddressInputMMIWidget(
                      page:
                      "postLoad", //use AddressInputMMIWidget for using mapMyIndia api
                      hintText: "From",
                      icon: const Icon(
                        size: 20,
                        Icons.circle,
                        color: Color.fromRGBO(44, 63, 194, 1),
                      ),
                      controller: controller1,
                      onTap: () {
                        providerData.clearLoadingPointPostLoad();
                      },
                    ),
                  ),
                  const Row(
                    children: [
                      SizedBox(
                        width: 45,
                        child: DottedLineWidget(
                        direction: Axis.vertical,
                        lineLength: 40,
                        lineThickness: 2.0,
                        dashLength: 3.0,
                        dashColor: Color.fromARGB(255, 52, 68, 207),
                        width: 50,
                      )),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 2,
                          indent: 14,
                          endIndent: 20,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 20, 4),
                    child: AddressInputMMIWidget(
                      page: "postLoad",
                      hintText: "To",
                      icon: const Icon(
                        size: 20,
                        Icons.circle,
                        color: Color.fromRGBO(201, 196, 243, 1),
                      ),
                      controller: controller2,
                      onTap: () {
                        providerData.updateUnloadingPointPostLoad(
                            place: "", city: "", state: "");
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: ElevatedButton(
                onPressed: () async {
                  // Call your function here
                  await fetchRides(74.0060, 40.7128, 73.935242,
                      40.730610); // Example coordinates
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  backgroundColor: const Color.fromRGBO(52, 68, 207, 1), // Background color
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search for Ride',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    SizedBox(width: 8.0),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  final ride = rides[index];
                  return GestureDetector(
                    onTap: () => Get.to(
                      const BookingScreen(
                        driverName: 'Cody Armer',
                        driverRating: 4.5,
                        vehicleNumber: 'KL21SB086',
                        vehicleModel: 'White Maruti Swift',
                        pickUpTime: '07:30 AM',
                        dropTime: '06:30 PM',
                        price: '₹120',
                        coPassengers: [
                          'https://example.com/user1.png',
                          'https://example.com/user2.png',
                          'https://example.com/user3.png',
                        ],
                        availableSeats: 2,
                      ),
                    ),
                    child: TripCard(
                      driverName: ride['drivername'] ?? 'Unknown',
                      fromLocation: ride['startPoint'] ?? '',
                      toLocation: ride['endPoint'] ?? '',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
