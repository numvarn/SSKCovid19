import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';

import 'package:sskcovid19/pages/operations.dart';
import 'package:sskcovid19/cslib/authenFileProcess.dart';
import 'package:sskcovid19/cslib/profileFileProcess.dart';

class AssessmentResult {
  int riskScore;
  String riskSuggession;
  AssessmentResult(this.riskScore, this.riskSuggession);
}

class SelfScreenPage extends StatefulWidget {

  SelfScreenPage({Key key}) : super(key: key);

  @override
  _SelfScreenPageState createState() => _SelfScreenPageState();
}

class _SelfScreenPageState extends State<SelfScreenPage> {
  AssessmentResult assResult;
  TextStyle style = TextStyle(
      color: Color.fromRGBO(0, 102, 255, 1),
      fontSize: 20.0
  );

  TextStyle bulletStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
    color: Color.fromRGBO(77, 148, 255, 1),
  );

  int groupQ1 = 1;
  int groupQ2 = 1;
  int groupQ3 = 1;
  int groupQ4 = 1;
  int groupQ5 = 1;
  int groupQ6 = 1;
  int groupQ7 = 1;
  int groupQ8 = 1;

  @override
  Widget build(BuildContext context) {
    final assessmentButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          assessScreening();
        },
        child: Text("ประเมินตนเอง",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('แบบประเมินระดับความเสื่ยง'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OperationPage()),
              );
            },
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
                children: [
                  //Q1
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Card(
                      elevation: 2.0,
                      child: SizedBox(
                        height: 80,
                        child: ListTile(
                          leading: Text("1", style: bulletStyle),
                          title: Text(
                              "ผู้ป่วยมีอุณหภูมิร่างกายตั้งแต่ 37.5 องศาขึ้นไป หรือ ให้ประวัติว่ามีไข้",
                              style: style
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        child: ListTile(
                          leading: Radio(
                            value: 1,
                            groupValue: groupQ1,
                            onChanged: (T) {
                              setState(() {
                                groupQ1 = T;
                              });
                            },
                          ),
                          title: Text("ต่ำกว่า 37.5"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        //height: MediaQuery.of(context).size.height * 0.50,
                        child: ListTile(
                          leading: Radio(
                            value: 2,
                            groupValue: groupQ1,
                            onChanged: (T) {
                              setState(() {
                                groupQ1 = T;
                              });
                            },
                          ),
                          title: Text("สูงกว่าหรือเท่ากับ 37.5"),
                        ),
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  //Q2
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Card(
                      elevation: 2.0,
                      child: SizedBox(
                        child: ListTile(
                          leading: Text("2", style: bulletStyle),
                          title: Text("ผู้ป่วยมีอาการระบบทางเดินหายใจ อย่างใดอย่างหนึ่งดังต่อไปนี้ \"ไอ น้ำมูก เจ็บคอ หายใจเหนื่อย หรือหายใจลำบาก\" ", style: style,),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        child: ListTile(
                          leading: Radio(
                            value: 1,
                            groupValue: groupQ2,
                            onChanged: (T) {
                              setState(() {
                                groupQ2 = T;
                              });
                            },
                          ),
                          title: Text("ไม่มีอาการใด ๆ ข้างต้น"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        //height: MediaQuery.of(context).size.height * 0.50,
                        child: ListTile(
                          leading: Radio(
                            value: 2,
                            groupValue: groupQ2,
                            onChanged: (T) {
                              setState(() {
                                groupQ2 = T;
                              });
                            },
                          ),
                          title: Text("มีอาการ"),
                        ),
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  //Q3
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Card(
                      elevation: 2.0,
                      child: SizedBox(
                        child: ListTile(
                          leading: Text("3", style: bulletStyle),
                          title: Text("ผู้ป่วยมีประวัติเดินทางไปยัง หรือ มาจาก หรือ อาศัยอยู่ในพื้นที่เกิดโรค COVID-19 ในช่วงเวลา 14 วัน ก่อนป่วย", style: style,),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        child: ListTile(
                          leading: Radio(
                            value: 1,
                            groupValue: groupQ3,
                            onChanged: (T) {
                              setState(() {
                                groupQ3 = T;
                              });
                            },
                          ),
                          title: Text("ไม่มีประวัติ"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        //height: MediaQuery.of(context).size.height * 0.50,
                        child: ListTile(
                          leading: Radio(
                            value: 2,
                            groupValue: groupQ3,
                            onChanged: (T) {
                              setState(() {
                                groupQ3 = T;
                              });
                            },
                          ),
                          title: Text("มีประวัติความเสี่ยง"),
                        ),
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  //Q4
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Card(
                      elevation: 2.0,
                      child: SizedBox(
                        child: ListTile(
                          leading: Text("4", style: bulletStyle),
                          title: Text("อยู่ใกล้ชิดกับผู้ป่วยยืนยัน COVID-19 (ใกล้กว่า 1 เมตร นานเกิน 5 นาที) ในช่วง 14 วันก่อน ", style: style,),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        child: ListTile(
                          leading: Radio(
                            value: 1,
                            groupValue: groupQ4,
                            onChanged: (T) {
                              setState(() {
                                groupQ4 = T;
                              });
                            },
                          ),
                          title: Text("ไม่มี"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        //height: MediaQuery.of(context).size.height * 0.50,
                        child: ListTile(
                          leading: Radio(
                            value: 2,
                            groupValue: groupQ4,
                            onChanged: (T) {
                              setState(() {
                                groupQ4 = T;
                              });
                            },
                          ),
                          title: Text("มีความใกล้ชิดผู้ป่วย"),
                        ),
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  //Q5
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Card(
                      elevation: 2.0,
                      child: SizedBox(
                        child: ListTile(
                          leading: Text("5", style: bulletStyle),
                          title: Text("มีประวัติไปสถานที่ชุมนุมชน หรือสถานที่ที่มีการรวมกลุ่มคน เช่น ตลาดนัด ห้างสรรพสินค้า สถานพยาบาล หรือ ขนส่งสาธารณะ", style: style,),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        child: ListTile(
                          leading: Radio(
                            value: 1,
                            groupValue: groupQ5,
                            onChanged: (T) {
                              setState(() {
                                groupQ5 = T;
                              });
                            },
                          ),
                          title: Text("ไม่มี"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        //height: MediaQuery.of(context).size.height * 0.50,
                        child: ListTile(
                          leading: Radio(
                            value: 2,
                            groupValue: groupQ5,
                            onChanged: (T) {
                              setState(() {
                                groupQ5 = T;
                              });
                            },
                          ),
                          title: Text("มี"),
                        ),
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  //Q6
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Card(
                      elevation: 2.0,
                      child: SizedBox(
                        child: ListTile(
                          leading: Text("6", style: bulletStyle),
                          title: Text("ผู้ป่วยประกอบอาชีพที่สัมผัสใกล้ชิดกับนักท่องเที่ยวต่างชาติ สถานที่แออัด หรือติดต่อคนจำนวนมาก", style: style,),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        child: ListTile(
                          leading: Radio(
                            value: 1,
                            groupValue: groupQ6,
                            onChanged: (T) {
                              setState(() {
                                groupQ6 = T;
                              });
                            },
                          ),
                          title: Text("ไม่ใช่"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        //height: MediaQuery.of(context).size.height * 0.50,
                        child: ListTile(
                          leading: Radio(
                            value: 2,
                            groupValue: groupQ6,
                            onChanged: (T) {
                              setState(() {
                                groupQ6 = T;
                              });
                            },
                          ),
                          title: Text("ใช่"),
                        ),
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  //Q7
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Card(
                      elevation: 2.0,
                      child: SizedBox(
                        child: ListTile(
                          leading: Text("7", style: bulletStyle),
                          title: Text("เป็นบุคลากรทางการแพทย์", style: style,),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        child: ListTile(
                          leading: Radio(
                            value: 1,
                            groupValue: groupQ7,
                            onChanged: (T) {
                              setState(() {
                                groupQ7 = T;
                              });
                            },
                          ),
                          title: Text("ไม่ใช่"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        //height: MediaQuery.of(context).size.height * 0.50,
                        child: ListTile(
                          leading: Radio(
                            value: 2,
                            groupValue: groupQ7,
                            onChanged: (T) {
                              setState(() {
                                groupQ7 = T;
                              });
                            },
                          ),
                          title: Text("ใช่"),
                        ),
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  //Q8
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Card(
                      elevation: 2.0,
                      child: SizedBox(
                        child: ListTile(
                          leading: Text("8", style: bulletStyle),
                          title: Text("มีผู้ใกล้ชิดป่วยเป็นไข้หวัดพร้อมกัน มากกว่า 5 คน ในช่วงสัปดาห์ที่ป่วย", style: style,),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        child: ListTile(
                          leading: Radio(
                            value: 1,
                            groupValue: groupQ8,
                            onChanged: (T) {
                              setState(() {
                                groupQ8 = T;
                              });
                            },
                          ),
                          title: Text("ไม่มี"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Card(
                      elevation: 1,
                      child: SizedBox(
                        //height: MediaQuery.of(context).size.height * 0.50,
                        child: ListTile(
                          leading: Radio(
                            value: 2,
                            groupValue: groupQ8,
                            onChanged: (T) {
                              setState(() {
                                groupQ8 = T;
                              });
                            },
                          ),
                          title: Text("มี"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      children: <Widget>[
                        assessmentButton,
                      ],
                    ),
                  ),
                ],
            ),
          ),
        ),
    );
  }

  void assessScreening() {
    int riskScore;
    String suggest;

    //Case 1. No Risk
    if (groupQ1 == 1 && groupQ2 == 1 && groupQ3 == 1 && groupQ4 == 1 && groupQ5 == 1 && groupQ6 == 1 && groupQ7 == 1 && groupQ8 == 1) {
      riskScore = 1;
      suggest = "ล้างมือ สวมหน้ากาก หลีกเลี่ยงที่แออัด";
    }
    //Case 2. Risk 2
    else if (groupQ1 == 2 && groupQ2 == 1 && groupQ3 == 1 && groupQ4 == 1 && groupQ5 == 1 && groupQ6 == 1 && groupQ7 == 1 && groupQ8 == 1) {
      riskScore = 2;
      suggest = "อาจเป็นโรคอื่น ถ้า 2 วัน อาการไม่ดีขึ้นให้ไปพบแพทย์";
    }
    else if (groupQ1 == 2 && groupQ2 == 2 && groupQ3 == 1 && groupQ4 == 1 && groupQ5 == 1 && groupQ6 == 1 && groupQ7 == 1 && groupQ8 == 1) {
      riskScore = 2;
      suggest = "อาจเป็นโรคอื่น ถ้า 2 วัน อาการไม่ดีขึ้นให้ไปพบแพทย์";
    }
    //Case 3. Risk 3
    else if (groupQ1 == 1 && groupQ2 == 1 && groupQ3 == 2) {
      riskScore = 3;
      suggest = "เนื่องจากท่านมีประวัติเดินทางจากพื้นที่เสี่ยง ให้กักตัว 14 วัน พร้อมเฝ้าระวังอาการ ถ้ามีอาการไข้ ร่วมกับ อาการระบบทางเดินหายใจ ให้ติดต่อสถานพยาบาลทันที";
    }
    //Case 4. Risk 4
    else if ((groupQ1 == 2 && groupQ2 == 2) && (groupQ3 == 2 || groupQ4 == 2 || groupQ5 == 2 || groupQ6 == 2 || groupQ7 == 2 || groupQ8 == 2)){
      riskScore = 4;
      suggest = "ให้ติดต่อสถานพยาบาลทันที";
    }

    assResult = new AssessmentResult(riskScore, suggest);

    //Go to next page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelfScreenResultPage(),
        settings: RouteSettings(
          arguments: assResult,
        ),
      ),
    );

  }
}
//------------------------------------------------------------------------------
//Show Assessment Results Page
class SelfScreenResultPage extends StatefulWidget {

  SelfScreenResultPage({Key key}) : super(key: key);

  @override
  _SelfScreenResultPageState createState() => _SelfScreenResultPageState();
}

class _SelfScreenResultPageState extends State<SelfScreenResultPage> {
  //Read File
  AuthenFileProcess authenFileProcess = new AuthenFileProcess();
  ProfileFileProcess profileFileProcess = new ProfileFileProcess();

  AssessmentResult results;

  //For Communicate with API
  String tokenKey;
  int userID;

  //Progress Dialog
  ProgressDialog pr;

  //Test Style
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TextStyle headStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
    color: Color.fromRGBO(0, 153, 0, 1),
  );

  TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    color: Color.fromRGBO(51, 102, 255, 1),
  );

  TextStyle suggestStyle = TextStyle(
    fontSize: 16.0,
  );

  TextStyle scoreStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25.0,
    color: Color.fromRGBO(255, 51, 0, 1),
  );

  @override
  void initState() {
    super.initState();

    //Get User Profile
    profileFileProcess.readProfile().then((profileJSON){
      final profile = json.decode(profileJSON);
      setState(() {
        userID = profile['results'][0]['id'];
      });
    });

    //Get Authen Token
    authenFileProcess.readToken().then((tokenJSON) {
      final token = json.decode(tokenJSON);

      setState(() {
        tokenKey = token['token'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Get value from previous page
    results = ModalRoute.of(context).settings.arguments;

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _submitAssessment(context);
        },
        child: Text("บันทึกผลประเมิน",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final reAssessmentButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelfScreenPage())
          );
        },
        child: Text("ประเมินใหม่อีกครั้ง",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('รายงานผลประเมิน'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Card(
                elevation: 2,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      Text("ผลการประเมินของท่าน", style: headStyle),

                      SizedBox(height: 30.0),
                      Text("ความเสี่ยงรวม", style: labelStyle),
                      SizedBox(height: 10.0),
                      Text("${results.riskScore}", style: scoreStyle),

                      SizedBox(height: 30.0),
                      Text("คำแนะนำเบื้องต้น", style: labelStyle),
                      SizedBox(height: 10.0),
                      Text("ล้างมือ สวมหน้ากาก หลีกเลี่ยงที่แออัด", style: suggestStyle),

                      SizedBox(height: 30.0),
                      Text("คำแนะนำแบบเจาะจง", style: labelStyle),
                      SizedBox(height: 10.0),
                      SizedBox(
                        width: 300,
                        child: Text("${results.riskSuggession}", style: suggestStyle),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                children: <Widget>[
                  submitButton,
                  SizedBox(height: 15.0),
                  reAssessmentButon,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAssessment(BuildContext context) {

    pr = new ProgressDialog(context);
    pr.style(
      message: '  Sending Result...',
      progressWidget: CircularProgressIndicator(),
    );

    Map<String, String> data = {
      "account": "1",
      "assessment_score": results.riskScore.toString(),
      "assessment_suggest": results.riskSuggession,
    };

    pr.show();

    //Sending Location to API
    var response = Http.post(
      "https://ssk-covid19.herokuapp.com/post/self-screen",
      body: data,
      headers: {HttpHeaders.authorizationHeader: "Token $tokenKey"},
    );

    pr.hide();

    response.then((value){
      final bodyJson = json.decode(value.body);
      print(bodyJson);
      if(bodyJson['status'] == 'success'){
        _showAlertSubmitSuccessed(context);
      } else {
        _showAlertSubmitFail(context);
      }
    });

  }

  void _showAlertSubmitSuccessed(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("บันทึกผลเรียบร้อย"),
          content: Text("ทำการบันทึกผลการประเมินความเสี่ยงในการติดเชื้อของท่านแล้ว"),
          actions: <Widget>[
            FlatButton(
              child: Text('รับทราบ'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OperationPage()),
                );
              },
            )
          ],
        )
    );
  }

  void _showAlertSubmitFail(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("ไม่สามารถบันทึกข้อมูล"),
          content: Text("ไม่สามารถบันทึกผลการประเมินของท่านได้ กรุณาลองใหม่อีกครั้ง"),
          actions: <Widget>[
            FlatButton(
              child: Text('รับทราบ'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          ],
        )
    );
  }
}