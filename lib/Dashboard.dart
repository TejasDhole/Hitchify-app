import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hitchify_app/screens/scheduleRideScreen.dart';
import 'package:hitchify_app/screens/searchRideScreen.dart';
import 'package:hitchify_app/widget/addressInputMMIWidget.dart';
import 'package:hitchify_app/widget/dottedLine.dart';
import 'package:hitchify_app/widget/loadingPointImageIcon.dart';
import 'package:provider/provider.dart';
import 'UserPreferences.dart';
import 'constant/providerData.dart';
import 'login.dart';
import 'model/autoFillMMIModel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();

AutoFillMMIModel? ArrivalPointLoactionModel;
AutoFillMMIModel? DestinationPointLocationModel;
DateTime? selectedDate;
String? dropdownValue = 'Now';
bool isLoggedIn = false;

class _DashboardScreenState extends State<DashboardScreen> {


  @override
  void initState() {
    super.initState();
    checkUserLoggedInStatus();
  }

  Future<void> checkUserLoggedInStatus() async {
    bool loggedIn = await UserPreferences().getUserLoggedIn();
    setState(() {
      isLoggedIn = loggedIn;
    });
  }



  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    if (providerData.ArrivalPointLocationModel != null) {
      ArrivalPointLoactionModel = providerData.ArrivalPointLocationModel;
    }

    if (providerData.DestinationPointLocationModel != null) {
      DestinationPointLocationModel =
          providerData.DestinationPointLocationModel;
    }

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
        appBar: AppBar(

          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Status bar color
            statusBarIconBrightness:
                Brightness.light, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            if (isLoggedIn)
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await UserPreferences().clearUserLoggedIn();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Color.fromRGBO(34, 48, 147, 1), // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: Text('LOG IN'),
                ),
              ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(44, 63, 194, 1),
        body: SafeArea(
            child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              const Text('Welcome to Hitchify',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              const SizedBox(height: 50),
              const Image(image: AssetImage('assets/img/welcome_page_img.png')),
              const SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      _showPassengerDrawer(context, providerData,isLoggedIn);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(239, 51),
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      backgroundColor: const Color.fromRGBO(34, 48, 147, 1),
                    ),
                    child: const Text(
                      'Passenger ',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add your code for passenger button here
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(239, 51),
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      backgroundColor: const Color.fromRGBO(34, 48, 147, 1),
                    ),
                    child: const Text(
                      'Driver',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }

  TextEditingController searchController = TextEditingController();
  List<Prediction>? suggestions = [];
// Your Google API Key
  static const String googleApiKey = 'AIzaSyB7SgtlI6rusxig8RGFw2abZQxdIsw3t9w';
  String location = "Search Location";

  _showPassengerDrawer(BuildContext context, providerData,isLoggedIn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 10, 20, 0),
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
                      providerData.updateLoadingPointPostLoad(
                          place: "", city: "", state: "");
                    },
                  ),
                ),
                const Row(
                  children: [
                    SizedBox(
                        width: 35,
                        child: DottedLineWidget(
                          direction: Axis.vertical,
                          lineLength: 40,
                          lineThickness: 2.0,
                          dashLength: 3.0,
                          dashColor: Color.fromARGB(255, 52, 68, 207),
                          width: 30,
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
                // _buildVerticalDottedLine(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 20, 4),
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
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueAccent,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          if (newValue == 'Schedule for Later') {
                            Get.to(() => ScheduleRideScreen());
                          }
                        });
                      },
                      items: <String>['Now', 'Schedule for Later']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                  ),
                ),


                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    isLoggedIn ? Get.to(() => SearchScreen(
                      loadPointModel: ArrivalPointLoactionModel,
                      unloadPointModel: DestinationPointLocationModel,
                    )) : Get.to(() => LogIn());
                    // Get.to(() => SearchScreen(
                    //       loadPointModel: ArrivalPointLoactionModel,
                    //       unloadPointModel: DestinationPointLocationModel,
                    //     ));
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(239, 51),
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    backgroundColor: const Color.fromRGBO(34, 48, 147, 1),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildVerticalDottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5),
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
}
