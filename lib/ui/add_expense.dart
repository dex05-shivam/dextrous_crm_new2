import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dextrous_crm_new2/ui/expense_list.dart';
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

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => new _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  bool isResponse = false;


  @override
  void initState() {
    super.initState();
    getSWData();
    getSWData1();
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

  File _imageFile;
  String base64 = '', fileName = 'Browse File';

  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      setState(() {
        _imageFile = imageFile;
        base64 = base64Encode(imageFile.readAsBytesSync());
        fileName = imageFile.path.split('/').last;
        print(fileName + '------' + base64);
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return Image.file(_imageFile);
    } else {
      return Text('Take an image to start', style: TextStyle(fontSize: 18.0));
    }
  }

  String _mySelection, _myselection2,_mySelection11='',_mySelection22='';
  final String url =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/expense/Exp_category";
  // final format = DateFormat("yyyy-MM-dd HH:mm");
  String comments = '', time1 = 'Select Time', date1 = 'Select Date';
  List data = List();
  List data1 = List(); //edited line



  final TextEditingController _title = new TextEditingController();
  final TextEditingController _account = new TextEditingController();
  final TextEditingController _description = new TextEditingController();

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

  Future<String> getSWData() async {
    FormData formData = new FormData.from({
      "userId": '40',
      "token": '44a33c06eb2286deef0d2fdddd352690',
    });
    var res = await http.get(Uri.encodeFull(url));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['exp_cat_list'];

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
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/expense/Exp_type"));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['exp_type_list'];

    setState(() {
      data1 = resBody1;
    });

    print(resBody);

    return "Sucess";
  }

  Future<int> getToekn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/expense/addEdit_exp";
    FormData formData = new FormData.from({
      "expId": '',
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'amount': _account.text.toString(),
      'category': _mySelection,
      'expense_name': _title.text.toString(),
      'expense_type': _myselection2,
      'desc': _description.text.toString(),
      'date': date1,
      'time': time1,
      'expfile': base64,
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
                    return new ExpenseLis(status: '2',e_date: '',s_date: '',);
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

  Widget _formRegistration(BuildContext context) {
    return SingleChildScrollView(
      child: new Column(
        children: <Widget>[],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
        body:ModalProgressHUD(
          inAsyncCall: isResponse,
        child: Container(child:  Padding(
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
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            SystemNavigator.pop();
                          }
                        }),
                    Flexible(
                      child: Center(
                        child: Text(
                          ' Add Expense',
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
                      child:SingleChildScrollView(

                        child:  Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                      '*Title',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  new TextField(
                                    controller: _title,
                                    decoration: new InputDecoration(
                                        hintText: '*Enter Title',
                                        hintStyle: style1,
                                        suffixIcon: Icon(
                                          Icons.title,
                                          color: Colors.grey,
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
                                      '*Select Category',
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
                                        hint: Text('Select Category'),
                                        isExpanded: true,
                                        underline: null,
                                        style: TextStyle(color: Colors.grey),
                                        items: data.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['exp_cat_name']),
                                            value: item['exp_cat_id'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            _mySelection = newVal;
                                            _mySelection11=newVal;
                                          });
                                        },
                                        value: _mySelection,
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
                                      '*Select Type',
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
                                            child: new Text(item['exp_type_name']),
                                            value: item['exp_type_id'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            _myselection2 = newVal;
                                            _mySelection22=newVal;
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
                                      '*Amount',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  new TextField(
                                    controller: _account,
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        hintText: 'Enter amount ',
                                        hintStyle: style1,

                                        suffixIcon: Icon(
                                          Icons.attach_money,
                                          color: Colors.grey,
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
                                          color: Colors.grey,
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
                                          color: Colors.grey,
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
                                          color: Colors.grey,
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
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                    child: Text(
                                      'Select File',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Stack(
                                    children: <Widget>[
                                      new TextField(
                                        decoration: new InputDecoration(
                                            labelText: fileName,
                                            hintStyle: style1,
                                            suffixIcon: Image.network(
                                              'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/browse.png',
                                              height: 20,
                                              width: 100,
                                            )),
                                        expands: false,
                                        showCursor: false,
                                        readOnly: true,
                                        maxLines: 1,
                                        onTap: () {
                                          captureImage(ImageSource.camera);
                                        },
                                        autofocus: false,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
//                    Visibility(child: showImage(),visible: false,),

                          ],

                        ),),
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
                        if(!["", null, false, 0].contains(_description.text.toString())){
                          if(!["", null, false, 0].contains(_title.text.toString()))
                          {
                            if(!["", null, false, 0].contains(_account.text.toString()))
                            {
                              if(!["", null, false, 0,''].contains(_mySelection11))
                              {

                                if(!["", null, false, 0,"Select Date"].contains(date1))
                                {
                                  if(!["", null, false, 0,"Select Time"].contains(time1))
                                  {


                                    if(!["", null, false, 0].contains(_mySelection22))
                                    {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());


                                        pr.show();

                                        getToekn();



                                    }else{

                                      Fluttertoast.showToast(
                                          msg: "Please Select Type",
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
                                    msg: "Please Select Category",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIos: 1
                                );


                              }

                              //getToekn();

                            }else{

                              Fluttertoast.showToast(
                                  msg: "Please Enter Amount",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1
                              );

                            }


                          }else{

                            Fluttertoast.showToast(
                                msg: "Please Enter Title",
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

        resizeToAvoidBottomPadding: false);
  }
}
