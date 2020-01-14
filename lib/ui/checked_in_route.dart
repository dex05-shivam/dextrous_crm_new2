import 'dart:async';
import 'dart:io';

import 'package:battery/battery.dart';
import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'checkout_page.dart';



class MeetingOptions extends StatefulWidget {
  final String meeting_id,status;

  MeetingOptions({Key key, @required this.meeting_id, @required this.status}) : super(key: key);

  @override
  _MeetingOptionsState createState() => new _MeetingOptionsState(meeting_id: meeting_id,status: status);

}
class _MeetingOptionsState extends State<MeetingOptions>
{
  final String meeting_id,status;

  _MeetingOptionsState({Key key, @required this.meeting_id, @required this.status}) : super();

  ProgressDialog pr;
  bool isResponse = false;
  final Battery _battery = Battery();

  BatteryState _batteryState;
  int _batteryLevel;
  bool isHomeDataLoading = false;
  final TextEditingController _feedback = new TextEditingController();
  int status1;
  String
  meting_id,
      lead_id,
      subject,
      members,
      location,
      discription,
      client_number,
      client_name,
      today_meeting,meeting_type
  ;

  String lat = '',
      long = '',
      battery1 = '',
      total_leads = '',
      finished_total_leads = '',
      total_tasks = '',
      finished_total_tasks = '',
      performance = '';
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    var geolocator = Geolocator();
    var locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    print("locationOptions"+locationOptions.toString());

    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      print(position == null
          ? 'Unknown'
          : "get Location"+position.latitude.toString() +
          ', ' +
          position.longitude.toString());
    });

    getToekn('1');



  }

  //bool isResponse = false;


  void getToekn(String type) async {


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
          : "get Location"+position.latitude.toString() +
          ', ' +
          position.longitude.toString());
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isHomeDataLoading = false;


    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/meeting_details";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "meetingId": meeting_id,
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
        status1 = body['status'];
        meting_id = body['meting_id'];
        lead_id = body['lead_id'];
        subject = body['subject'];
        members = body['members'];
        location = body['location'];
        discription = body['discription'];
        client_number = body['client_number'];
        client_name = body['client_name'];
        today_meeting = body['today_meeting'];
        meeting_type = body['meeting_type'];


        // status=body['status'];
        setState(() {
          isHomeDataLoading = true;
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


  Future<int> submitFeedback() async {
    pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/check_in";
    FormData formData = new FormData.from({
      "checkInDisc": lead_id,
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'meetingId': meeting_id,
      //'checkInlocation': _feedback.text.toString(),
      "checkInlocation": "77.3910,28.5355",
      "batteryPunchin": _batteryLevel.toString(),


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
              if(body['status']==1){
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return new Checkout(meetid: meeting_id,);
                    }));
              }


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



  sendMessage(String number) async {
    if(Platform.isAndroid){
      //FOR Android

      await launch('sms:+'+number);
    }
    else if(Platform.isIOS){
      //FOR IOS
      await launch('sms:+'+number);
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    pr = new ProgressDialog(context);
    getToekn('1');
    pr.style(message: 'Please wait...');
    return Scaffold(
        body: WillPopScope(
          child:Padding(
            padding: const EdgeInsets.all(0.0),
            child:
            !["", null, false, 0].contains(status1) ?
            new Container(
                child: new Stack(
                  children: <Widget>[

                    Container(
                      child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/login_back.png',
                        fit: BoxFit.fill,
                      ),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Column(
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
                                    color: Color(0xF3253F5A),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      SystemNavigator.pop();
                                    }
                                  }),
                              Spacer(flex: 1,),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                child:
                                Text(
                                  !["", null, false, 0].contains(client_name)?client_name : 'NA',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xF3253F5A),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Spacer(flex: 1,),

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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 0, 10.0, 0),
                                    child: Text("Subject:",
                                      style: new TextStyle(fontSize: 20.0,color: Colors.black,fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                                    child: Row(children: <Widget>[
                                      Text( !["", null, false, 0].contains(subject)?subject : 'NA',
                                        style: new TextStyle(fontSize: 20.0,color: Color(0xF3253F5A),),
                                      ),


                                    ]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5.0, 2.0, 0, 2.0),
                                    child: Container(
                                      height: 1.0,
                                      color: Color(0xFFF88C9C),
                                    ),),


//                                  Padding(
//                                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
//                                    child: Row(children: <Widget>[
//                                      Text( !["", null, false, 0].contains(client_name)?client_name : 'NA', style: new TextStyle(fontWeight: FontWeight.bold),),
//
//                                    ]),
//                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                                    child: Row(children: <Widget>[
                                      Text("Location:",
                                        style: new TextStyle(fontSize: 20.0,color: Colors.black,fontWeight: FontWeight.bold),),
                                      Spacer(),
                                      Icon(Icons.location_on,color: Color(0xF3253F5A)),
                                    ],),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Text(!["", null, false, 0].contains(location)?location : 'NA', style: new TextStyle(fontSize: 20.0,color: Color(0xF3253F5A)),)),

                                        //Icon(Icons.directions_car),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5.0, 2.0, 0, 2.0),
                                    child: Container(
                                      height: 1.0,
                                      color: Color(0xFFF88C9C),
                                    ),),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                                    child: Text("Description:",
                                      style: new TextStyle(fontSize: 20.0,color: Colors.black,fontWeight: FontWeight.bold),),
                                  ),



                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                                    child: Row(
                                      children: <Widget>[

                                        Text(!["", null, false, 0].contains(discription)?discription : 'NA', style: new TextStyle(fontSize: 20.0,color: Color(0xF3253F5A)),),
                                        Spacer(),


                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            )),

                        Container(
                          // This align moves the children to the bottom
                            child: Align(
                                alignment: FractionalOffset.bottomCenter,
                                // This container holds all the children that will be aligned
                                // on the bottom and should not scroll with the above ListView
                                child: Container(
                                    width: double.infinity,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0.0),
                                                topLeft: Radius.circular(0.0),
                                                bottomRight: Radius.circular(0.0),
                                              ),
                                            ),

                                            // Within the `FirstRoute` widget
                                            onPressed: () {
                                              submitFeedback();
                                            },
                                            color: Color(0xF3253F5A),
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              // Replace with a Row for horizontal icon + text
                                              children: <Widget>[
                                                Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/tick_inside_circle.png',
                                                  height: 40.0,
                                                  width: 40.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                //Icon(Icons.check_circle,size: 40.0,color: Colors.white,),
                                                Text("Check-In",style: new TextStyle(color: Colors.white),)
                                              ],
                                            ),
                                          ),
                                        )
                                        ,
                                        Expanded(
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0.0),
                                                topLeft: Radius.circular(0.0),
                                                bottomRight: Radius.circular(0.0),
                                              ),
                                            ),
                                            onPressed: () => {
                                              _launchURL(client_number)
                                            },
                                            color: Color(0xFFF88C9C),
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              // Replace with a Row for horizontal icon + text
                                              children: <Widget>[
                                                Icon(Icons.call,size: 40.0,color: Colors.white,),
                                                Text("Call",style: new TextStyle(color: Colors.white),)
                                              ],
                                            ),
                                          ),
                                        )
                                        ,
                                        Expanded(
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0.0),
                                                topLeft: Radius.circular(0.0),
                                                bottomRight: Radius.circular(0.0),
                                              ),
                                            ),
                                            onPressed: () => {

                                              sendMessage(client_number)
                                            },
                                            color: Color(0xF3253F5A),
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              // Replace with a Row for horizontal icon + text
                                              children: <Widget>[

                                                Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/paper_plane.png',
                                                  height: 40.0,
                                                  width: 40.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                //Icon(Icons.email,size: 40.0,color: Colors.white,),
                                                Text("Message",style: new TextStyle(color: Colors.white),)
                                              ],
                                            ),
                                          ),
                                        )
                                        ,

                                        Visibility(child: Expanded(
                                          child: FlatButton(

                                            onPressed: () => {

                                            },
                                            color: Colors.transparent,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              // Replace with a Row for horizontal icon + text
                                              children: <Widget>[
                                                Icon(Icons.close,size: 40.0,),
                                                Text("Close")
                                              ],
                                            ),
                                          ),
                                        ),visible: false,)
                                      ],
                                    )
                                )
                            )
                        ),
                      ],
                    )
                  ],
                )) :
            Center(child: CircularProgressIndicator(),)
          ),
        ),
        resizeToAvoidBottomPadding: true);
  }

}


void _calling(){
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

