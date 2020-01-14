import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/filter_report.dart';
import 'package:dextrous_crm_new2/ui/report_dash.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class AttendanceReport extends StatefulWidget {
  String start_date='',end_date='';

  AttendanceReport({Key key, @required this.start_date, this.end_date}) : super(key: key);

  @override
  _AttendanceReportState createState() => new _AttendanceReportState(start_date: start_date,end_date: end_date);
}

class _AttendanceReportState extends State<AttendanceReport> {

  String start_date='',end_date='';

  _AttendanceReportState({Key key, @required this.start_date, this.end_date}) : super();
  final String uri =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/report/attendance_report";

  bool isHomeDataLoading;

  String leads_tab = "assets/images/leads1.png",
      status_tab = "assets/images/status.png";

  int countValue = 0;

  Future<List<Reports>> getToekn(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/report/attendance_report";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.get('user_token'),
      "startDate" : !["", null, false, 0].contains(start_date)?start_date:'',
      "endDate" : !["", null, false, 0].contains(end_date)?end_date:'',
    });

    http.Response response = await http.post(login_url, body: formData);

    print(response.body);

    var body = await json.decode(response.body);
    //Simulate a service call
    print('submitting to backend...');
    Map<String, dynamic> decodedMap = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> dynamicList = decodedMap['result'];
        List<Reports> students = new List<Reports>();
        dynamicList.forEach((f) {
          Reports s = Reports.fromJson(f);
          students.add(s);
        });
        return students;
      } else {
        throw Exception("Internet Error");
      }
    } catch (e) {
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToekn('1');
    isHomeDataLoading = false;
  }

  setLoading(bool loading) {
    setState(() {
      isHomeDataLoading = loading;
    });
  }

  fetch() {
    setLoading(true);
  }

//  Future<bool> _onBackPressed() {
//    return
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) =>
//                AttendanceReport(),
//          ));
//  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: WillPopScope(
          child: new Container(
              child: new Stack(
                children: <Widget>[
                  Container(
                    color: Color(0xA19FC3EE),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReportsOne(

                                              ),
                                        ));


                                }),
                            Expanded(
                              child: Text(
                                'Attendance Report',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              flex: 1,
                            ),

                            new IconButton(
                                icon: Icon(
                                  Icons.filter_list,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FilterReport(start_date: '',end_date: '',type:'attand',
                                        ),
                                      ));

//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                                }),
                          ],
                        ),
                      ),
                      Flexible(
                        child: FutureBuilder<List<Reports>>(
                          future: getToekn('1'),
                          builder: (context, snapshot) {
                            return snapshot.connectionState == ConnectionState.done
                                ? snapshot.hasData
                                ? _ReportsCellState.homeGrid(snapshot, context)
                                : _ReportsCellState.retryButton(fetch)
                                : _ReportsCellState.circularProgress();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
        resizeToAvoidBottomPadding: true);
  }
}

class Reports {
  final String punchInDatetime;
  final String punchInLocation;
  final String punchOutDatetime;
  final String punchOutLocation;
  final String workingHours;

  Reports({
    this.punchInDatetime,
    this.punchInLocation,
    this.punchOutDatetime,
    this.punchOutLocation,
    this.workingHours,
  });

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      punchInDatetime: json['punchInDatetime'],
      punchInLocation: json['punchInLocation'],
      punchOutDatetime: json['punchOutDatetime'],
      punchOutLocation: json['punchOutLocation'],
      workingHours: json['workingHours'],
    );
  }
}

class ReportsCell extends StatefulWidget {
  int countValue = 0;

  ReportsCell(this.cellModel);

  @required
  final Reports cellModel;

  @override
  _ReportsCellState createState() => _ReportsCellState(this.cellModel);
}

class _ReportsCellState extends State<ReportsCell> {
  int countValue = 0;

  _ReportsCellState(this.cellModel);

  @required
  final Reports cellModel;

  static Container homeGrid(AsyncSnapshot<List<Reports>> snapshot, context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return ReportsCell(
            snapshot.data[index],
          );
        },
      ),
    );
  }

  static SizedBox circularProgress() {
    return SizedBox(
      height: 50.0,
      width: 50.0,
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightGreen),
      ),
    );
  }

  static FlatButton retryButton(Function fetch) {
    return FlatButton(
      child: Text(
        "No Data Found",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      onPressed: () => fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Color color2 = HexColor(cellModel.color);
    return GestureDetector(
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Stack(
              children: <Widget>[
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(

                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(

                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Punch In    Date and Time: ",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${cellModel.punchInDatetime}",
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Image.network(
                                    'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/checkin.png',
                                    height: 25.0,
                                    width: 25.0,
                                    fit: BoxFit.cover,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Punch Out Date and Time: ",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${cellModel.punchOutDatetime}",
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Image.network(
                                    'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/checkout.png',
                                    height: 25.0,
                                    width: 25.0,
                                    fit: BoxFit.cover,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 5),
                              child: Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width: double.infinity,
                                  height: 1.0,
                                  color: Colors.grey[200]),),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Punch In location: ",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${cellModel.punchInLocation}",
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Punch Out location: ",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${cellModel.punchOutLocation}",
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 5),
                              child: Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width: double.infinity,
                                  height: 1.0,
                                  color: Colors.grey[200]),),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Working Hours: ",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${cellModel.workingHours}",
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )),
      onTap: () {
        // setState(() => countValue == 0 ? countValue = 1 : countValue = 0);
        // Grid Click

//        Navigator.of(context).push(MaterialPageRoute<Null>(
//            builder: (BuildContext context) {
//              //return new TaskDetails(text: cellModel.meting_id,);
//            })
//        );
      },
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}