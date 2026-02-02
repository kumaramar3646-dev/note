import 'package:fire_exp_app/home_page.dart';
import 'package:fire_exp_app/screen/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui_helper.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();

  var passController = TextEditingController();

  bool isPassVisible = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isAuthenticating = false;

  bool isLogin = true;

  FirebaseAuth? fireAuth;

  @override
  void initState() {
    super.initState();
    fireAuth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Back, please login..",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  } else if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value)) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                controller: emailController,
                decoration: AppDecoration.mDecoration(
                  label: "Email",
                  hint: "Enter your email here..",
                  mIcon: Icons.email_outlined,
                ),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
                controller: passController,
                obscureText: !isPassVisible,
                decoration: AppDecoration.mDecoration(
                  label: "Password",
                  hint: "Enter your password here..",
                  isPass: true,
                  isPasswordVisible: isPassVisible,
                  onObscureTap: () {
                    isPassVisible = !isPassVisible;
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: 11),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade200,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: ()async{
                        if (formKey.currentState!.validate()) {
                          /// login work here

                          try{
                             UserCredential userCredential = await fireAuth!.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passController.text,
                            );

                             if(userCredential.user!=null){
                               /// login successfully
                               SharedPreferences prefs = await SharedPreferences.getInstance();
                               prefs.setString("uid", userCredential.user!.uid);
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login successfully."), backgroundColor: Colors.green,));
                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));

                             }else{
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong."), backgroundColor: Colors.red,));
                             }

                          }on FirebaseAuthException catch(e){

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,));

                          } catch(e){
                            print("Error: ${toString()}");
                            /// ScaffoldMessenger use for pop up
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,));
                          }

                        }
                      },
                      child: isAuthenticating
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 11),
                          Text('Authenticating...'),
                        ],
                      ): Text('Login'),
                    ),

              ),
              SizedBox(height: 11),
              InkWell(
                onTap: () {
                  isLogin = false;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpPage()));
                },
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Don\'t have an account,'),
                        TextSpan(
                          text: ' Create now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade200,
                          ),
                        ),
                      ],
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}