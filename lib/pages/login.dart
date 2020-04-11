import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:sskcovid19/cslib/authenFileProcess.dart';
import 'package:sskcovid19/pages/operations.dart';
import 'package:sskcovid19/pages/register.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // TextField Controller
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //Progress Dialog
  ProgressDialog pr;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          signIn();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final regisButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()),);
        },
        child: Text("Does not have account? Sigup",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),

      body: Center(
        child: SingleChildScrollView (
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 155.0,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 45.0),
              emailField,
              SizedBox(height: 25.0),
              passwordField,
              SizedBox(
                height: 35.0,
              ),
              loginButon,
              SizedBox(
                height: 15.0,
              ),
              regisButon,
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    // Progress Dialog
    pr = new ProgressDialog(context);
    pr.style(
      message: '  Loging in...',
      progressWidget: CircularProgressIndicator(),
    );

    var url = "https://ssk-covid19.herokuapp.com/api/login";

    Map<String, String> data = {
      "username":emailController.text.trim(),
      "password":passwordController.text.trim()
    };

    pr.show();

    await Http.post(
        url,
        body: data
    ).then((response) {
      final responseJson = json.decode(response.body);
      if(responseJson['token'] != null) {
        pr.hide();

        String data = '{"token": "${responseJson['token']}"}';

        AuthenFileProcess authenFileProcess = new AuthenFileProcess();
        authenFileProcess.writeToken(data);

        Navigator.push(context, MaterialPageRoute(builder: (context) => OperationPage()),);
      } else {
        pr.hide();
        _showAlertLoginFail(context);
      }
    });
  }

  void _showAlertLoginFail(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid Username/Password"),
          content: Text("Please, check your username or password"),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        )
    );
  }
}
