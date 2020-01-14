import 'dart:async';
import 'dart:convert';


import 'package:dextrous_crm_new2/ui/home_screen.dart';
import 'package:dextrous_crm_new2/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'conts/config.dart';
//import 'package:shared_preferences/shared_preferences.dart';

//void main() => runApp(MyApp());
Future main() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //var email = prefs.getString('email');
  // print("hello "+email);
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{

      '/Login': (BuildContext context) =>LoginScreen(),
      '/Home': (BuildContext context) =>MyHomePage()
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);


    int status = await getToekn();





    return  status==1 ? new Timer(_duration, navigationPage) : null;
  }

  Future<int> getToekn() async{
    String token_url= APPURLS.MAIN_URL+"auth/system_token";
    http.Response response= await http.get(token_url);

    var body= await json.decode(response.body);

    print(response.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('main_token',body['token'] );
    print(body['token']);
    return body['status'];
  }



  DateTime currentBackPressTime;
  Future<bool> _onBackPressed() {

    return Future.value(true);

  }
  Future navigationPage() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!["", null, false, 0].contains(prefs.getString('userId'))) {
      // do sth
//      Navigator.of(context).push(MaterialPageRoute<Null>(
//          builder: (BuildContext context) {
//            return new HomePage();
//          }));
    print(prefs.getString('userId'));
    Navigator.of(context).pushReplacementNamed('/Home');

    }else{
      Navigator.of(context).pushReplacementNamed('/Login');

      print(prefs.getString('userId'));
    }


  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:Container(
      child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/splashscreen.jpg',

        fit: BoxFit.fitWidth,

      ),
    ))

}





