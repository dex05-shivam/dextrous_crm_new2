import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dextrous_crm_new2/ui/attandence_report.dart';
import 'package:dextrous_crm_new2/ui/location_report.dart';
import 'package:dextrous_crm_new2/ui/report_lead.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'clients_report.dart';
import 'expense_list.dart';
import 'home_screen.dart';
import 'login_page.dart';

class FilterReport extends StatefulWidget {

  final String start_date,end_date,type;

  FilterReport({Key key, @required this.start_date, this.end_date,this.type}) : super(key: key);

  @override
  _FilterReportState createState() => new _FilterReportState(start_date: start_date,end_date: end_date,type: type);
}

class _FilterReportState extends State<FilterReport> {


   String start_date="",end_date="",type="",date1='Select Date',time1='Select Time';


  _FilterReportState({Key key, @required this.start_date, this.end_date,this.type}) : super();



   TextStyle style1 = TextStyle(
       fontFamily: 'Montserrat',
       fontSize: 12.0,
       fontStyle: FontStyle.normal,
       color: Colors.grey);
   TextStyle style11 = TextStyle(
       fontFamily: 'Montserrat',
       fontSize: 12.0,
       fontWeight: FontWeight.w700,
       color: Colors.black);
   TextStyle style2 = TextStyle(
     fontFamily: 'Montserrat',
     fontSize: 12.0,
     fontStyle: FontStyle.normal,
     color: Color(0xff0D314D),
     decoration: TextDecoration.underline,
   );
   TextStyle style3 = TextStyle(
       fontFamily: 'Montserrat',
       fontSize: 12.0,
       fontStyle: FontStyle.normal,
       color: Color(0xff0D314D),
       decoration: TextDecoration.underline,
       fontWeight: FontWeight.bold);


   @override
  void initState() {
    super.initState();

  }





  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(child:  Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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

                          if(type=="lead") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReportLead(
                                        start_date: start_date, end_date: '',
                                      ),
                                ));
                          }


                          if(type=="location") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LocationReport(
                                        start_date: start_date, end_date: '',
                                      ),
                                ));
                          }

                          if(type=="attand") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AttendanceReport(
                                        start_date: start_date, end_date: '',
                                      ),
                                ));
                          }

                          if(type=="client") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ClientReport(
                                        start_date: start_date, end_date: '',
                                      ),
                                ));
                          }
                        }),
                    Flexible(
                      child: Center(
                        child: Text(
                          'Filter',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      flex: 1,
                    ),

                  ],
                ),
              ),
              Flexible(
                child:Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                    child: new Container(
                      child: ListView(
                        children: <Widget>[
                          new Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                  child: Text(
                                    'Start Date',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                new TextField(
                                  decoration: new InputDecoration(
                                      hintText: date1,
                                      hintStyle: style1,
                                      suffixIcon: Icon(
                                        Icons.person_outline,
                                        color: Colors.black,
                                        size: 20,
                                      )),
                                  expands: false,
                                  showCursor: false,
                                  readOnly: true,
                                  maxLines: 1,
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true, onChanged: (date) {
                                          date1 = date.toString();
                                          setState(() {
                                            date1 = date.year.toString() +
                                                '-' +
                                                date.month.toString() +
                                                '-' +
                                                date.day.toString();
                                            start_date = date.year.toString() +
                                                '-' +
                                                date.month.toString() +
                                                '-' +
                                                date.day.toString();
                                          });
                                          print('change $date');
                                        }, onConfirm: (date) {
                                          print('confirm $date');

                                          setState(() {
                                            start_date = date.year.toString() +
                                                '-' +
                                                date.month.toString() +
                                                '-' +
                                                date.day.toString();
                                            date1 = date.year.toString() +
                                                '-' +
                                                date.month.toString() +
                                                '-' +
                                                date.day.toString();
                                          });
                                        },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  },
                                  autofocus: false,
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                  child: Text(
                                    'End Date',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                new TextField(
                                  decoration: new InputDecoration(
                                      hintText: time1,
                                      hintStyle: style1,
                                      suffixIcon: Icon(
                                        Icons.person_outline,
                                        color: Colors.black,
                                        size: 20,
                                      )),
                                  expands: false,
                                  showCursor: false,
                                  readOnly: true,
                                  maxLines: 1,
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true, onChanged: (date) {
                                          print('change $date');
                                          end_date = date.year.toString() +
                                              '-' +
                                              date.month.toString()+'-' +
                                              date.day.toString();
                                          setState(() {
                                            end_date = date.year.toString() +
                                                '-' +
                                                date.month.toString()+'-' +
                                                date.day.toString();
                                            time1 = date.year.toString() +
                                                '-' +
                                                date.month.toString()+'-' +
                                                date.day.toString();
                                          });
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          setState(() {
                                            end_date=date.year.toString() +
                                                '-' +
                                                date.month.toString()+'-' +
                                                date.day.toString();
                                            time1 = date.year.toString() +
                                                '-' +
                                                date.month.toString()+'-' +
                                                date.day.toString();
                                          });
                                        },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  },
                                  autofocus: false,
                                ),
                              ],
                            ),
                          ),

//                    Visibility(child: showImage(),visible: false,),

                        ],
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
//                        image: DecorationImage(
//                          image: AssetImage("assets/images/card_background.png"),
//                          fit: BoxFit.fill,
//
//                        ),
                          color: Colors.white
                      ),)),),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if(type=="lead"){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportLead(start_date: !["", null, false, 0,"Select Date"].contains(start_date)?start_date:"",end_date:!["", null, false, 0,"Select Time"].contains(end_date)?end_date: "",

                                ),
                              ));
                        }

                        if(type=="location"){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationReport(start_date: !["", null, false, 0,"Select Date"].contains(start_date)?start_date:"",end_date:!["", null, false, 0,"Select Time"].contains(end_date)?end_date: "",

                          ),
                              ));
                        }
                        if(type=="attand") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AttendanceReport(start_date: !["", null, false, 0,"Select Date"].contains(start_date)?start_date:"",end_date:!["", null, false, 0,"Select Time"].contains(end_date)?end_date: "",

                                    ),
                              ));
                        }

                        if(type=="client") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ClientReport(start_date: !["", null, false, 0,"Select Date"].contains(start_date)?start_date:"",end_date:!["", null, false, 0,"Select Time"].contains(end_date)?end_date: "",

                                    ),
                              ));
                        }

                      },
                      child: Card(
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius: new BorderRadius.circular(40),
                          ),
                          height: 40.0, // height of the button
                          width: 120.0, // width of the button
                          child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            image: DecorationImage(
              image: AssetImage("assets/images/login_back.png"),
              fit: BoxFit.fill,

            ),
          ),
        ),

        resizeToAvoidBottomPadding: false);
  }
}
class Status {
  int id;
  String name;

  Status(this.id, this.name);

  static List<Status> getCompanies() {
    return <Status>[
      Status(0, 'Pending'),
      Status(1, 'Approved'),

    ];
  }
}