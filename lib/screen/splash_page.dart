import 'dart:async';

import 'package:fire_exp_app/todo_home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import '../home_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
     Timer(Duration(seconds: 2), ()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString("uid") ?? "";

      Widget nextPage = LoginPage();

      if(uid.isNotEmpty){
        nextPage = TodoHomePage();
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => nextPage));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 500),
          child: Column(
            children: [
              FlutterLogo(size: 100),
              SizedBox(height: 11),
              Text("Flutter App", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}
