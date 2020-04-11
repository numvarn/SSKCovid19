import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:sskcovid19/pages/login.dart';

//------------------------------------------------------------------------------
// Register Page
class RegisterPage extends StatelessWidget {
  //Progress Dialog
  ProgressDialog pr;

  // TextField Controller
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextField(
      controller: firstNameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final lastNameField = TextField(
      controller: lastNameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Last Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
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

    final regisButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          regisAccount(context);
        },
        child: Text("Register Accunt",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Register your account"),
      ),
      body: Center(
        child: SingleChildScrollView (
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 125.0,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 15.0),
              firstNameField,
              SizedBox(height: 15.0),
              lastNameField,
              SizedBox(height: 15.0),
              emailField,
              SizedBox(height: 15.0),
              passwordField,
              SizedBox(height: 15.0),
              regisButon,
            ],
          ),
        ),
      ),
    );
  }
  Future<void> regisAccount(context) async {
    pr = new ProgressDialog(context);
    pr.style(
      message: '  Waiting...',
      progressWidget: CircularProgressIndicator(),
    );

    pr.show();

    var url = "https://ssk-covid19.herokuapp.com/api/regis";

    Map<String, String> data = {
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      "email": emailController.text.trim(),
      "username": emailController.text.trim(),
      "password": passwordController.text.trim()
    };

    await Http.post(
        url,
        body: data
    ).then((response) {
      final responseJson = json.decode(response.body);
      if (responseJson['status'] == 'success') {
        pr.hide();
        _showAlertRegisterSuccess(context);
      }
      else {
        pr.hide();
        _showAlertAccountExist(context);
      }
    });
  }

  void _showAlertAccountExist(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("กรุณาตรวจสอบข้อมูล"),
          content: Text("email นี้มีการลงทะเบียนไปแล้ว"),
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
  void _showAlertRegisterSuccess(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("ลงทะเบียนสำเร็จ"),
          content: Text("ท่านสามารถล็อกอินเพื่อใช้งานได้ทันที"),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogInPage()),
                );
              },
            )
          ],
        )
    );
  }
}