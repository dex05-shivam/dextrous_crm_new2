
import 'dart:async';

import 'package:battery/battery.dart';
import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/drawer_ui/zoom_scaffold.dart';
import 'package:dextrous_crm_new2/ui/expense_list.dart';
import 'package:dextrous_crm_new2/ui/feedbackPage.dart';
import 'package:dextrous_crm_new2/ui/lead_screen.dart';
import 'package:dextrous_crm_new2/ui/login_page.dart';
import 'package:dextrous_crm_new2/ui/meeting_list.dart';
import 'package:dextrous_crm_new2/ui/profile_page.dart';
import 'package:dextrous_crm_new2/ui/report_dash.dart';
import 'package:dextrous_crm_new2/ui/report_lead.dart';
import 'package:dextrous_crm_new2/ui/route_planner.dart';
import 'package:dextrous_crm_new2/ui/settings.dart';
import 'package:dextrous_crm_new2/ui/task_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'circular_image.dart';

class MenuScreenState extends StatefulWidget {



  @override
  MenuScreen createState() => new MenuScreen();
}


class MenuScreen extends  State<MenuScreenState> {
  String imageUrl ='',punchinStatus='',punchinID='',punchInImage='';
  DateTime currentBackPressTime;

  final Battery _battery = Battery();

  BatteryState _batteryState;
  int _batteryLevel;

  String lat = '',
      long = '',
      battery1 = '',
      total_leads = '',
      finished_total_leads = '',
      total_tasks = '',
      finished_total_tasks = '',
      performance = '';

  void getDashBoardData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = new DateTime.now();

    var geolocator = Geolocator();
    var locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
          ', ' +
          position.longitude.toString());
    });
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/dashboard/dashboard";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
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
        var body = await json.decode(response.body);
        punchinStatus = body['punchinStatus'];
        punchinID = body['punchinID'];



        // status=body['status'];

      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }
  bool isResponse = false;

  void doPunchIn() async {

    //email=prefs.getString('email');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/punch_in";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "punchInlocation": long + ","+lat,
      "batteryPunchin": _batteryLevel.toString(),
    });

    http.Response response = await http.post(login_url, body: formData);

    print(response.body);

    var body = await json.decode(response.body);
    //Simulate a service call
    print('submitting to backend...');
    Map<String, dynamic> decodedMap = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        var body = await json.decode(response.body);
        print(response.body);
        Fluttertoast.showToast(
            msg: body['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.green[300],
            textColor: Colors.white,
            fontSize: 16.0
        );

        punchinID=body['punchId'];
        if(body['status']==1){
          setState(() {
            punchinStatus='1';
            punchInImage='assets/images/switch_on.png';
          });

        }



        // status=body['status'];

      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  void doPunchout() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();



    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/punch_out";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "Punchoutlocation": long + ","+lat,
      "batteryPunchout": _batteryLevel.toString(),
      'punchId':punchinID
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
        var body = await json.decode(response.body);
        print(response.body);
        Fluttertoast.showToast(
            msg: body['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.green[300],
            textColor: Colors.white,
            fontSize: 16.0
        );

        if(body['status']==1){
          setState(() {
            punchinStatus='0';
            punchInImage='assets/images/switch_off.png';
          });

        }



        // status=body['status'];

      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  final List<MenuItem> options = [
    MenuItem(Image.network(
      'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/home.png',height: 20,width: 20,), 'Home'),
    MenuItem(Image.network(
      'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/menu_meeting.png',height: 20,width: 20,), 'Meetings'),
    MenuItem(Image.network(
      'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/menu_task.png',height: 20,width: 20,), 'Task'),
    MenuItem(Image.network(
      'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/menu_report.png',height: 20,width: 20,), 'Report'),
//    MenuItem(Image.asset('assets/images/profile.png',height: 20,width: 20,), 'Profile'),
    MenuItem(Image.network(
      'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/leads.png',height: 20,width: 20,), 'Lead'),
    MenuItem(Image.network(
      'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/expense.png',height: 20,width: 20,), 'Expense'),
    MenuItem(Image.network(
      'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/menu_routeplan.png',height: 20,width: 20,), 'Route Planner'),
    MenuItem(Image.network(
      'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/utility.png',height: 20,width: 20,), 'Utilities'),
//    MenuItem(Image.asset('assets/images/contact.png',height: 20,width: 20,), 'Contact'),
    MenuItem(Image.network(
  'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/menu_logout.png',height: 20,width: 20,), 'Logout'),
    //MenuItem(Image.asset('assets/images/order.png',height: 20,width: 20,), 'Order'),
   // MenuItem(Image.asset('assets/images/utility.png',height: 20,width: 20,), 'Utilities'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHearderValue();
    _battery.batteryLevel.then((level) {
      this.setState(() {
        _batteryLevel = level;
      });
    });

    _battery.onBatteryStateChanged.listen((BatteryState state) {
      _battery.batteryLevel.then((level) {
        this.setState(() {
          _batteryLevel = level;
          _batteryState = state;
        });
      });
    });
  }
  String name='',email='not available',pic='';


  Future<bool> _onBackPressed() {

    return Future.value(true);
  }

  getHearderValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name=prefs.getString('name');
    email=prefs.getString('email');
    imageUrl=prefs.getString('profile');
   // name=prefs.getString('name');
   // name=prefs.getString('name');
  }

  @override
  Widget build(BuildContext context) {
    getDashBoardData();
    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MenuController>(context, listen: true).toggle();
        }
      },
      child:WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        padding: EdgeInsets.only(
            top: 40,
            left: 22,
            bottom: 8,
            right: MediaQuery.of(context).size.width / 4.9),
        color: Color(0xff253f5b),
        child: Column(
          children: <Widget>[
            Container(
              child:GestureDetector(child:  Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircularImage(
                      NetworkImage(!["", null, false, 0].contains(imageUrl)? imageUrl :"https://huntpng.com/images250/avatar-png-1.png"),
                    ),
                  ),
                  Flexible(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        child: Text(
                          email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                        ),
                        width: 200,
                      )

                    ],
                  ),flex: 1,
                  ),

                ],
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new Profile();
                          }));
              },),
            ),
            Padding(padding: EdgeInsets.only(
            top: 10,
            left: 22,
            bottom: 8),
              child: GestureDetector(
                child:  Row(
                children: <Widget>[

                  Text(!["", null, false, 0,"0"].contains(punchinStatus)?"Punched In":'Punched Out',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Montserrat')),

                  new Image.asset(!["", null, false, 0,"0"].contains(punchinStatus)?'assets/images/switch_on.png': 'assets/images/switch_off.png'
                    ,
                    height: 40.0,
                    width: 40,
                  ),

                ],
              ),
              onTap: (){


                if(punchinStatus=="0"||punchinStatus==''){
                  doPunchIn();
                  print(punchinStatus);
                }

                if(punchinStatus=="1"){
                  doPunchout();
                  print(punchinStatus);
                }


              },)
             ,
            ),


            Flexible(child: ListView(
              children: options.map((item) {
                return ListTile(
                  leading: item.icon,
                  dense: true,
                  title: Text(
                    item.title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () async {
                    Provider.of<MenuController>(context, listen: true).toggle();
//                    Navigator.of(context).push(MaterialPageRoute<Null>(
//                        builder: (BuildContext context) {
//                          return new RegisterScreen();
//                        }));

                    if(item.title=='Home'){
                      Provider.of<MenuController>(context, listen: true).toggle();
                    }
                    if(item.title=='Meetings'){
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new MeetingList(initialDate: DateTime.now(),);
                          }));
                    }

                    if(item.title=='Task'){
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new TaskList(text: "",text2: "",);
                          }));
                    }
//                    if(item.title=='Profile'){
//                      Navigator.of(context).push(MaterialPageRoute<Null>(
//                          builder: (BuildContext context) {
//                            return new Profile();
//                          }));
//                    }
                    if(item.title=='Lead'){
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new LeadScreen(text: "",text2: "Leads",text3: "",);
                          }));
                    }
                    if(item.title=='Expense'){
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new ExpenseLis(status: "2",);
                          }));
                    }

                    if(item.title=='Report'){
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new ReportsOne();
                          }));
                    }

                    if(item.title=='Route Planner'){
                      if(punchinStatus=="1") {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return new ClientList();
                            }));
                      }else{
                        Fluttertoast.showToast(
                            msg: "PunchIn first",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.green[300],
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    }

                    if(item.title=='Utilities'){
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new ChangePassword();
                          }));
                    }

                    if(item.title=='Logout'){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.remove('userId');
                      prefs.remove('user_token');
                      prefs.remove('name');
                      prefs.remove('email');
                      //prefs.remove('userId');
                      Navigator.of(context).pop(true);
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new LoginScreen();
                          }));
                    }


                    print(item.title);
                  },
                );
              }).toList(),
            ),),


//            ListTile(
//              onTap: () {
//
//              },
//              leading: Image.asset(
//                'assets/images/contact.png',
//                height: 20,width: 20,
//              ),
//              title: Text('Support',
//                  style: TextStyle(fontSize: 14, color: Colors.white)),
//            ),

//            ListTile(
//              onTap: ()  async {
//
//
//              },
//              leading: Image.asset(
//                'assets/images/utility.png',
//                height: 20,width: 20,
//              ),
//              title: Text('Logout',
//                  style: TextStyle(fontSize: 14, color: Colors.white)),
//            ),

          ],
        ),
      ),),
    );
  }
}

class MenuItem {
  String title;
  Image icon;

  MenuItem(this.icon, this.title);
}