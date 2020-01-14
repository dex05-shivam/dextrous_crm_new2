import 'package:dextrous_crm_new2/ui/lead_screen.dart';
import 'package:dextrous_crm_new2/ui/leads_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNewReminder extends StatefulWidget {

  final String text,text2;

  AddNewReminder({Key key, @required this.text, this.text2}) : super(key: key);

  @override
  _AddNewReminderState createState() => new _AddNewReminderState(text: text,text2: text);
}

class _AddNewReminderState extends State<AddNewReminder> {

  final String text,text2;

  _AddNewReminderState({Key key, @required this.text, this.text2}) : super();

  final TextEditingController _description = new TextEditingController();

  String leadStatus;

  String _email = "";
  String _password = "";
  // our default setting is to login, and we should switch to creating an account when the user chooses to


  List dataLeadStatus = List();


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

  Future<String> getLeadStatus() async {

    var res = await http.get(Uri.encodeFull('http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/members_list'));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['members'];

    setState(() {
      dataLeadStatus = resBody1;
    });

    print(resBody);

    return "Sucess";
  }



  ProgressDialog pr;
  bool isResponse = false;
  Future<int> saveLead() async {
    pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/add_reminder";
    FormData formData = new FormData.from({
      "memberId": leadStatus,
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'lead_id': text,
      'date': date1 + " " + time1,
      'description': _description.text.toString(),
    });

    http.Response response = await http.post(login_url, body: formData);

    var body = await json.decode(response.body);
    //Simulate a service call
    print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 4), () {
      setState(() async {
        if (response.statusCode == 200) {
          var body = await json.decode(response.body);
          isResponse = false;
          Fluttertoast.showToast(
              msg: body['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.green[300],
              textColor: Colors.white,
              fontSize: 16.0);
          print(response.body);

          Future.delayed(Duration(seconds: 3)).then((value) {
            pr.hide().whenComplete(() {
              isResponse = false;
              openAlertBox(body['message']);

            });
          });



        } else {
          isResponse = true;
        }
      });
    });

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
    return body['status'];
  }

  String comments = '', time1 = 'Select Time', date1 = 'Select Date';
  @override
  void initState() {
    super.initState();

    getLeadStatus();

  }



  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                body:Container(
                  child:  Padding(
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
                                    Navigator.of(context).pop();

                                    Navigator.of(context).push(
                                        MaterialPageRoute<Null>(builder: (BuildContext context) {
                                          return new LeadDetails(text: text);
                                        }));
                                  }),
                              Flexible(
                                child: Center(
                                  child: Text(
                                    ' New Reminder',
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
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Column(
                                  children: <Widget>[
                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                            child: Text(
                                              'Date',
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
                                              'Time',
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
                                              DatePicker.showTimePicker(context,
                                                  showTitleActions: true, onChanged: (date) {
                                                    print('change $date');
                                                    time1 = date.hour.toString() +
                                                        ':' +
                                                        date.minute.toString();
                                                    setState(() {
                                                      time1 = date.hour.toString() +
                                                          ':' +
                                                          date.minute.toString();
                                                    });
                                                  }, onConfirm: (date) {
                                                    print('confirm $date');
                                                    setState(() {
                                                      time1 = date.hour.toString() +
                                                          ':' +
                                                          date.minute.toString();
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
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                                child: Text(
                                                  'Set reminder to',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),

                                          Padding(
                                              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                              child: DropdownButton<String>(
                                                icon: Icon(Icons.arrow_drop_down_circle),
                                                iconSize: 24,
                                                hint: Text('Select Member'),
                                                isExpanded: true,
                                                underline: null,
                                                style: TextStyle(color: Colors.grey),
                                                items: dataLeadStatus.map((item) {
                                                  return new DropdownMenuItem(
                                                    child: new Text(item['name']),
                                                    value: item['id'].toString(),
                                                  );
                                                }).toList(),
                                                onChanged: (newVal) {
                                                  // Your code to execute, when a menu item is selected from dropdown
                                                  setState(() {
                                                    leadStatus = newVal;
                                                  });
                                                },
                                                value: leadStatus,
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
                                              '*Description',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          new TextField(
                                            controller: _description,
                                            decoration: new InputDecoration(
                                                hintText: 'Enter Description... ',
                                                hintStyle: style1,
                                                labelStyle: style1,
                                                suffixIcon: Icon(
                                                  Icons.comment,
                                                  color: Colors.black,
                                                  size: 20,
                                                )),
                                            maxLines: 5,
                                            autofocus: false,
                                          ),
                                        ],
                                      ),
                                      height: 150,
                                    ),









//                    Visibility(child: showImage(),visible: false,),

                                  ],

                                ),),
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
                                  //_showDialog();

                                  if(!["", null, false, 0].contains(_description.text.toString())){

                                    if(!["", null, false, 0].contains(time1.toString())){

                                      if(!["", null, false, 0].contains(date1)){

                                        if(!["", null, false, 0].contains(leadStatus)){
                                                saveLead();

                                          //saveLead();
                                        }else{

                                          Fluttertoast.showToast(
                                              msg: "please select member",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIos: 1
                                          );

                                        }


                                      }else{

                                        Fluttertoast.showToast(
                                            msg: "please select date",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIos: 1
                                        );

                                      }
                                      //saveLead();
                                    }else{
                                      Fluttertoast.showToast(
                                          msg: "please select time",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 1
                                      );
                                    }
                                    // saveLead();
                                  }else{
                                    Fluttertoast.showToast(
                                        msg: "please enter description",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 1
                                    );
                                  }


                                  //_showDialog();
                                  // No any error in validation
                                  // print("Name $name");
                                  // print("Mobile $_comments");

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


                resizeToAvoidBottomPadding: false)));
  }



  openAlertBox(String leadID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.network(
                    'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/logo_dex.png',
                    height: 20,
                    width: 100,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.check_box,color: Colors.greenAccent,),
                            new Text("New Reminder Created",style: TextStyle(fontSize:20,color: Colors.blueGrey,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic)),
                          ],),

                      ],
                    ),
                  ),


                  InkWell(

                    child: Container(

                      padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1F244C),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: new FlatButton(
                        child: new Text("Close",style: style11,),
                        onPressed: () {
                          Navigator.of(context).pop();

                          Navigator.of(context).push(
                              MaterialPageRoute<Null>(builder: (BuildContext context) {
                                return new LeadDetails(text: text);
                              }));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}