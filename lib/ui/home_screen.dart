import 'dart:async';
import 'dart:convert';

import 'package:battery/battery.dart';
import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/drawer_ui/menu_page.dart';
import 'package:dextrous_crm_new2/drawer_ui/zoom_scaffold.dart';
import 'package:dextrous_crm_new2/ui/profile_page.dart';
import 'package:dextrous_crm_new2/ui/task_list.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../liquid_progress_indicator.dart';
import 'add_expense.dart';
import 'expense_list.dart';

//import 'package:location/location.dart';
import 'lead_screen.dart';
import 'meeting_list.dart';

void main() => runApp(new HomePage());

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Dextrous Crm',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  MenuController menuController;
  DateTime currentBackPressTime;

//  var location = new Location();
  String lat = '',
      long = '',
      battery1 = '',
      email = '',
      name = '',
      total_leads = '',
      finished_total_leads = '',
      total_tasks = '',
      finished_total_tasks = '',
      performance = '';
  SharedPreferences prefs;

  final Battery _battery = Battery();

  BatteryState _batteryState;
  int _batteryLevel;

//  Future<bool> _onBackPressed() {
//    return Future.value(true);
//  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  void initState() {
    super.initState();

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

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

//    _getLocation().then((value) {
//      setState(() {
//        userLocation = value;
//        lat=userLocation["latitude"].toString();
//        long=userLocation["longitude"].toString();
//      });
//    });

    new Timer.periodic(
        Duration(seconds: 60),
        (Timer t) => setState(() {
              getToekn();
            }));

    getToekn();
    getDashBoardData('');
  }

  bool isResponse = false;
  var performanceDouble;

  Future<int> getToekn() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');
    email = prefs.getString('email');
    total_tasks = prefs.getString('total_tasks');

    performance = prefs.getString('performance');
    finished_total_tasks = prefs.getString('finished_total_tasks');
    performanceDouble = double.parse(performance) / 100;

    assert(performanceDouble is double);
    print(performanceDouble);
    //email=prefs.getString('email');
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
    String date1 = now.year.toString() +
        '-' +
        now.month.toString() +
        '-' +
        now.day.toString();
    // String login_url = "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/auth/tracking";
    FormData formData = new FormData.from({
      "date": date1,
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "longitude": long,
      "latitude": lat,
      "batteryPer": _batteryLevel.toString(),
    });
    print(lat + long);

    http.Response response = await http.post(
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/auth/tracking",
        body: formData);

    setState(() {
      isResponse = true;
    });
    var body = await json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);

      isResponse = false;
    } else {
      isResponse = true;
    }
    //Simulate a service call
    print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 4), () {});

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
    return body['status'];
  }

  String complete_task = '',
      notstated_task = '',
      inprocess_task = '',
      today_assign_leads = '',
      total_converted_leads = '',
      today_meetings = '',
      today_calls = '',
      today_reminder = '',
      meeting_good = '',
      meeting_bad = '',
      expense_appreved = '',
      expense_reject = '';

  void getDashBoardData(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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
        complete_task = body['complete_task'];
        notstated_task = body['notstated_task'];
        inprocess_task = body['inprocess_task'];
        today_assign_leads = body['today_assign_leads'];
        total_converted_leads = body['total_converted_leads'];
        today_meetings = body['today_meetings'];
        today_calls = body['today_calls'];
        today_reminder = body['today_reminder'];
        meeting_good = body['meeting_good'];
        meeting_bad = body['meeting_bad'];
        expense_appreved = body['expense_appreved'];
        expense_reject = body['expense_reject'];
        total_leads = body['total_leads'];

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

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width;
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: ZoomScaffold(
          menuScreen: MenuScreenState(),
          contentScreen: Layout(
              contentBuilder: (cc) => Container(
                    child: Expanded(
                      child: Container(
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 30, 20, 20),
                              child: GestureDetector(
                                onTap: () {},
                                child: Card(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15.0, 10, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Expense',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[800],
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 0, 0),
                                                      child: Text(
                                                        ["", null, false, 0]
                                                                .contains(name)
                                                            ? name
                                                            : name,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[800],
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Text(
                                                      ["", null, false, 0]
                                                              .contains(email)
                                                          ? email
                                                          : email,
                                                      style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
//                                        Container(
//                                          height: 35,
//                                          width: 35,
//                                          child:
//                                          LiquidCircularProgressIndicator(
//                                            value: performanceDouble, // Defaults to 0.5.
//                                            valueColor:
//                                            AlwaysStoppedAnimation(Colors
//                                                .blue[
//                                            900]), // Defaults to the current Theme's accentColor.
//                                            backgroundColor: Colors
//                                                .white, // Defaults to the current Theme's backgroundColor.
//                                            borderColor: Colors.blue[400],
//                                            borderWidth: 5.0,
//                                            direction: Axis
//                                                .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
//                                          ),
//                                        )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10.0, 5, 10, 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: GestureDetector(
                                                  child: Card(
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                    'Approved',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w900)),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        10,
                                                                        5,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                    ![
                                                                      "",
                                                                      null,
                                                                      false,
                                                                      0
                                                                    ].contains(
                                                                            expense_appreved)
                                                                        ? expense_appreved
                                                                        : 'NA',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w700)),
                                                              ),
                                                            ],
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                          ),
                                                          Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/company.png',
                                                            width: 40,
                                                            height: 40,
                                                          )
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                      ),
                                                      width: 150,
                                                      height: 75,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                    elevation: 5,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute<Null>(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return new ExpenseLis(
                                                        status: "1",
                                                      );
                                                    }));
                                                  },
                                                ),
                                                flex: 1,
                                              ),
                                              Flexible(
                                                child: GestureDetector(
                                                  child: Card(
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                    'Pending',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w900)),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        10,
                                                                        5,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                    ![
                                                                      "",
                                                                      null,
                                                                      false,
                                                                      0
                                                                    ].contains(
                                                                            expense_reject)
                                                                        ? expense_reject
                                                                        : "NA",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w700)),
                                                              ),
                                                            ],
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                          ),
                                                          Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/callsa.png',
                                                            width: 40,
                                                            height: 40,
                                                          )
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                      ),
                                                      width: 150,
                                                      height: 75,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                    elevation: 5,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute<Null>(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return new ExpenseLis(
                                                        status: "0",
                                                      );
                                                    }));
                                                  },
                                                ),
                                                flex: 1,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    height: 180,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/background.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    width: deviceRatio,
                                  ),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute<Null>(
                                                          builder: (BuildContext
                                                              context) {
                                                    return new MeetingList(
                                                      initialDate:
                                                          DateTime.now(),
                                                    );
                                                  }));
                                                },
                                                child: Card(
                                                  color: Colors.white,
                                                  child: Container(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    20,
                                                                    0,
                                                                    20,
                                                                    0),
                                                            child: Text(
                                                              ![
                                                                "",
                                                                null,
                                                                false,
                                                                0
                                                              ].contains(
                                                                      today_calls)
                                                                  ? today_calls
                                                                  : '0',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    15,
                                                                    0,
                                                                    15,
                                                                    0),
                                                            child: Text(
                                                              'Todays Calls',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                            ),
                                                          )
                                                        ]),
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/i.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                            Flexible(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute<Null>(
                                                          builder: (BuildContext
                                                              context) {
                                                    return new MeetingList(
                                                      initialDate:
                                                          DateTime.now(),
                                                    );
                                                  }));
                                                },
                                                child: Card(
                                                  color: Colors.white,
                                                  child: Container(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    20,
                                                                    0,
                                                                    20,
                                                                    0),
                                                            child: Text(
                                                              ![
                                                                "",
                                                                null,
                                                                false,
                                                                0
                                                              ].contains(
                                                                      today_meetings)
                                                                  ? today_meetings
                                                                  : '0',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    15,
                                                                    0,
                                                                    15,
                                                                    0),
                                                            child: Text(
                                                              'Todays Meetings',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                            ),
                                                          )
                                                        ]),
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/h.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                            Flexible(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Card(
                                                  color: Colors.white,
                                                  child: Container(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    20,
                                                                    0,
                                                                    20,
                                                                    0),
                                                            child: Text(
                                                              ![
                                                                "",
                                                                null,
                                                                false,
                                                                0
                                                              ].contains(
                                                                      today_reminder)
                                                                  ? today_reminder
                                                                  : '0',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    15,
                                                                    0,
                                                                    15,
                                                                    0),
                                                            child: Text(
                                                              'Todays Reminders',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                            ),
                                                          )
                                                        ]),
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/c1.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute<Null>(
                                                          builder: (BuildContext
                                                              context) {
                                                    return new LeadScreen(
                                                      text: "2",
                                                      text2: "Converted Lead",
                                                      text3: "",
                                                    );
                                                  }));
                                                },
                                                child: Card(
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10, 10, 10, 10),
                                                    child: Container(
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'Converted Leads',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900),
                                                                ),
                                                              ),
                                                              flex: 1,
                                                            ),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        5,
                                                                        0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {},
                                                                  child:
                                                                      ClipOval(
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                              .amber[
                                                                          100],
                                                                      height:
                                                                          50.0,
                                                                      // height of the button
                                                                      width:
                                                                          50.0,
                                                                      // width of the button
                                                                      child: Center(
                                                                          child: Text(
                                                                        ![
                                                                          "",
                                                                          null,
                                                                          false,
                                                                          0
                                                                        ].contains(
                                                                                total_converted_leads)
                                                                            ? total_converted_leads +
                                                                                '/' +
                                                                                total_leads
                                                                            : '0' +
                                                                                '/\n' +
                                                                                total_leads,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.blueGrey[800],
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                      )),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ]),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                            Flexible(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute<Null>(
                                                          builder: (BuildContext
                                                              context) {
                                                    return new LeadScreen(
                                                      text: "1",
                                                      text2: "Today Leads",
                                                      text3: "",
                                                    );
                                                  }));
                                                },
                                                child: Card(
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10, 10, 10, 10),
                                                    child: Container(
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'Leads Assigned Today',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900),
                                                                ),
                                                              ),
                                                              flex: 1,
                                                            ),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        5,
                                                                        0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {},
                                                                  child:
                                                                      ClipOval(
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                              .lightBlueAccent[
                                                                          100],
                                                                      height:
                                                                          50.0,
                                                                      // height of the button
                                                                      width:
                                                                          50.0,
                                                                      // width of the button
                                                                      child: Center(
                                                                          child: Text(
                                                                        ![
                                                                          "",
                                                                          null,
                                                                          false,
                                                                          0
                                                                        ].contains(
                                                                                today_assign_leads)
                                                                            ? today_assign_leads +
                                                                                '/' +
                                                                                total_leads
                                                                            : '0' +
                                                                                '/\n' +
                                                                                total_leads,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.blueGrey[800],
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                      )),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ]),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 10, 0, 20),
                                          child: GestureDetector(
                                              onTap: () {},
                                              child: Card(
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15.0,
                                                                10,
                                                                10,
                                                                0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/task.png',
                                                                    height: 30,
                                                                    width: 30,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            5,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      'Task',
                                                                      style: TextStyle(
                                                                          color: Colors.grey[
                                                                              500],
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
//
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10.0,
                                                                5,
                                                                10,
                                                                10),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Flexible(
                                                              child:
                                                                  GestureDetector(
                                                                child: Card(
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                                              child: Text(
                                                                                  ![
                                                                                    "",
                                                                                    null,
                                                                                    false,
                                                                                    0
                                                                                  ].contains(notstated_task)
                                                                                      ? notstated_task
                                                                                      : 'NA',
                                                                                  style: TextStyle(color: Colors.blueGrey[800], fontSize: 18, fontWeight: FontWeight.w700)),
                                                                            ),
                                                                          ],
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              5,
                                                                              0,
                                                                              0),
                                                                          child: Text(
                                                                              'Not Started',
                                                                              style: TextStyle(color: Colors.blueGrey[800], fontSize: 12, fontWeight: FontWeight.w700)),
                                                                        ),
                                                                      ],
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                    ),
                                                                    width: 150,
                                                                    height: 75,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  elevation: 5,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute<
                                                                              Null>(
                                                                          builder:
                                                                              (BuildContext context) {
                                                                    return new TaskList(
                                                                      text: "1",
                                                                      text2: "",
                                                                    );
                                                                  }));
                                                                },
                                                              ),
                                                              flex: 1,
                                                            ),
                                                            Flexible(
                                                              child:
                                                                  GestureDetector(
                                                                child: Card(
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                                              child: Text(
                                                                                  ![
                                                                                    "",
                                                                                    null,
                                                                                    false,
                                                                                    0
                                                                                  ].contains(inprocess_task)
                                                                                      ? inprocess_task
                                                                                      : 'NA',
                                                                                  style: TextStyle(color: Colors.blueGrey[800], fontSize: 18, fontWeight: FontWeight.w700)),
                                                                            ),
                                                                          ],
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              5,
                                                                              0,
                                                                              0),
                                                                          child: Text(
                                                                              'In Progress',
                                                                              style: TextStyle(color: Colors.blueGrey[800], fontSize: 12, fontWeight: FontWeight.w700)),
                                                                        ),
                                                                      ],
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                    ),
                                                                    width: 150,
                                                                    height: 75,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  elevation: 5,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute<
                                                                              Null>(
                                                                          builder:
                                                                              (BuildContext context) {
                                                                    return new TaskList(
                                                                      text: "4",
                                                                      text2: "",
                                                                    );
                                                                  }));
                                                                },
                                                              ),
                                                              flex: 1,
                                                            ),
                                                            Flexible(
                                                              child:
                                                                  GestureDetector(
                                                                child: Card(
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                                              child: Text(
                                                                                  ![
                                                                                    "",
                                                                                    null,
                                                                                    false,
                                                                                    0
                                                                                  ].contains(complete_task)
                                                                                      ? complete_task
                                                                                      : 'NA',
                                                                                  style: TextStyle(color: Colors.blueGrey[800], fontSize: 18, fontWeight: FontWeight.w700)),
                                                                            ),
                                                                          ],
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              5,
                                                                              0,
                                                                              0),
                                                                          child: Text(
                                                                              'Complete',
                                                                              style: TextStyle(color: Colors.blueGrey[800], fontSize: 12, fontWeight: FontWeight.w700)),
                                                                        ),
                                                                      ],
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                    ),
                                                                    width: 150,
                                                                    height: 75,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  elevation: 5,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute<
                                                                              Null>(
                                                                          builder:
                                                                              (BuildContext context) {
                                                                    return new TaskList(
                                                                      text: "5",
                                                                      text2: "",
                                                                    );
                                                                  }));
                                                                },
                                                              ),
                                                              flex: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  width: deviceRatio,
                                                ),
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ))),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 20, 10),
                              child: Card(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15.0, 10, 10, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/meeting.png',
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 0, 0),
                                                    child: Text(
                                                      'Meeting Feedback',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[500],
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
//                                        Container(
//                                          height: 35,
//                                          width: 35,
//                                          child:
//                                          LiquidCircularProgressIndicator(
//                                            value: performanceDouble, // Defaults to 0.5.
//                                            valueColor:
//                                            AlwaysStoppedAnimation(Colors
//                                                .blue[
//                                            900]), // Defaults to the current Theme's accentColor.
//                                            backgroundColor: Colors
//                                                .white, // Defaults to the current Theme's backgroundColor.
//                                            borderColor: Colors.blue[400],
//                                            borderWidth: 5.0,
//                                            direction: Axis
//                                                .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
//                                          ),
//                                        )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10.0, 5, 10, 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: Card(
                                                child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 5, 0, 0),
                                                            child: Text(
                                                                ![
                                                                  "",
                                                                  null,
                                                                  false,
                                                                  0
                                                                ].contains(
                                                                        meeting_good)
                                                                    ? meeting_good
                                                                    : 'NA',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .blueGrey[
                                                                        800],
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                          ),
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                      ),
                                                      Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/happy.png',
                                                        width: 30,
                                                        height: 30,
                                                      )
                                                    ],
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                  ),
                                                  width: 150,
                                                  height: 75,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                            Flexible(
                                              child: Card(
                                                child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 5, 0, 0),
                                                            child: Text(
                                                                ![
                                                                  "",
                                                                  null,
                                                                  false,
                                                                  0
                                                                ].contains(
                                                                        meeting_bad)
                                                                    ? meeting_bad
                                                                    : 'NA',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .blueGrey[
                                                                        800],
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                          ),
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                      ),
                                                      Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/sad.png',
                                                        width: 30,
                                                        height: 30,
                                                      )
                                                    ],
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                  ),
                                                  width: 150,
                                                  height: 75,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffffcccb),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  width: deviceRatio,
                                ),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}

class DashboardModel {
  const DashboardModel({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<DashboardModel> choices = const <DashboardModel>[
  const DashboardModel(title: 'Car', icon: Icons.directions_car),
  const DashboardModel(title: 'Bicycle', icon: Icons.directions_bike),
  const DashboardModel(title: 'Boat', icon: Icons.directions_boat),
];

class DashboardCard extends StatelessWidget {
  const DashboardCard({Key key, this.choice}) : super(key: key);
  final DashboardModel choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
        color: Colors.white,
        child: Center(
          child: Container(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Icon(choice.icon,
                          size: 90.0, color: textStyle.color)),
                  Text(choice.title, style: textStyle),
                ]),
            height: 150,
            width: 150,
          ),
        ));
  }
}
