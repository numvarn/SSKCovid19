import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;

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
  //ProgressDialog pr;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('หยุดการทำงานโปรแกรม'),
        content: new Text('คุณต้องการหยุดการทำงานโปรแกรม ?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('ไม่ใช่'),
          ),
          new FlatButton(
            onPressed: () => exit(0), //Navigator.of(context).pop(true),
            child: new Text('ใช่'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "ชื่อผู้ใช้ระบบ/อีเมล",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "รหัสผ่าน",
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
          _signIn();
        },
        child: Text("เข้าสู่ระบบ",
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
        child: Text("ลงทะเบียนผู้ใช้งานใหม่",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
        child:Scaffold(
          appBar: AppBar(
            title: Text('เช้าใช้งานระบบ'),
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
        ),
    );
  }

  void _signIn() async {
    var url = "https://ssk-covid19.herokuapp.com/api/login";

    Map<String, String> data = {
      "username":emailController.text.trim(),
      "password":passwordController.text.trim()
    };

    if(emailController.text.trim() != "" && passwordController.text.trim() != "") {
      var response = await Http.post(url, body:data);

      final responseJson = json.decode(response.body);

      if(responseJson['token'] != null) {
        String data = '{"token": "${responseJson['token']}"}';

        AuthenFileProcess authenFileProcess = new AuthenFileProcess();
        authenFileProcess.writeToken(data);

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OperationPage())
        );
      } else {
        _showAlertLoginFail(context);
      }
    } else {
      _showAlertLoginFail(context);
    }
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
                Navigator.pop(context, true);
              },
            )
          ],
        )
    );
  }
}
