import 'dart:async';
import 'dart:convert';
import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'forgot_password.dart';
import 'home_screen.dart';
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String name, email, mobile;
  bool isResponse= false;



  Future<int> getToekn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body;
    setState(() {
      isResponse = true;
    });

    new Future.delayed(new Duration(seconds: 4), () async {

      String login_url = APPURLS.MAIN_URL + "auth/login";
      FormData formData = new FormData.from({
        "emailId": _emailFilter.text,
        "password": _passwordFilter.text,
        "token": prefs.getString('main_token'),
      });

      http.Response response = await http.post(login_url, body: formData);



      var body = await json.decode(response.body);
      //Simulate a service call
      print('submitting to backend...');
      if(response.statusCode==200){
        body = await json.decode(response.body);

        print(response.body);
        prefs.setString('user_token',body['user_token'] );
        prefs.setString('userId',body['userId'] );
        prefs.setString('name',body['name'] );
        prefs.setString('email',body['email'] );
        prefs.setString('profile',body['profile'] );
        prefs.setString('total_tasks',body['total_tasks'] );
        prefs.setString('performance',body['performance'] );
        prefs.setString('finished_total_tasks',body['finished_total_tasks'] );
        prefs.setString('total_leads',body['total_leads'] );
        prefs.setString('finished_total_leads',body['finished_total_leads'] );
        prefs.setString('phone',body['phone'] );

        setState(() {
          isResponse = true;
          body['status'] == 1 ? isResponse = true : isResponse = false;
          Fluttertoast.showToast(
              msg: body['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.green[300],
              textColor: Colors.white,
              fontSize: 16.0
          );
        });



        body['status']==1 ?
        Navigator.of(context).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new MyHomePage();
            })) : null;
      }else{
        isResponse=true;
      }
    });






//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
    return body['status'];
  }



  final TextEditingController _emailFilter = new TextEditingController();
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

  String validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if(!regExp.hasMatch(value)){
      return "Invalid Email";
    }else {
      return null;
    }
  }
  DateTime currentBackPressTime;
  Future<bool> _onBackPressed() {

    return Future.value(true);

  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    } else {
      return null;
    }
  }

  Widget _formLogin(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextFormField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                labelText: 'Email',
                hintStyle: style1,
                labelStyle: style1,
              ),
              style: style1,
              maxLines: 1,
              validator: validateEmail,
              onSaved: (String val) {
                _email = val;
              },
            ),
          ),
          new Container(
            child: new TextFormField(
              controller: _passwordFilter,
              decoration: new InputDecoration(
                labelText: 'Password',
                hintStyle: style1,
                labelStyle: style1,
              ),
              obscureText: true,
              style: style1,
              maxLines: 1,
              validator: validatePassword,
              onSaved: (String val) {
                _password = val;
              },
            ),
          ),
        ],
      ),
    );
  }

//

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body:WillPopScope(
          onWillPop: _onBackPressed,
          child: ModalProgressHUD(child: new Container(
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
                        child: new Container(
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 30.0, 0.0),
                                child: Align(
                                  child: new Text(
                                    'Login to your',
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
                                padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 30.0, 0.0),
                                child: Align(
                                  child: new Text(
                                    'Account',
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
                                child: Align(child: new Form(
                                  key: _key,
                                  autovalidate: _validate,
                                  child: _formLogin(context),
                                ),),
                              ),
                              new Align(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ForgotScreen()),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0.0, 10, 20, 0),
                                    child: new Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                                alignment: Alignment.bottomRight,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        if (_key.currentState.validate()) {
                                          // No any error in validation
                                          _key.currentState.save();
                                          // print("Name $name");
                                          print("Mobile $_password");
                                          print("Email $_email");

                                          getToekn();

                                        } else {
                                          // validation error
                                          setState(() {
                                            _validate = true;
                                            isResponse=false;
                                          });

                                        }
                                      },
                                      child: Padding( padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                                                    'Login',
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
                                      ),),
                                    )),
                              ),
//                              new Align(
//                                child: GestureDetector(
//                                  onTap: () {
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(builder: (context) => ForgotPasswordApp()),
////                );
//                                  },
//                                  child: Padding(
//                                    padding:
//                                    const EdgeInsets.fromLTRB(0.0, 30, 0, 0),
//                                    child: new Text(
//                                      "Or login using social media",
//                                      style: TextStyle(
//                                          fontWeight: FontWeight.w700,
//                                          fontSize: 13),
//                                    ),
//                                  ),
//                                ),
//                                alignment: Alignment.center,
//                              ),
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  Padding(
//                                    padding:
//                                    const EdgeInsets.fromLTRB(0, 20, 0, 20),
//                                    child: Center(
//                                        child: GestureDetector(
//                                          onTap: () {},
//                                          child: Card(
//                                            child: Container(
//                                              decoration: new BoxDecoration(
//                                                color: Colors.white,
//                                                borderRadius:
//                                                new BorderRadius.circular(0),
//                                              ),
//                                              height: 40.0, // height of the button
//                                              width: 40.0, // width of the button
//                                              child: Center(
//                                                  child: Row(
//                                                    mainAxisAlignment:
//                                                    MainAxisAlignment.center,
//                                                    children: <Widget>[
//                                                      new Image.asset(
//                                                        'assets/images/fb.png',
//                                                        height: 20,
//                                                        width: 20,
//                                                      ),
//                                                    ],
//                                                  )),
//                                            ),
//                                            elevation: 5,
//                                            shape: RoundedRectangleBorder(
//                                              borderRadius:
//                                              BorderRadius.circular(0.0),
//                                            ),
//                                          ),
//                                        )),
//                                  ),
//                                  Padding(
//                                    padding:
//                                    const EdgeInsets.fromLTRB(20, 20, 0, 20),
//                                    child: Center(
//                                        child: GestureDetector(
//                                          onTap: () {},
//                                          child: Card(
//                                            child: Container(
//                                              decoration: new BoxDecoration(
//                                                color: Colors.white,
//                                                borderRadius:
//                                                new BorderRadius.circular(0),
//                                              ),
//                                              height: 40.0, // height of the button
//                                              width: 40.0, // width of the button
//                                              child: Center(
//                                                  child: Row(
//                                                    mainAxisAlignment:
//                                                    MainAxisAlignment.center,
//                                                    children: <Widget>[
//                                                      new Image.asset(
//                                                        'assets/images/gmail.png',
//                                                        height: 20,
//                                                        width: 20,
//                                                      ),
//                                                    ],
//                                                  )),
//                                            ),
//                                            elevation: 5,
//                                            shape: RoundedRectangleBorder(
//                                              borderRadius:
//                                              BorderRadius.circular(0.0),
//                                            ),
//                                          ),
//                                        )),
//                                  ),
//                                ],
//                              ),
                            ],
                            shrinkWrap: true,
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              image: AssetImage("assets/images/card_background.png"),
                              fit: BoxFit.fill,

                            ),
                          ),

                        ),
                      ),
//                      GestureDetector(
//                        onTap: () {
//                          Navigator.of(context).push(MaterialPageRoute<Null>(
//                              builder: (BuildContext context) {
//                                return new RegisterScreen();
//                              }));
//                        },
//                        child: Padding(
//                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              new Text(
//                                "Don't have an account?",
//                                style: TextStyle(
//                                    color: Colors.grey[800],
//                                    fontSize: 12,
//                                    fontWeight: FontWeight.w700),
//                                textAlign: TextAlign.left,
//                                textDirection: TextDirection.ltr,
//                              ),
//                              new Text(
//                                'Register Now',
//                                style: TextStyle(
//                                    color: Colors.grey[800],
//                                    fontSize: 15,
//                                    fontWeight: FontWeight.w700,
//                                    decoration: TextDecoration.underline),
//                                textAlign: TextAlign.left,
//                                textDirection: TextDirection.ltr,
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
                    ],
                  ),
                ],
              )),inAsyncCall: isResponse,),),
        resizeToAvoidBottomPadding: false);
  }
}