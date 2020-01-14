import 'dart:async';
import 'dart:convert';

import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
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

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => new _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  var _formKey = GlobalKey<FormState>();
  bool isResponse = false;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String email;

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    // getToekn();
  }

  Future<int> getToekn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url = APPURLS.MAIN_URL + "auth/forgot_password";
    FormData formData = new FormData.from({
      "emailId": _email1.text,
      "token": prefs.getString('main_token'),
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

              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return new LoginScreen();
              }));
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

  final TextEditingController _email1 = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
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
            child: Form(
              key: _formKey,
              child: new TextFormField(
                controller: _email1,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter Email';
                  }
                },
                decoration: new InputDecoration(
                  labelText: 'Email',
                  hintStyle: style1,
                  labelStyle: style1,
                ),
                style: style1,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
        body: ModalProgressHUD(
            child: new Container(
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
                          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                          child: new Image.network(
                            'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/logo_dex.png',
                            height: 75,
                            width: 150,
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
                                          'Forgot',
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
                                              if (_formKey.currentState.validate()) {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                pr.show();
                                                getToekn();

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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                                  return new LoginScreen();
                                }));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                ),
                                new Text(
                                  'Back to login',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline),
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            inAsyncCall: isResponse,
          ),

        resizeToAvoidBottomPadding: false);
  }
}
