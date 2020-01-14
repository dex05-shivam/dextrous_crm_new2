import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'expense_list.dart';
import 'home_screen.dart';
import 'login_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:splashscreen/splashscreen.dart';
//import 'package:progress_dialog/progress_dialog.dart';

//import 'home_page.dart';
////import 'login_page.dart';
//void main() => runApp(MainScreen());
//Future main() async {
// // SharedPreferences prefs = await SharedPreferences.getInstance();
//  //var email = prefs.getString('email');
//  // print("hello "+email);
//  runApp(new MaterialApp(
//    home: new SplashScreen(),
//    routes: <String, WidgetBuilder>{
//
//      '/MyApp1': (BuildContext context) =>  SplashScreen()
//    },
//  ));
//}

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => new _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_companies);

    _selectedCompany = _dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<Status>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Status>> items = List();
    for (Status company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Status selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }
//  File _image;
//
//  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//
//    setState(() {
//      _image = image;
//    });
//  }

  List<Status> _companies = Status.getCompanies();
  List<DropdownMenuItem<Status>> _dropdownMenuItems;
  Status _selectedCompany;


  String comments = '', time1 = 'Select Time', date1 = 'Select Date';
  List data = List();
  List data1 = List(); //edited line



  bool isResponse = false;
  String _email = "";
  String _password = "";
  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExpenseLis(
                                  status: _selectedCompany.id.toString(),
                                  e_date: !["", null, false, 0,"Select Date"].contains(date1)?date1:"",
                                  s_date: !["", null, false, 0,"Select Time"].contains(time1)?time1:"",
                                ),
                              ));
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
                    new IconButton(
                        icon: Icon(
                          Icons.notifications_active,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () {
//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                        }),
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
                                    'Select Type',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                    child: DropdownButton<Status>(
                                      icon: Icon(Icons.arrow_drop_down_circle),
                                      iconSize: 24,
                                      hint: Text('Select Category'),
                                      isExpanded: true,
                                      underline: null,
                                      style: TextStyle(color: Colors.grey),
                                      items: _dropdownMenuItems,
                                      onChanged: onChangeDropdownItem,
                                      value: _selectedCompany,
                                    ))
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
                                          });
                                          print('change $date');
                                        }, onConfirm: (date) {
                                          print('confirm $date');

                                          setState(() {
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
                                          time1 = date.year.toString() +
                                              '-' +
                                              date.month.toString()+'-' +
                                              date.day.toString();
                                          setState(() {
                                            time1 = date.year.toString() +
                                                '-' +
                                                date.month.toString()+'-' +
                                                date.day.toString();
                                          });
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          setState(() {
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
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return new ExpenseLis(status: _selectedCompany.id.toString(),  e_date: !["", null, false, 0,"Select Date"].contains(date1)?date1:"",
                                s_date: !["", null, false, 0,"Select Time"].contains(time1)?time1:"",);
                            }));

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
      Status(2, 'All'),
      Status(0, 'Pending'),
      Status(1, 'Approved'),

    ];
  }
}