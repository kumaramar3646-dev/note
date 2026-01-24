import 'package:fire_exp_app/sign_up_page.dart';
import 'package:fire_exp_app/ui_helper.dart';
import 'package:flutter/material.dart';

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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      /// login work here

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
                  )
                      : Text('Login'),
                ),
              ),
              SizedBox(height: 11),
              InkWell(
                onTap: () {
                  isLogin = false;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(),));
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