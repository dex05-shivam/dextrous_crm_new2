import 'dart:async';

import 'package:flutter/material.dart';

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

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => new _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
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
    fontStyle: FontStyle.normal,
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
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'Email'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _formRegistration(BuildContext context) {
    return SingleChildScrollView(
        child: new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                labelText: 'Vendor Name',
                hintStyle: style1,
                labelStyle: style1,
              ),
              style: style1,
              maxLines: 1,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                labelText: 'Name',
                hintStyle: style1,
                labelStyle: style1,
              ),
              style: style1,
              maxLines: 1,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                labelText: 'Email',
                labelStyle: style1,
                hintStyle: style1,
              ),
              style: style1,
              maxLines: 1,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(
                labelText: 'Password',
                hintStyle: style1,
                labelStyle: style1,
              ),
              obscureText: true,
              style: style1,
              maxLines: 1,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _emailFilter,
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
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: new Container(
            child: new Stack(
          children: <Widget>[
            new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/login_back.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            ListView(
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
                  child:  new Container(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              20.0, 10.0, 30.0, 0.0),
                          child: Align(
                            child: new Text(
                              'Register Your',
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
                          child: Align(child: _formRegistration(context)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return new LoginScreen();
                                          }));
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
                                              'Sign Up',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 15,
                                              color: Colors.white,
                                            )
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
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: AssetImage("assets/images/card_background.png"),
                        fit: BoxFit.fill,

                      ),
                    ),

                  )
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
                          'Already have an account?',
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                        ),
                        new Text(
                          'Login Now',
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
        resizeToAvoidBottomPadding: false);
  }
}
