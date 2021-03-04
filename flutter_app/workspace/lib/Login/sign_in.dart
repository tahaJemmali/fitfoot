import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:workspace/Login/utils/default_button.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: SafeArea(
            child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height:20),
                Image.asset('assets/fflogo.png',width: 200,),
                SizedBox(height:20),
                Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign in with your email and password",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height:20),
                SignInForm(),
              ],
            ),
          ),
        )));
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Enter your email",
              labelText: "Email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                  child: new Icon(Icons.email)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 42, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 10,
              ),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your password",
              labelText: "Password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                  child: new Icon(Icons.lock)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 42, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 10,
              ),
            ),
          ),
          /*TextButton(
            onPressed: () {
              print('Pressed');
            },
            child: Text(
              'Login',
            ),
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                    side: BorderSide(color: Colors.blue)),
                primary: Colors.white,
                backgroundColor: Colors.blue,
                textStyle:
                    TextStyle(fontSize: 24, fontStyle: FontStyle.normal)),
          ),*/
          SizedBox(height: 15),
          Padding(padding: EdgeInsets.only(left:180),
                      child: RichText(
      text: TextSpan(
        text: '',
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
            /*TextSpan(
                text: 'world!',
                style: TextStyle(fontWeight: FontWeight.bold)),*/
            TextSpan(
                text: 'Forgot your password ?',
                style: TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => print('clicked forget password')),
        ],
      ),
    ),
          ),
          SizedBox(height: 15),
          DefaultButton(
            text: "Login",
            press: () {
            },
          ),
          
        ],
      ),
    );
  }
}

Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 20.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: 'By clicking Sign Up, you agree to our '),
          TextSpan(
              text: 'Terms of Service',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print('Terms of Service"');
                }),
          TextSpan(text: ' and that you have read our '),
          TextSpan(
              text: 'Privacy Policy',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print('Privacy Policy"');
                }),
        ],
      ),
    );
  }