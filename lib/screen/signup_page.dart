import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui_helper.dart';


class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isAccCreating = false;

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var mobNoController = TextEditingController();

  var passController = TextEditingController();

  var confirmPassController = TextEditingController();

  bool isPassVisible = false;

  bool isConfirmPassVisible = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FirebaseAuth? fireAuth;
  FirebaseFirestore? firestore;

  @override
  void initState() {
    super.initState();
    fireAuth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
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
                "Welcome, please sign up..",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                controller: nameController,
                decoration: AppDecoration.mDecoration(
                  label: "Name",
                  hint: "Enter your name here..",
                ),
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
                controller: mobNoController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your mob no";
                  } else if (value.length != 10) {
                    return "Please enter a valid mob no";
                  }
                  return null;
                },
                decoration: AppDecoration.mDecoration(
                  label: "Mobile No",
                  hint: "Enter your mobile no here..",
                  mIcon: Icons.phone_outlined,
                ),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  } else if (!RegExp(
                      r'''^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}''')
                      .hasMatch(value)) {
                    return "Password must be at least 8 characters \nand include uppercase, lowercase, digit, \nand special character.";
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
              TextFormField(
                validator: (value) {
                  if (passController.text != confirmPassController.text) {
                    return "Password not matched";
                  }
                  return null;
                },
                obscureText: !isConfirmPassVisible,
                controller: confirmPassController,
                decoration: AppDecoration.mDecoration(
                  label: "Confirm Password",
                  hint: "Enter your confirm password here..",
                  isPass: true,
                  isPasswordVisible: isConfirmPassVisible,
                  onObscureTap: () {
                    isConfirmPassVisible = !isConfirmPassVisible;
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
                        if (formKey.currentState!.validate()){
                          /// sign up work here
                          try{
                             UserCredential userCredential = await fireAuth!.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passController.text);

                             if(userCredential.user!=null){
                               firestore!.collection("user").doc(userCredential.user!.uid).set({
                                 "name":nameController.text,
                                 "email":emailController.text,
                                 "mobNo":mobNoController.text,
                                 "createdAt":DateTime.now().millisecondsSinceEpoch,
                               });
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account created successfully.",),backgroundColor: Colors.green,));

                               Navigator.pop(context);
                             }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The password provided is too weak.",),backgroundColor: Colors.red,));
                              print(
                                  'The account already exists for that email.');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The account already exists for that email. "),backgroundColor: Colors.red,));
                            }
                          }
                          catch (e){
                            print("Error: ${toString()}");
                            /// ScaffoldMessenger use for pop up
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        }
                      },
                      child: Text('SignUp'),
                    ),
                ),
              SizedBox(height: 11),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Already have an account,'),
                        TextSpan(
                          text: ' Login now',
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
      ));

  }
}