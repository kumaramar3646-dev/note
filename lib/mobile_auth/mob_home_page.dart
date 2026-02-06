import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobHomePage extends StatefulWidget {
  const MobHomePage({super.key});

  @override
  State<MobHomePage> createState() => _MobHomePageState();
}

class _MobHomePageState extends State<MobHomePage> {

  var mobController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined),
              hintText: "Enter mob no",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
          SizedBox(
            height: 21,
          ),
          ElevatedButton(onPressed: (){
            /// process to send otp
          }, child: Text("Login"),)
        ],
      ),
    );
  }
}
