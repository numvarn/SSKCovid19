import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:sskcovid19/cslib/authenFileProcess.dart';
import 'package:sskcovid19/cslib/profileFileProcess.dart';
import 'package:sskcovid19/pages/login.dart';
import 'package:sskcovid19/pages/register.dart';
import 'package:sskcovid19/pages/checkin.dart';
import 'package:sskcovid19/pages/profile.dart';

// Operation Page After login
class OperationPage extends StatefulWidget {
  OperationPage({Key key}) : super(key: key);

  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  //Progress Dialog
  ProgressDialog pr;

  //Read config file
  AuthenFileProcess authenFileProcess = new AuthenFileProcess();
  ProfileFileProcess profileFileProcess = new ProfileFileProcess();

  String profileName;

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    super.initState();
    getProfileAPI();
  }

  @override
  Widget build(BuildContext context) {
    // Get profile name for show on screen

    final checkInButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CheckinPage()),
          );
        },
        child: Text("ส่งพิกัดสถานที่ปัจจุบัน",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final profileButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
        child: Text("แก้ไขประวัติสมาชิก",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final assessmentButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
          );
        },
        child: Text("แบบประเมินความเสี่ยง",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final logoutButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          logoutProcess();
        },
        child: Text("ออกจากระบบ",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('SSK fight covid-19'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(this.profileName.toString(),
                style: new TextStyle(color: hexToColor("#3371ff"), fontSize: 25.0),),
              SizedBox(height: 35.0),
              checkInButton,
              SizedBox(height: 35.0),
              profileButton,
              SizedBox(height: 35.0),
              assessmentButton,
              SizedBox(height: 35.0),
              logoutButton,
            ],
          ),
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(items: [
        new BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text("Home"),
        ),
        new BottomNavigationBarItem(
            icon: Icon(Icons.person), title: Text('Profile')),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.search),
          title: new Text("Search"),
        )
      ]),
    );
  }

  void logoutProcess() async {
    // Progress Dialog
    pr = new ProgressDialog(context);
    pr.style(
      message: '  Loging out...',
      progressWidget: CircularProgressIndicator(),
    );

    pr.show();

    authenFileProcess.writeToken("{}");
    profileFileProcess.writeProfile("{}");

    pr.hide();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogInPage()),
    );
  }

  void getProfileAPI() async {
    if (profileName == null) {
      var url = "https://ssk-covid19.herokuapp.com/get/myuser";

      //Get user authentication token form auth file
      final jsonDec = authenFileProcess.readToken().then((val) {
        return json.decode(val);
      });

      //Get current user profile from API
      var httpResponse = jsonDec.then((val) {
        final token = val['token'];
        return Http.get(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: "Token $token"});
      });

      //Write Profile of current user to json file
      httpResponse.then((response){
        String body = utf8.decode(response.bodyBytes);
        profileFileProcess.writeProfile(body);

        final profile = json.decode(body);

        setState((){
          profileName = profile['results'][0]['first_name']+" "+profile['results'][0]['last_name'];
        });

      });
    }
  }
}
