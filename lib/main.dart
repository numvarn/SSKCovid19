import 'package:flutter/material.dart';
import 'cslib/authenFileProcess.dart';
import 'pages/login.dart';
import 'package:sskcovid19/pages/operations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sisaket Fight Covid-19',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sisaket Fight Covid-19'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  AuthenFileProcess authenticationFile = new AuthenFileProcess();

  void initState() {
    super.initState();
    _checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              '\n\nชาวศรีสะเกษ',
            ),
            Text(
              'ร่วมฝ่าภาวะวิกฤติการระบาดเชื้อ Covid-19 ไปด้วยกัน\n\n',
            ),
            RaisedButton(
              child: Text('Use Application'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogInPage()
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _checkAuthentication() {
    authenticationFile.readToken().then((val) {
      if(val == "fail" || val == "{}") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogInPage()
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OperationPage()
          ),
        );
      }
    });
  }
}
