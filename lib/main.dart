import 'package:fire_exp_app/firebase_options.dart';
import 'package:fire_exp_app/notifications/noti_home.dart';
//import 'package:fire_exp_app/mobile_auth/mob_home_page.dart';
//import 'package:fire_exp_app/screen/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'notifications/notifications_service.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotiHome(),
    );
  }
}