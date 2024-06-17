import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hitchify_app/constant/providerData.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../cache/locationCache.dart';
import '../widget/autoFillDataDisplayCard.dart';
import '../widget/autoFillGoogle.dart';
import '../model/autoFillMMIModel.dart';
import '../constant/color.dart';

class CityNameInputScreen extends StatefulWidget {
  final String page;
  final String valueType;

  const CityNameInputScreen(this.page, this.valueType, {super.key});

  @override
  _CityNameInputScreenState createState() => _CityNameInputScreenState();
}

class _CityNameInputScreenState extends State<CityNameInputScreen> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late Position currentPosition;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    async_method();
    _initSpeech();
  }

  void async_method() async {
    // await getCurrentPosition();
    await Provider.of<ProviderData>(context, listen: false)
        .getCurrentPosition();
    setState(() {
      loading = false;
    });
  }

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

  Future<void> getCurrentPosition() async {
    //final hasPermission = await _handleLocationPermission();
    //if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      debugPrint(position.toString());
      setState(() {
        currentPosition = position;
        loading = false;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  var locationCard;
  TextEditingController controller = TextEditingController();

  /// This has to happen only once per app
  Future<void> _initSpeech() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required')),
      );
    }
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(onResult: _onSpeechResult);
      setState(() {});
    } else {
      print('Speech recognition is not enabled.');
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      controller = TextEditingController(text: _lastWords);
      if (widget.page == "postLoad") {
        locationCard = fillCityGoogle(controller.text,
            currentPosition); //google place api is used in postLoad
      } else {
        // locationCard = fillCity(controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double keyboardLength = MediaQuery.of(context).viewInsets.bottom;
    double screenHeight = MediaQuery.of(context).size.height;
    return loading == true
        ? const SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: SpinKitRotatingCircle(
                    color: darkBlueColor,
                    size: 50.0,
                  ),
                )),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent, // Status bar color
                  statusBarIconBrightness:
                      Brightness.light, // For Android (dark icons)
                  statusBarBrightness: Brightness.light, // For iOS (dark icons)
                ),
              ),
              backgroundColor: backgroundColor,
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Row(
                        children: [
                          // BackButtonWidget(),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: liveasyBlackColor, width: 0.8),
                                borderRadius: BorderRadius.circular(30),
                                color: widgetBackGroundColor,
                              ),
                              child: Center(
                                // Center the TextFormField within the Container
                                child: TextFormField(
                                  textAlign: TextAlign
                                      .center, // Center the text within the TextFormField
                                  autofocus: true,
                                  controller: controller,
                                  onChanged: (String value) {
                                    setState(() {
                                      locationCard = fillCityGoogle(
                                          value,
                                          LocationCache()
                                              .currentPosition!); // google place api is used in postLoad
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Enter City Name',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical:
                                            10), // Adjust padding if needed
                                    prefixIcon: GestureDetector(
                                      onTap: _speechToText.isNotListening
                                          ? _startListening
                                          : _stopListening,
                                      child: Icon(_speechToText.isNotListening
                                          ? Icons.mic_off
                                          : Icons.mic),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    locationCard == null
                        ? Container()
                        : const SizedBox(
                            height: 8,
                          ),
                    locationCard != null
                        ? Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            height: keyboardLength != 0
                                ? screenHeight - keyboardLength - 130
                                : screenHeight - 130, //TODO: to be modified
                            child: FutureBuilder(
                                future: locationCard,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.data == null) {
                                    return Container();
                                  }
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    reverse: false,
                                    // padding: EdgeInsets.symmetric(
                                    //   horizontal: space_2,
                                    // ),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) =>
                                        AutoFillDataDisplayCard(
                                            snapshot.data[index].placeName,
                                            snapshot
                                                .data[index].addresscomponent,
                                            snapshot.data[index].placeCityName,
                                            snapshot.data[index].placeStateName,
                                            () {
                                      if (widget.valueType == "To") {
                                        Provider.of<ProviderData>(context,
                                                listen: false)
                                            .updateUnloadingPointPostLoad(
                                                place: snapshot
                                                    .data[index].placeName,
                                                city: snapshot.data[index]
                                                            .placeCityName ==
                                                        ""
                                                    ? snapshot
                                                        .data[index].placeName
                                                    : snapshot.data[index]
                                                        .placeCityName,
                                                state: snapshot.data[index]
                                                    .placeStateName);
                                        Provider.of<ProviderData>(context,
                                                    listen: false)
                                                .destinationPointAddress =
                                            snapshot.data[index].fullAddress;
                                        Provider.of<ProviderData>(context,
                                                listen: false)
                                            .updateDestinationPointLocationModel(
                                                snapshot.data[index]);
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>  DashboardScreen(),
                                        //
                                        //   ),
                                        // );
                                        // Get.off(FindLoadScreen());
                                        Provider.of<ProviderData>(context,
                                                    listen: false)
                                                .destinationPointAddress =
                                            snapshot.data[index].fullAddress;
                                        Get.back();
                                      } else if (widget.valueType == "From") {
                                        Provider.of<ProviderData>(context,
                                                listen: false)
                                            .updateLoadingPointPostLoad(
                                                place: snapshot
                                                    .data[index].placeName,
                                                city: snapshot
                                                    .data[index].placeCityName,
                                                state: snapshot.data[index]
                                                    .placeStateName);
                                        Provider.of<ProviderData>(context,
                                                listen: false)
                                            .updateArrivalPointLocationModel(
                                                snapshot.data[index]);

                                        Provider.of<ProviderData>(context,
                                                    listen: false)
                                                .startingPointAddress =
                                            snapshot.data[index].fullAddress;
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => SearchScreen(loadPointModel: snapshot.data[index]),
                                        //   ),
                                        // );
                                        Get.back();
                                      }
                                    }),
                                  );
                                }),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          );
  }
}
