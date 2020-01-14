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

class FeedBackMeeting extends StatefulWidget {
  String notes = '', meetid = '';

  FeedBackMeeting({Key key, @required this.notes, this.meetid}) : super(key: key);

  @override
  _FeedBackMeetingState createState() =>
      new _FeedBackMeetingState(notes: notes, meetid: meetid);
}

class _FeedBackMeetingState extends State<FeedBackMeeting> {
  String notes = '', meetid = '';
  _FeedBackMeetingState({@required this.notes, this.meetid}) : super();
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


  @override
  void initState() {
    super.initState();

    getToekn1('');
  }

// our default setting is to login, and we should switch to creating an account when the user chooses to


  ProgressDialog pr;


  Future<bool> _onBackPressed() {


    return Future.value(true);

  }


  Future<int> submitFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/meeting_close";
    FormData formData = new FormData.from({
      "lead_id": lead_id,
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'meetid': meetid,
      'feedback': _description.text.toString(),
      'emoji': imog.toString(),


    });

    http.Response response = await http.post(login_url, body: formData);

    var body = await json.decode(response.body);
    //Simulate a service call
    print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 4), () {
      setState(() async {
        if (response.statusCode == 200) {
          var body = await json.decode(response.body);
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
              //isResponse = false;
              Navigator.of(context, rootNavigator: true).pop();
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
          onWillPop: _onBackPressed,
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
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
                                    const EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                                  Expanded(child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Please enter Description';
                                        }
                                      },
                                      controller: _description,
                                      maxLines: 5,
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
                                  ),flex: 1,),

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



                                pr.show();
                                if(!["", null, false, 0,''].contains(_description.text.toString())){
                                  submitFeedback();
                                }else{
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Please Enter Some Feedback"),
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
