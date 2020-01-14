import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dextrous_crm_new2/ui/report_dash.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'filter_report.dart';


class ClientReport extends StatefulWidget {

  String start_date='',end_date='';

  ClientReport({Key key, @required this.start_date, this.end_date}) : super(key: key);



  @override
  _ClientReportState createState() => new _ClientReportState(start_date: start_date,end_date: end_date);
}

class _ClientReportState extends State<ClientReport> {

  String start_date='',end_date='';

  _ClientReportState({Key key, @required this.start_date, this.end_date}) : super();


  final String uri =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/report/client_report";

  bool isHomeDataLoading;

  String leads_tab = "assets/images/leads1.png",
      status_tab = "assets/images/status.png";

  int countValue = 0;

  Future<List<Reports>> getToekn(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/report/client_report";
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

  Future<bool> _onBackPressed() {
    return null;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: WillPopScope(
          onWillPop: _onBackPressed,
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
                                  Navigator.of(context).push(MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                        return new ReportsOne();
                                      }));
                                }),
                            Expanded(
                              child: Text(
                                'Client Report',
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
                                        builder: (context) => FilterReport(start_date: '',end_date: '',type:'client',
                                        ),
                                      ));

//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                                }),
//                            new IconButton(
//                                icon: Icon(
//                                  Icons.sort,
//                                  color: Colors.black,
//                                  size: 20,
//                                ),
//                                onPressed: () {
//                                  if (Navigator.canPop(context)) {
//                                    Navigator.pop(context);
//                                  } else {
//                                    SystemNavigator.pop();
//                                  }
//                                }),
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
  final String client;
  final String checkInDatetime;
  final String checkInLocation;
  final String checkOutDatetime;
  final String checkOutLocation;

  Reports({
    this.client,
    this.checkInDatetime,
    this.checkInLocation,
    this.checkOutDatetime,
    this.checkOutLocation,
  });

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      client: json['client'],
      checkInDatetime: json['checkInDatetime'],
      checkInLocation: json['checkInLocation'],
      checkOutDatetime: json['checkOutDatetime'],
      checkOutLocation: json['checkOutLocation'],
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
          padding: const EdgeInsets.all(8.0),
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
                                    "${cellModel.client}",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),

                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
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
                                    "Check In    Date and Time: ",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${cellModel.checkInDatetime}",
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'images/checkin.png',
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
                                    "Ckeck Out Date and Time: ",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${cellModel.checkOutDatetime}",
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'images/checkout.png',
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
                                    "Check In location: ",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${cellModel.checkInLocation}",
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
                                    "Check Out location: ",
                                    style: new TextStyle(
                                        color: Color(0xFF1F244C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${cellModel.checkOutLocation}",
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