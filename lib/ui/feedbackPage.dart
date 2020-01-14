import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/add_comments_screen.dart';
import 'package:dextrous_crm_new2/ui/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'meeting_list.dart';

class FeedBack extends StatefulWidget {
  String notes = '', meetid = '';

  FeedBack({Key key, @required this.notes, this.meetid}) : super(key: key);

  @override
  _FeedBackState createState() =>
      new _FeedBackState(notes: notes, meetid: meetid);
}

class _FeedBackState extends State<FeedBack> {
  String notes = '', meetid = '';
  _FeedBackState({@required this.notes, this.meetid}) : super();
  final TextEditingController _commentsCloseMeeting = new TextEditingController();
  int countValue = 1, imog;
  String contact_on = "assets/images/call_meeting.png",
      summary_off = "assets/images/call_route1.png",
      comment_off = "assets/images/call_close1.png",
      happy = "assets/images/happy1.png",
      sad = "assets/images/sad1.png";




  String _myselection2;
  final String url =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/members_list";
  // final format = DateFormat("yyyy-MM-dd HH:mm");
  String comments = '',
      time1 = 'Select Time',
      date1 = 'Select Date',
      _selectedMemberList = '',
      _selectedMemberIdList = '';
  List data = List();
  List data1 = List(); //edited line

  final TextEditingController _title = new TextEditingController();
  final TextEditingController _selectedMember = new TextEditingController();
  final TextEditingController _account = new TextEditingController();
  final TextEditingController _description = new TextEditingController();


  String lat = '',
      long = '';



  int status;
  String  meting_id,
      lead_id,
      subject,
      members1,
      location,
      discription,
      client_number,
      client_name,
      today_meeting,meeting_type
  ;



  void getToekn1(String type) async {


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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/meeting_details";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "meetingId": meetid,
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
        status = body['status'];
        meting_id = body['meting_id'];
        lead_id = body['lead_id'];
        subject = body['subject'];
        members1 = body['members'];
        location = body['location'];
        discription = body['discription'];
        client_number = body['client_number'];
        client_name = body['client_name'];
        today_meeting = body['today_meeting'];
        meeting_type = body['meeting_type'];


        // status=body['status'];
        setState(() {

        });
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  String _email = "";
  String _password = "";

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


  @override
  void initState() {
    super.initState();
    getSWData();
    getSWData1();
    getUsers();
    getMembers();
    getToekn1('');
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
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/check_out";
    FormData formData = new FormData.from({
      "lead_id": lead_id,
      "meetingId" : meetid,
      "checkOutlocation": "77.3910,28.5355",
      "feedback":"",
      "emoji": imog.toString(),
      "next_step":countValue.toString(),
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'client_location': _account.text.toString(),
      'meeting_type': _myselection2,
      'subject': _title.text.toString(),
      'description': _description.text.toString(),
      'date': date1 + ' ' + time1,
      'member': _selectedMemberIdList,
    });

    http.Response response = await http.post(login_url, body: formData);

    var body = await json.decode(response.body);
    //Simulate a service call
    print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 2), () {
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

          Future.delayed(Duration(seconds: 2)).then((value) {
            pr.hide().whenComplete(() {
              isResponse = false;

              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return new MeetingList(
                  initialDate: DateTime.now(),
                );
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

  Future<int> getToekn2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/check_out";
    FormData formData = new FormData.from({
      "lead_id": lead_id,
      "meetingId" : meetid,
      "checkOutlocation": lat+','+""+long,
      "feedback":"",
      "emoji": imog.toString(),
      "next_step":countValue.toString(),
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'client_location': '',
      'meeting_type': '',
      'subject': '',
      'description': '',
      'date': '',
      'member': '',
    });

    http.Response response = await http.post(login_url, body: formData);

    var body = await json.decode(response.body);
    //Simulate a service call
    print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 2), () {
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

          Future.delayed(Duration(seconds: 2)).then((value) {
            pr.hide().whenComplete(() {
              isResponse = false;

              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new HomePage(
                    );
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
                  _selectedMemberList = '';
                  _selectedMemberIdList = '';
                  for (var i = 0; i < selectedList.length; i++) {
                    if (_selectedMemberList == '') {
                      _selectedMemberList = selectedList[i].name;
                      _selectedMemberIdList = selectedList[i].id;
                    } else {
                      _selectedMemberList =
                          _selectedMemberList + ',' + selectedList[i].name;
                      _selectedMemberIdList =
                          _selectedMemberIdList + ',' + selectedList[i].id;
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
        print('Users: ' + users.length.toString());
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
        print('Users: ' + members.length.toString());
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Widget row(User user) {
    return Padding(
      child: Container(
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
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
    );
  }

  void _onFormSaved() {
    final FormState form = _formKey.currentState;
    form.save();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
        body: WillPopScope(
          child: new Container(
              child: new Stack(
            children: <Widget>[
              Container(
//                    child: Image.asset(
//                      'images/map_background.jpg',
//                      fit: BoxFit.fill,
//                    ),
                color: Colors.lightBlue[100],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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

                        Expanded(
                          child: Text(
                            'Feedback',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          flex: 1,
                        ),
//                            new IconButton(
//                                icon: Icon(
//                                  Icons.home,
//                                  color: Colors.black,
//                                  size: 20,
//                                ),
//                                onPressed: () {
////                            Provider.of<MenuController>(context, listen: true)
////                                .toggle();
//                                }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                        width: size.width,
                        height: size.height,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListView(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "How meeting went?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imog = 1;
                                          happy = 'assets/images/happy.png';
                                          sad = 'assets/images/sad1.png';
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          new Container(
                                            child: new Image.asset(
                                              happy,
                                              height: 45.0,
                                              width: 45,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            imog = 0;
                                            happy = 'assets/images/happy1.png';
                                            sad = 'assets/images/sad.png';
                                          });
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          new Container(
                                            child: new Image.asset(
                                              sad,
                                              height: 45.0,
                                              width: 45,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Container(
                                  height: 1.0,
                                  color: Colors.grey[300],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Description';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Description',
                                      hintText: 'Enter Description',
                                      errorStyle: TextStyle(
                                          color: Colors.yellowAccent,
                                          fontSize: 15.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                ),
                              ),
                              new Container(
                                  child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25.0, 10, 25, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                countValue=1;
                                                contact_on =
                                                    "assets/images/call_meeting.png";
                                                summary_off =
                                                    "assets/images/call_route1.png";
                                                comment_off =
                                                    "assets/images/call_close1.png";
                                              });

//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ForgotPasswordApp()),
//                );
                                            },
                                            child: new Image.asset(
                                              contact_on,
                                              width: 100,
                                              height: 40,
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 3, 0, 0),
                                          child: Container(
                                            color: Colors.grey,
                                            height: 27,
                                            width: 1,
                                          ),
                                        ),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                countValue=2;
                                                contact_on =
                                                    "assets/images/call_meeting1.png";
                                                summary_off =
                                                    "assets/images/call_route.png";
                                                comment_off =
                                                    "assets/images/call_close1.png";
                                              });

//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ForgotPasswordApp()),
//                );
                                            },
                                            child: new Image.asset(
                                              summary_off,
                                              width: 100,
                                              height: 40,
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 3, 0, 0),
                                          child: Container(
                                            color: Colors.grey,
                                            height: 27,
                                            width: 1,
                                          ),
                                        ),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                countValue=3;
                                                contact_on =
                                                    "assets/images/call_meeting1.png";
                                                summary_off =
                                                    "assets/images/call_route1.png";
                                                comment_off =
                                                    "assets/images/call_close.png";
                                              });
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ForgotPasswordApp()),
//                );
                                            },
                                            child: new Image.asset(
                                              comment_off,
                                              width: 100,
                                              height: 40,
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                              countValue == 1
                                  ? new Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child: new ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            new Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0.0, 8, 0, 0),
                                                    child: Text(
                                                      '*Meeting Subject',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  new TextField(
                                                    controller: _title,
                                                    decoration:
                                                        new InputDecoration(
                                                            hintText:
                                                                'Enter Subject',
                                                            hintStyle: style1,
                                                            suffixIcon: Icon(
                                                              Icons
                                                                  .person_outline,
                                                              color:
                                                                  Colors.black,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0.0, 8, 0, 0),
                                                    child: Text(
                                                      '*Members',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10.0, 0, 10, 0),
                                                    child: Center(
                                                      child: new TextField(
                                                        readOnly: true,
                                                        onTap: () {
                                                          _showReportDialog();
                                                        },
                                                        decoration:
                                                            new InputDecoration(
                                                                hintText: ![
                                                                  "",
                                                                  null,
                                                                  false,
                                                                  0,
                                                                  ''
                                                                ].contains(
                                                                        _selectedMemberList)
                                                                    ? _selectedMemberList
                                                                    : 'Select Members',
                                                                hintStyle:
                                                                    style1,
                                                                suffixIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .person_outline,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 20,
                                                                )),
                                                        maxLines: 1,
                                                        autofocus: false,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            new Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0.0, 8, 0, 0),
                                                    child: Text(
                                                      '*Meeting Type',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10.0, 0, 10, 0),
                                                      child: DropdownButton<
                                                          String>(
                                                        icon: Icon(Icons
                                                            .arrow_drop_down_circle),
                                                        iconSize: 24,
                                                        hint:
                                                            Text('Select Type'),
                                                        isExpanded: true,
                                                        underline: null,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                        items:
                                                            data1.map((item) {
                                                          return new DropdownMenuItem(
                                                            child: new Text(
                                                                item['value']),
                                                            value: item['id']
                                                                .toString(),
                                                          );
                                                        }).toList(),
                                                        onChanged: (newVal) {
                                                          setState(() {
                                                            _myselection2 =
                                                                newVal;
                                                          });
                                                        },
                                                        value: _myselection2,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            new Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0.0, 8, 0, 0),
                                                    child: Text(
                                                      'Location',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  new TextField(
                                                    controller: _account,
                                                    decoration:
                                                        new InputDecoration(
                                                            hintText:
                                                                'Enter Location',
                                                            hintStyle: style1,
                                                            suffixIcon: Icon(
                                                              Icons
                                                                  .edit_location,
                                                              color:
                                                                  Colors.black,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0.0, 8, 0, 0),
                                                    child: Text(
                                                      'Description',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  new TextField(
                                                    controller: _description,
                                                    decoration:
                                                        new InputDecoration(
                                                            hintText:
                                                                'Enter Description... ',
                                                            hintStyle: style1,
                                                            labelStyle: style1,
                                                            suffixIcon: Icon(
                                                              Icons
                                                                  .person_outline,
                                                              color:
                                                                  Colors.black,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0.0, 8, 0, 0),
                                                    child: Text(
                                                      'Date',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  new TextField(
                                                    decoration:
                                                        new InputDecoration(
                                                            hintText: date1,
                                                            hintStyle: style1,
                                                            suffixIcon: Icon(
                                                              Icons
                                                                  .person_outline,
                                                              color:
                                                                  Colors.black,
                                                              size: 20,
                                                            )),
                                                    expands: false,
                                                    showCursor: false,
                                                    readOnly: true,
                                                    maxLines: 1,
                                                    onTap: () {
                                                      DatePicker.showDatePicker(
                                                          context,
                                                          showTitleActions:
                                                              true,
                                                          onChanged: (date) {
                                                        date1 = date.toString();
                                                        setState(() {
                                                          date1 = date.year
                                                                  .toString() +
                                                              '-' +
                                                              date.month
                                                                  .toString() +
                                                              '-' +
                                                              date.day
                                                                  .toString();
                                                        });
                                                        print('change $date');
                                                      }, onConfirm: (date) {
                                                        print('confirm $date');

                                                        setState(() {
                                                          date1 = date.year
                                                                  .toString() +
                                                              '-' +
                                                              date.month
                                                                  .toString() +
                                                              '-' +
                                                              date.day
                                                                  .toString();
                                                        });
                                                      },
                                                          currentTime:
                                                              DateTime.now(),
                                                          locale:
                                                              LocaleType.en);
                                                    },
                                                    autofocus: false,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            new Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0.0, 8, 0, 0),
                                                    child: Text(
                                                      'Time',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  new TextField(
                                                    decoration:
                                                        new InputDecoration(
                                                            hintText: time1,
                                                            hintStyle: style1,
                                                            suffixIcon: Icon(
                                                              Icons
                                                                  .person_outline,
                                                              color:
                                                                  Colors.black,
                                                              size: 20,
                                                            )),
                                                    expands: false,
                                                    showCursor: false,
                                                    readOnly: true,
                                                    maxLines: 1,
                                                    onTap: () {
                                                      DatePicker.showTimePicker(
                                                          context,
                                                          showTitleActions:
                                                              true,
                                                          onChanged: (date) {
                                                        print('change $date');
                                                        time1 = date.hour
                                                                .toString() +
                                                            ':' +
                                                            date.minute
                                                                .toString();
                                                        setState(() {
                                                          time1 = date.hour
                                                                  .toString() +
                                                              ':' +
                                                              date.minute
                                                                  .toString();
                                                        });
                                                      }, onConfirm: (date) {
                                                        print('confirm $date');
                                                        setState(() {
                                                          time1 = date.hour
                                                                  .toString() +
                                                              ':' +
                                                              date.minute
                                                                  .toString();
                                                        });
                                                      },
                                                          currentTime:
                                                              DateTime.now(),
                                                          locale:
                                                              LocaleType.en);
                                                    },
                                                    autofocus: false,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 1,
                                    )
                                  : SingleChildScrollView(
                                      child: countValue == 2
                                          ? new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[


                                                Center(
                                                  child: Text(
                                                    'Comming Soon',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                ),

                                              ],
                                            )
                                          : new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(10.0, 8, 0, 0),
                                                  child: Text(
                                                    'Close Notes',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                                                  child: Container(
                                                    height: 100,
                                                    child: TextFormField(
                                                      controller: _commentsCloseMeeting,
                                                      minLines: 5,
                                                      decoration: const InputDecoration(
                                                        hintText: 'Add your Notes',
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                        ),
                                                      ),
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            )),
                            ],
                          ),
                        )),
                    flex: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        // No any error in validation

                        // print("Name $name");
                        // print("Mobile $_comments");
                        pr.show();
                        if(countValue==1) {
                          getToekn();
                        }
                        if(countValue==3) {
                          getToekn2();
                        }
                        if(countValue==2) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Coming Soon"),
                          ));
                        }
                      },
                      child: Card(
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius: new BorderRadius.circular(40),
                          ),
                          height: 40.0, // height of the button
                          width: 200.0, // width of the button
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
              )
            ],
          )),
        ),
        resizeToAvoidBottomPadding: true);
  }
}

void _calling() {
  _launchURL("9899285839");
}

_launchURL(String phone) async {
  const url = 'tel:"9899285839"';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_textMe() async {
  // Android
  const uri = 'sms:+91 9899285839?body=hello%20there';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    // iOS
    const uri = 'sms:9899285839';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
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
