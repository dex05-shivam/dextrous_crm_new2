import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/attandence_report.dart';
import 'package:dextrous_crm_new2/ui/expense_list.dart';
import 'package:dextrous_crm_new2/ui/report_lead.dart';
import 'package:dextrous_crm_new2/ui/task_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'clients_report.dart';
import 'home_screen.dart';
import 'location_report.dart';
import 'login_page.dart';




class ReportsOne extends StatefulWidget {
  @override
  _ReportsOneState createState() => new _ReportsOneState();
}

class _ReportsOneState extends State<ReportsOne> {

  bool isResponse = false;

  bool isHomeDataLoading = false;
  final TextEditingController _feedback = new TextEditingController();
//  int status;
  String
  pending_tasks,
      completed_tasks,
      Total_leads,
      approved_expense,
      Pending_expense,
      Total_meeting,
      client_number,
      client_name,
      today_meeting,meeting_type
  ;


  void getToekn(String type) async {
    isHomeDataLoading = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/report/reports";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),

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
        var body = await json.decode(response.body);
      //  status = body['status'];
        pending_tasks = body['pending_tasks'];
        completed_tasks = body['completed_tasks'];
        Total_leads = body['total_leads'];
        approved_expense = body['approved_expense'];
        Pending_expense = body['pending_expense'];
        Total_meeting = body['total_meeting'];

        // status=body['status'];
        setState(() {
          isHomeDataLoading = true;
        });
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }
  Future<bool> _onBackPressed() {
    return Future.value(true);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getToekn('1');

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: new Container(
              child: new Stack(
                children: <Widget>[
                  Container(
//                    child: Image.asset(
//                      'images/map_background.jpg',
//                      fit: BoxFit.fill,
//                    ),
                    color: Color(0xffe2f2f2),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            MyHomePage(
                                            ),
                                      ));
                                }),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child:Center(child: Text(
                                  'Reports',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),)),
                              flex: 1,
                            ),
//                            new IconButton(
//                                icon: Icon(
//                                  Icons.home,
//                                  color: Colors.black,
//                                  size: 20,
//                                ),
//                                onPressed: () {
////                            Provider.of<MenuController>(context, listen: true)
////                                .toggle();
//                                }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                            child: Card(
                                elevation: 5.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: GestureDetector(
                                            child: Container(
                                            padding: const EdgeInsets.all(5),
                                            height: 125.0,
                                            child: Card(
                                              elevation: 5.0,
                                              color: Color(0xffe0f0f0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(0, 0, 0, 0),
                                                        child: new Container(
                                                          child: new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/lead1.png',
                                                            height: 30.0,
                                                            width: 30,
                                                          ),
                                                        )),

                                                   Text(
                                                      !["", null, false, 0].contains(Total_leads)?Total_leads:'0',
                                                      style: TextStyle(
                                                          color: Color(0xff263e5a),
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 20.0),
                                                    ),

                                                  Text(
                                                      "Leads",
                                                      style: TextStyle(
                                                          color: Color(0xff263e5a),
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 15.0),
                                                    ),

                                                ],
                                              ),
                                            ),
                                          ),onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                                builder: (BuildContext context) {
                                                  return new ReportLead(start_date: '',end_date: '',);
                                                }));
                                          },),
                                        ),
                                        Expanded(
                                          child:GestureDetector(
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute<Null>(
                                                  builder: (BuildContext context) {
                                                    return new ExpenseLis(status: "2",);
                                                  }));
                                            },
                                            child:  Container(
                                            padding: const EdgeInsets.all(5),
                                            height: 125.0,
                                            child: Card(
                                              elevation: 5.0,
                                              color: Color(0xffffecdb),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: new Container(
                                                        child: new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/expense.png',
                                                          height: 30.0,
                                                          width: 30,
                                                        ),
                                                      )),

                                                  Text(
                                                    "Expense",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 15.0),
                                                  ),
                                                   Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(10, 0, 0, 0),
                                                        child: Text(
                                                          "Approved",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 10.0),
                                                        ),


                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(10, 0, 0, 0),
                                                        child: Text(
                                                          !["", null, false, 0].contains(approved_expense)? approved_expense:'0',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 12.0),
                                                        ),


                                                      ),
                                                    ],
                                                  ),
                                                   Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(10, 0, 0, 0),
                                                        child: Text(
                                                          "Pending",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 10.0),
                                                        ),


                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(10, 0, 0, 0),
                                                        child: Text(
                                                          !["", null, false, 0].contains(Pending_expense)?Pending_expense:'0',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 12.0),
                                                        ),


                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),),
                                        ),

                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child:GestureDetector(
                                            child:  Container(
                                            padding: const EdgeInsets.all(5),
                                            height: 125.0,
                                            child: Card(
                                              elevation: 5.0,
                                              color: Colors.redAccent[100],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                   Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(0, 5, 0, 0),
                                                        child: new Container(
                                                          child: new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/task1.png',
                                                            height: 25.0,
                                                            width: 25.0,
                                                          ),
                                                        )),

                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 10, 0, 0),child: Text(
                                                    "Task",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18.0),
                                                  ),),

                                                  Expanded(child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(10, 10, 0, 0),
                                                        child: Text(
                                                          "Completed",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 10.0),
                                                        ),


                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(10, 10, 0, 0),
                                                        child: Text(
                                                          !["", null, false, 0].contains(completed_tasks)?completed_tasks:'0',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 12.0),
                                                        ),


                                                      ),
                                                    ],
                                                  ),),
                                                  Expanded(child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(10, 0, 0, 0),
                                                        child: Text(
                                                          "Pending",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 10.0),
                                                        ),


                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(10, 0, 0, 0),
                                                        child: Text(
                                                          !["", null, false, 0].contains(pending_tasks)? pending_tasks:'0',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 12.0),
                                                        ),


                                                      ),
                                                    ],
                                                  ),),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                                builder: (BuildContext context) {
                                                  return new TaskList();
                                                }));
                                          },)
                                        ),
                                        Expanded(
                                          child:GestureDetector(child:
                                          Container(
                                            padding:  const EdgeInsets.all(5),
                                            height: 125.0,
                                            child: Card(
                                              elevation: 5.0,
                                              color: Colors.greenAccent[100],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: new Container(
                                                        child: new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/attendance.png',
                                                          height: 30.0,
                                                          width: 30,
                                                        ),
                                                      )),


                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 10, 0, 0),
                                                    child: Text(
                                                      "Attendance",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 15.0),
                                                    ),
                                                  ),


                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                                builder: (BuildContext context) {
                                                  return new AttendanceReport(start_date: '',end_date: '',);
                                                }));
                                          },) ,

                                        ),

                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: GestureDetector(child: Container(
                                            padding:  const EdgeInsets.all(5),

                                            height: 125.0,
                                            child: Card(
                                              elevation: 5.0,
                                              color: Colors.blueAccent[100],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: new Container(
                                                        child: new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/clients.png',
                                                          height: 30.0,
                                                          width: 30,
                                                        ),
                                                      )),


                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 0),
                                                    child: Text(
                                                      "Clients",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 20.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                            onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                                builder: (BuildContext context) {
                                                  return new ClientReport(start_date: '',end_date: '',);
                                                }));
                                          },),
                                        ),
                                        Expanded(
                                          child: GestureDetector(child: Container(
                                            padding:  const EdgeInsets.all(5),
                                            height: 125.0,
                                            child: Card(
                                              elevation: 5.0,
                                              color: Colors.red[100],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: new Container(
                                                        child: new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/address.png',
                                                          height: 40.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),

                                                  Text(
                                                    "Location",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 15.0),
                                                  ),


                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                                builder: (BuildContext context) {
                                                  return new LocationReport(start_date: '',end_date: '',);
                                                }));
                                          },),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))),
                        flex: 1,
                      )
                    ],
                  )
                ],
              )),
        ),
        resizeToAvoidBottomPadding: true);
  }
}
