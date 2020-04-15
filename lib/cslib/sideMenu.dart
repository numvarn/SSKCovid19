import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:sskcovid19/cslib/authenFileProcess.dart';
import 'package:sskcovid19/cslib/profileFileProcess.dart';

import 'package:sskcovid19/pages/operations.dart';
import 'package:sskcovid19/pages/checkin.dart';
import 'package:sskcovid19/pages/checkedin_tracker.dart';
import 'package:sskcovid19/pages/profile.dart';
import 'package:sskcovid19/pages/login.dart';
import 'package:sskcovid19/pages/self_screening.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'รายการเมนู',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                /*
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/logo.png")
                )
                */
            ),

          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('ศรีสะเกษสู้โควิด 19'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OperationPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('เกี่ยวกับเรา'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('ส่งพิกัดปัจจุบัน'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckinPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('ประวัติการเดินทาง'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrackerPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('ประเมินความเสี่ยง'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelfScreenPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('ประวัติส่วนตัว'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('ออกจากระบบ'),
            onTap: () {
              _logoutProcess(context);
            },
          ),
        ],
      ),
    );
  }

  void _logoutProcess(context) async {
    //Read config file
    AuthenFileProcess authenFileProcess = new AuthenFileProcess();
    ProfileFileProcess profileFileProcess = new ProfileFileProcess();

    // Progress Dialog
    ProgressDialog pr = new ProgressDialog(context);
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
}