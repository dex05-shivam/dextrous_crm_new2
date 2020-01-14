import 'dart:async';
import 'dart:convert';

import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/home_screen.dart';
import 'package:dextrous_crm_new2/ui/lead_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';


enum FormType { login, register }

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => new _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isResponse = false;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String email;

  ProgressDialog pr;

  final TextEditingController _oldPassword = new TextEditingController();
  final TextEditingController _newPassword = new TextEditingController();
  final TextEditingController _confirmPassword = new TextEditingController();
  @override
  void initState() {
    super.initState();
    // getToekn();
  }

  Future<int> getToekn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url = "http://ems.dextrousinfosolutions.com/dexcrm/api/auth/changePwd";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "oldPwd": _oldPassword.text.toString(),
      "newPwd": _newPassword.text.toString(),
    });

    http.Response response = await http.post(login_url, body: formData);

    var body = await json.decode(response.body);

    setState(() {
      isResponse = true;
    });

    //Simulate a service call
    print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 4), () {
      setState(() {
        if (response.statusCode == 200) {
          isResponse = false;
          Fluttertoast.showToast(
              msg: body['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.green[300],
              textColor: Colors.white,
              fontSize: 16.0);
          Future.delayed(Duration(seconds: 3)).then((value) {
            pr.hide().whenComplete(() {
              isResponse = false;

              Navigator.of(context).pop(true);


              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(
                    ),
                  ));
            });
          });
        } else {
          isResponse = true;
        }
      });
    });

    print(response.body);

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
    return body['status'];
  }

  String _email = "";
  String _password = "";
  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  TextStyle style1 = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 12.0,
      fontStyle: FontStyle.normal,
      color: Colors.black);
  TextStyle style2 = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: Color(0xff0D314D),
    decoration: TextDecoration.underline,
  );
  TextStyle style3 = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 15.0,
      fontStyle: FontStyle.normal,
      color: Color(0xff0D314D),
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.bold);

  Widget _formLogin(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _oldPassword,
              decoration: new InputDecoration(
                labelText: 'Old password',
                hintStyle: style1,
                labelStyle: style1,
              ),
              style: style1,
              maxLines: 1,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _newPassword,
              obscureText:true,
              decoration: new InputDecoration(
                labelText: 'New Password',
                hintStyle: style1,
                labelStyle: style1,
              ),
              style: style1,
              maxLines: 1,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _confirmPassword,
              decoration: new InputDecoration(
                labelText: 'Confirm Password',
                hintStyle: style1,
                labelStyle: style1,
              ),
              style: style1,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }


  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Want to leave?'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(
                          ),
                        ));
                  } else {
                    SystemNavigator.pop();
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
        body: ModalProgressHUD(
          child:WillPopScope(onWillPop:_onBackPressed ,
          child:  new Container(
              child: new Stack(
                children: <Widget>[
                  new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/login_back.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                        builder: (context) => MyHomePage(

                                        ),
                                      ));


                                }),
                            Flexible(
                              child: Center(
                                child: Text(
                                  'Change Password',
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: new Card(
                          child: Stack(
                            children: <Widget>[
                              Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/card_background.png',
                                fit: BoxFit.fill,
                                width: 450,
                                height: 400,
                              ),
                              ListView(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 30.0, 0.0),
                                    child: Align(
                                      child: new Text(
                                        'Change',
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 25,
                                        ),
                                        textAlign: TextAlign.left,
                                        textDirection: TextDirection.ltr,
                                      ),
                                      alignment: Alignment.topLeft,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0, 30.0, 0.0),
                                    child: Align(
                                      child: new Text(
                                        'Password?',
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                        textDirection: TextDirection.ltr,
                                      ),
                                      alignment: Alignment.topLeft,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 0.0),
                                    child: Align(child: _formLogin(context)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            // No any error in validation

                                            // print("Name $name");
                                            // print("Mobile $_comments");
                                            pr.show();
                                            if(!["", null, false, 0].contains(_oldPassword.text.toString())){
                                              if(!["", null, false, 0].contains(_confirmPassword.text.toString())){

                                                if(!["", null, false, 0].contains(_newPassword.text.toString())){

                                                  if(_confirmPassword.text.toString()==_newPassword.text.toString()){
                                                    getToekn();
                                                  }else{
                                                    Fluttertoast.showToast(
                                                        msg: "password miss matched",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIos: 1
                                                    );

                                                  }

                                                }else{
                                                  Fluttertoast.showToast(
                                                      msg: "please enter new password",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIos: 1
                                                  );

                                                }


                                              }else{
                                                Fluttertoast.showToast(
                                                    msg: "please enter confirm password",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    timeInSecForIos: 1
                                                );

                                              }

                                            }else{
                                              Fluttertoast.showToast(
                                                  msg: "please enter old password",
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
                                                borderRadius:
                                                new BorderRadius.circular(40),
                                              ),
                                              height: 40.0, // height of the button
                                              width: 120.0, // width of the button
                                              child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                shrinkWrap: true,
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              )),),
          inAsyncCall: isResponse,
        ),
        resizeToAvoidBottomPadding: false);
  }
}
