import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hitchify_app/constant/providerData.dart';
import 'package:hitchify_app/login.dart';
import 'package:hitchify_app/signup.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'Dashboard.dart';
import 'UserPreferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCJGPxhP4sUpNrLM7RL9tfytHt03mhIFQM',
        appId: '1:342575262405:android:8bbcea3d6ac022e2e8deac',
        messagingSenderId: 'sendid',
        projectId: 'hitchify-b9175',
        storageBucket: "hitchify-b9175.appspot.com",
      )
  );
  // await dotenv.load();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserPreferences().getUserLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while reading preferences
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return OverlaySupport(
              child: ChangeNotifierProvider<ProviderData>(
                create: (context) => ProviderData(),
                builder: (context, child) {
                  return GetMaterialApp(
                    home: DashboardScreen(),
                  );
                }
              ),
            );
          }
        }
      },
    );
  }
}
