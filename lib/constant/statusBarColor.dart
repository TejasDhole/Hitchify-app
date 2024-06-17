import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void setStatusBarStyle({Brightness iconBrightness = Brightness.light}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(

    statusBarIconBrightness: iconBrightness,
  ));
}
