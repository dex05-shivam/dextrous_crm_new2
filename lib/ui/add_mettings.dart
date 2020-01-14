import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/expense_list.dart';
import 'package:dextrous_crm_new2/ui/meeting_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
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

enum FormType { login, register }

class AddMettings extends StatefulWidget {
  @override
  _AddMettingsState createState() => new _AddMettingsState();
}

class _AddMettingsState extends State<AddMettings> {



  String  _myselection2;
  final String url =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/members_list";
  // final format = DateFormat("yyyy-MM-dd HH:mm");
  String comments = '', time1 = 'Select Time', date1 = 'Select Date',_selectedMemberList='',_selectedMemberIdList='';
  List data = List();
  List data1 = List(); //edited line




  final TextEditingController _title = new TextEditingController();
  final TextEditingController _selectedMember = new TextEditingController();
  final TextEditingController _account = new TextEditingController();
  final TextEditingController _description = new TextEditingController();

  String _email = "";
  String _password = "";
  FormType _form = FormType
      .login;

  bool isResponse = false;
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

  String lead_id='';
  @override
  void initState() {
    super.initState();
    getSWData();
    getSWData1();
    getUsers();
    getMembers();


  }






// our default setting is to login, and we should switch to creating an account when the user chooses to





  Future<String> getSWData() async {
    FormData formData = new FormData.from({
      "userId": '40',
      "token": '44a33c06eb2286deef0d2fdddd352690',
    });
    var res = await http.get(Uri.encodeFull(url));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['members'];

    setState(() {
      data = resBody1;
    });

    print(resBody);

    return "Sucess";
  }
  ProgressDialog pr;
  Future<String> getSWData1() async {
    FormData formData = new FormData.from({
      "userId": '40',
      "token": '44a33c06eb2286deef0d2fdddd352690',
    });
    var res = await http.get(Uri.encodeFull(
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/meeting_Type"));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['meeting_type'];

    setState(() {
      data1 = resBody1;
    });

    print(resBody);

    return "Sucess";
  }


  Future<int> getToekn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/add_meeting";
    FormData formData = new FormData.from({
      "lead_id": lead_id,
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'client_location': _account.text.toString(),
      'meeting_type': _myselection2,
      'subject': _title.text.toString(),
      'description': _description.text.toString(),
      'date': date1+' '+time1,
      'member': _selectedMemberIdList,
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


              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new MeetingList(initialDate: DateTime.now(),);
                  }));
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


  List<Members> selectedReportList = List();
  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Select Members"),
            content: MultiSelectChip(
              members,
              onSelectionChanged: (selectedList) {
                setState(() {
                  _selectedMemberList='';
                  _selectedMemberIdList='';
                  for(var i =0; i<selectedList.length;i++){
                    if(_selectedMemberList==''){
                      _selectedMemberList=selectedList[i].name;
                      _selectedMemberIdList=selectedList[i].id;
                    }else{
                      _selectedMemberList=_selectedMemberList+','+selectedList[i].name;
                      _selectedMemberIdList=_selectedMemberIdList+','+selectedList[i].id;
                    }
                  }
                  selectedReportList = selectedList;

                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Save"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }


  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();
  static List<User> users = new List<User>();

  static List<Members> members = new List<Members>();
  bool loading = true;

  void getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/meetingleadList";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.get('user_token'),
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
        setState(() {
          loading = false;
        });
        List<dynamic> dynamicList = decodedMap['result'];
        users = new List<User>();
        dynamicList.forEach((f) {
          User s = User.fromJson(f);
          users.add(s);
        });
        print('Users: '+users.length.toString());
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }


  void getMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/members_list";


    http.Response response = await http.get(login_url);

    print(response.body);

    var body = await json.decode(response.body);
    //Simulate a service call
    print('submitting to backend...');
    Map<String, dynamic> decodedMap = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          loading = false;
        });
        List<dynamic> dynamicList = decodedMap['members'];
        members = new List<Members>();
        dynamicList.forEach((f) {
          Members s = Members.fromJson(f);
          members.add(s);
        });
        print('Users: '+members.length.toString());
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }



  Widget row(User user) {
    return Padding(child: Container(
      height: 30,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            user.name,
            style: style2,
          ),
          SizedBox(
            width: 10.0,
          ),

        ],
      ),
    ),
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),);
  }

  void _onFormSaved() {
    final FormState form = _formKey.currentState;
    form.save();
  }
  Future<bool> _onBackPressed() {
    Navigator.pop(context);
    Navigator.of(context).push(
        MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new MeetingList(initialDate: DateTime.now(),);
        }));

  }
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
        body:ModalProgressHUD(
          inAsyncCall: isResponse,
          child: WillPopScope(
            onWillPop: _onBackPressed,
            child:  Container(
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
                                Navigator.of(context).push(
                                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                                      return new MeetingList(initialDate: DateTime.now(),);
                                    }));
                              }),
                          Flexible(
                            child: Center(
                              child: Text(
                                ' Add Meetings',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            flex: 1,
                          ),
//                          new IconButton(
//                              icon: Icon(
//                                Icons.notifications_active,
//                                color: Colors.black,
//                                size: 20,
//                              ),
//                              onPressed: () {
////                            Provider.of<MenuController>(context, listen: true)
////                                .toggle();
//                              }),
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
                                          '*Meeting Subject',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      new TextField(
                                        controller: _title,
                                        decoration: new InputDecoration(
                                            hintText: 'Enter Subject',
                                            hintStyle: style1,
                                            suffixIcon: Icon(
                                              Icons.chat,
                                              color: Colors.black,
                                              size: 20,
                                            )),
                                        maxLines: 1,
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
                                          '*Members',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                        child:Center(
                                          child: new TextField(
                                            readOnly: true,
                                            onTap: (){
                                              _showReportDialog();
                                            },
                                            decoration: new InputDecoration(
                                                hintText: !["", null, false, 0,''].contains(_selectedMemberList)?_selectedMemberList:'Select Members',
                                                hintStyle: style1,
                                                suffixIcon: Icon(
                                                  Icons.people,
                                                  color: Colors.black,
                                                  size: 20,
                                                )),
                                            maxLines: 1,
                                            autofocus: false,
                                          ),
                                        ) ,



                                      )
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
                                          '*Meeting Type',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                          child: DropdownButton<String>(
                                            icon: Icon(Icons.arrow_drop_down_circle),
                                            iconSize: 24,
                                            hint: Text('Select Type'),
                                            isExpanded: true,
                                            underline: null,
                                            style: TextStyle(color: Colors.grey),
                                            items: data1.map((item) {
                                              return new DropdownMenuItem(
                                                child: new Text(item['value']),
                                                value: item['id'].toString(),
                                              );
                                            }).toList(),
                                            onChanged: (newVal) {
                                              setState(() {
                                                _myselection2 = newVal;
                                              });
                                            },
                                            value: _myselection2,
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
                                          '*Location',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      new TextField(
                                        controller: _account,
                                        decoration: new InputDecoration(
                                            hintText: 'Enter Location',
                                            hintStyle: style1,
                                            suffixIcon: Icon(
                                              Icons.edit_location,
                                              color: Colors.black,
                                              size: 20,
                                            )),
                                        maxLines: 1,
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
                                          '*Lead Name',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      loading
                                          ? CircularProgressIndicator()
                                          : searchTextField = AutoCompleteTextField<User>(
                                        key: key,
                                        clearOnSubmit: false,
                                        suggestions: users,
                                        style: TextStyle(color: Colors.black, fontSize: 13.0),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                                          hintText: "Search Name",
                                          hintStyle: TextStyle(color: Colors.black),
                                        ),
                                        itemFilter: (item, query) {
                                          return item.name
                                              .toLowerCase()
                                              .startsWith(query.toLowerCase());
                                        },
                                        itemSorter: (a, b) {
                                          return a.name.compareTo(b.name);
                                        },
                                        itemSubmitted: (item) {
                                          setState(() {
                                            searchTextField.textField.controller.text = item.name;
                                            lead_id=item.lead_id;
                                          });
                                        },
                                        itemBuilder: (context, item) {
                                          // ui for the autocompelete row
                                          return row(item);
                                        },
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
                                              Icons.description,
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
                                new Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                        child: Text(
                                          '*Date',
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
                                              Icons.date_range,
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
                                          '*Time',
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
                                              Icons.access_time,
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Center(
                                      child: GestureDetector(
                                        onTap: () {

                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          // No any error in validation

                                           print("Name $_myselection2");
                                          // print("Mobile $_comments");




                                          if(!["", null, false, 0].contains(_description.text.toString())){
                                            if(!["", null, false, 0].contains(_title.text.toString()))
                                            {
                                              if(!["", null, false, 0].contains(_account.text.toString()))
                                              {
                                                if(!["", null, false, 0,''].contains(_myselection2))
                                                {

                                                  if(!["", null, false, 0,"Select Date"].contains(date1))
                                                  {
                                                    if(!["", null, false, 0,"Select Time"].contains(time1))
                                                    {


                                                      
                                                        if(!["", null, false, 0].contains(searchTextField.textField.controller.text)){
                                                          pr.show();

                                                          getToekn();
                                                        }else{
                                                          Fluttertoast.showToast(
                                                              msg: "Please enter lead name",
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.CENTER,
                                                              timeInSecForIos: 1
                                                          );

                                                        }


                                                      }else{

                                                        Fluttertoast.showToast(
                                                            msg: "Please Select Meeting Members",
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.CENTER,
                                                            timeInSecForIos: 1
                                                        );

                                                      }



                                                    }else{

                                                      Fluttertoast.showToast(
                                                          msg: "Please Select Time",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.CENTER,
                                                          timeInSecForIos: 1
                                                      );

                                                    }

                                                    //getToekn();

                                                  }else{
                                                    Fluttertoast.showToast(
                                                        msg: "Please Select Date",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIos: 1
                                                    );


                                                  }



                                                }else{

                                                  Fluttertoast.showToast(
                                                      msg: "Please Select Meeting Type",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIos: 1
                                                  );


                                                }

                                                //getToekn();

                                              }else{

                                                Fluttertoast.showToast(
                                                    msg: "Please Enter Location",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    timeInSecForIos: 1
                                                );

                                              }


                                            }else{

                                              Fluttertoast.showToast(
                                                  msg: "Please Enter Subject",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIos: 1
                                              );

                                            }

                                          }else{


                                            Fluttertoast.showToast(
                                                msg: "Please Enter Description",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIos: 1
                                            );


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
          ),
        ),

        resizeToAvoidBottomPadding: false);
  }
}
class User {
  String lead_id;
  String name;


  User({this.lead_id, this.name});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      lead_id: parsedJson["lead_id"],
      name: parsedJson["name"] as String,
    );
  }
}

class Members {
  String id;
  String name;


  Members({this.id, this.name});

  factory Members.fromJson(Map<String, dynamic> parsedJson) {
    return Members(
      id: parsedJson["id"],
      name: parsedJson["name"] as String,
    );
  }
}



class MultiSelectChip extends StatefulWidget {
  final List<Members> reportList;
  final Function(List<Members>) onSelectionChanged;

  MultiSelectChip(this.reportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<Members> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.name),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}