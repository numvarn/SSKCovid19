import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:intl/intl.dart';

import 'package:sskcovid19/cslib/authenFileProcess.dart';

class TrackerPage extends StatefulWidget {
  TrackerPage({Key key}) : super(key: key);

  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  //Read config file
  AuthenFileProcess authenFileProcess = new AuthenFileProcess();

  String token;
  bool loadCheck = false;
  var jsonData;
  List<CheckedInHistory> dataList = [];

  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  Future<String> _getCheckedIn() async {
    if (token == null) {
      authenFileProcess.readToken().then((val) {
        final jsonToken = json.decode(val);
        setState(() {
          token = jsonToken['token'];
        });
      });
    }

    if (token != null && loadCheck == false) {
      setState(() {
        loadCheck = true;
      });

      var response = await Http.get(
          "https://ssk-covid19.herokuapp.com/get/mycheckedin",
          headers: {HttpHeaders.authorizationHeader: "Token $token"}
          );
      var body = utf8.decode(response.bodyBytes);

      setState(() {
        jsonData = json.decode(body);
      });

    }

    return token;
  }

  @override
  Widget build(BuildContext context) {
    if(jsonData != null) {
      for (var u in jsonData['results']) {
        //Convert DateTime
        var dateCreate = DateTime.parse(u['date_created']).toLocal();
        print(u['date_created']);
        print(dateCreate);

        CheckedInHistory history = CheckedInHistory(
            u['account'],
            double.parse(u['latitude']),
            double.parse(u['longitude']), u['status'],
            u['route'],
            u['subdistrict'],
            u['district'],
            u['province'],
            u['country'],
            u['postcode'],
            dateFormat.format(dateCreate)
        );
        dataList.add(history);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ประวัติการเดินทาง',
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: new FutureBuilder(
            future: _getCheckedIn(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: FlutterLogo(),
                        title: Text(
                            '${dataList[index].route}, \n'
                                '${dataList[index].subDistrict}, \n'
                                '${dataList[index].district}, \n'
                                '${dataList[index].province}, '
                                '${dataList[index].postcode}, \n'
                        ),
                        subtitle: Text(
                            '${dataList[index].date} \n'
                                '[${dataList[index].latitude}, '
                                '${dataList[index].longitude}]'
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
        ),
    );
  }
}


class CheckedInHistory {
  int account;
  double latitude;
  double longitude;
  int status;
  String route;
  String subDistrict;
  String district;
  String province;
  String country;
  String postcode;
  String date;

  CheckedInHistory(this.account, this.latitude, this.longitude, this.status, this.route, this.subDistrict, this.district, this.province, this.country, this.postcode, this.date);
}