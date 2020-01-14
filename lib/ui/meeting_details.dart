import 'dart:io';

import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/expense_list.dart';
import 'package:dextrous_crm_new2/ui/feedback_meeting.dart';
import 'package:dextrous_crm_new2/ui/meeting_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_comments_screen.dart';
import 'edit_comments.dart';
import 'edit_meetings.dart';
import 'lead_screen.dart';



class MeetingDetailsHomePage extends StatelessWidget {
  final String text;

  MeetingDetailsHomePage({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Dextrous CRM',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MeetingDetails(text: text,),
    );
  }
}

class MeetingDetails extends StatefulWidget {
  final String text;

  MeetingDetails({Key key, @required this.text}) : super(key: key);
  @override
  _MeetingDetailsState createState() => new _MeetingDetailsState(text: text);
}

class _MeetingDetailsState extends State<MeetingDetails> {
  final String text;

  _MeetingDetailsState({@required this.text}) : super();
  final String uri =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/meeting_details";

  bool isResponse = false;

  int countValue = 1, imog;
  String contact_on = "assets/images/call_meeting.png",
      summary_off = "assets/images/call_route1.png",
      comment_off = "assets/images/call_close1.png",
      happy = "assets/images/happy1.png",
      sad = "assets/images/sad1.png";

  bool isHomeDataLoading = false;
  final TextEditingController _feedback = new TextEditingController();
  int status;
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


  void getToekn(String type) async {
    isHomeDataLoading = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/meeting_details";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "meetingId": text,
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




  _callPhone(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

  _launchURL(String url1) async {
    //const url = url1;
    if (await canLaunch(url1)) {
      await launch(url1);
    } else {
      Fluttertoast.showToast(
          msg:'Enter Valid Url',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );


      throw 'Could not launch $url1';
    }
  }

  Future<bool> _onBackPressed() {

    Navigator.of(context).push(
        MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new MeetingList(initialDate: DateTime.now(),);
        }));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getToekn('1');

  }

  setLoading(bool loading) {
    setState(() {
      isHomeDataLoading = loading;
    });
  }

  fetch() {
    setLoading(true);
  }
  ProgressDialog pr;

  Future<int> submitFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/meeting_close";
    FormData formData = new FormData.from({
      "lead_id": lead_id,
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'meetid': text,
      'feedback': _feedback.text.toString(),
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



  static Center circularProgress() {
    return Center(
      child: SizedBox(
        height: 50.0,
        width: 50.0,
        child: Center(
          child: CircularProgressIndicator(
            valueColor:
            new AlwaysStoppedAnimation<Color>(COLORS.APP_THEME_COLOR),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child:new Container(
              child: new Stack(
                children: <Widget>[
                  Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/backgrounddashboard.png',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: size.width,
                  ),
                  Container(
                    child: Center(
                      child: isHomeDataLoading == false
                          ? circularProgress()
                          : Column(
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
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {

                                      Navigator.of(context).push(
                                          MaterialPageRoute<Null>(builder: (BuildContext context) {
                                            return new MeetingList(initialDate: DateTime.now(),);
                                          }));

                                    }),
                                Flexible(
                                  child: Center(
                                    child: Text(
                                      'Meeting Details',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(25.0, 60, 25, 10),
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(18.0, 9, 18, 0),
                                      child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(18.0),
                                          ),
                                          color: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300]
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                new BorderRadius.circular(
                                                    18.0)),

                                          )),
                                    ),
                                    Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/back.png"),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius:
                                            new BorderRadius.circular(16.0)),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/profile.png',
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              flex: 0,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5.0, 0, 0),
                                                      child: Text(
                                                        ["", null, false, 0].contains(client_name)
                                                            ? 'not available'
                                                            : client_name,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5.0, 0, 5),
                                                      child: Text(
                                                        ["", null, false, 0].contains(subject)
                                                            ? 'not available'
                                                            : subject,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(  ["", null, false, 0].contains(location)
                                                        ? 'not available'
                                                        : location,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            color: Colors.grey)),
                                                  ],
                                                ),
                                              ),
                                              flex: 2,
                                              fit: FlexFit.tight,
                                            ),
                                          ],
                                        ),

                                      ),
                                    )
                                  ],
                                )),
                            onTap: () {
                              // setState(() => countValue == 0 ? countValue = 1 : countValue = 0);
                              // Grid Click

//                        Navigator.of(context).push(MaterialPageRoute<Null>(
//                            builder: (BuildContext context) {
//                              return new LeadDetailsHomePage();
//                            }));
                            },
                          ),
                          new Flexible(
                            child: new ListView(
                              children: <Widget>[
                                Visibility(child:Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: GestureDetector(onTap: (){
                                    _callPhone('tel:'+client_number);

                                  },child: new Card(
                                    child: new Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/phonenumber.png',
                                                height: 30,
                                                width: 30,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      10.0, 0, 0, 0),
                                                  child: Center(
                                                    child: new Text(
                                                      ["", null, false, 0].contains(client_number)
                                                          ? 'not available'
                                                          : client_number
                                                          ,
                                                      style: TextStyle(
                                                        color:
                                                        Color(0xFF022253),
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                      textAlign:
                                                      TextAlign.left,
                                                    ),
                                                  )),
                                            ],
                                          )),
                                      height: 50,
                                      width: _width,
                                    ),
                                    elevation: 5,
                                  ),),
                                ) ,
                                  visible: client_number == "" ? false : true,),
                                Visibility(child:Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child:GestureDetector(onTap: (){
                                    sendMessage(client_number);

                                  },child: new Card(
                                    child: new Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.mail_outline,size: 30,color: Colors.blue,),
                                              Expanded(child: Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    10.0, 0, 0, 0),
                                                child:  new Text(
                                                  client_number == ""
                                                      ? 'No Number available'
                                                      : 'Text Client',
                                                  style: TextStyle(
                                                    color:
                                                    Color(0xFF022253),
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                  textAlign:
                                                  TextAlign.left,
                                                ),
                                              ))
                                              ,
                                            ],
                                          )),
                                      height: 50,
                                      width: _width,
                                    ),
                                    elevation: 5,
                                  ),),
                                ),visible:  true,),
                                Visibility(child:Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: GestureDetector(onTap: (){
                                    MapsLauncher.launchQuery(location);

                                  },child: new Card(
                                    child: new Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[

                                              Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 5, 0, 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/address.png',
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                      Expanded(child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              10.0,
                                                              5,
                                                              40,
                                                              0),
                                                          child: Container(
                                                              child:  new Text(
                                                                  location == ""
                                                                      ? 'No address available'
                                                                      : location,
                                                                  style:
                                                                  TextStyle(
                                                                    color: Color(
                                                                        0xFF022253),
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                  ),
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                  maxLines: 5,
                                                                  overflow: TextOverflow.ellipsis,

                                                                ),
                                                               width: _width)),),
                                                      Visibility(child:
                                                      GestureDetector(
                                                        onTap: (){

                                                        },
                                                        child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/go.png',
                                                        height: 30,
                                                        width: 30,
                                                      ),)
                                                      ,visible: today_meeting=="1" ? true:false)

                                                    ],
                                                  ))
                                            ],
                                          )),

                                      width: _width,
                                    ),
                                    elevation: 5,
                                  ),),
                                ),visible: location == "" ? false : true,),
                                Visibility(child:Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: GestureDetector(onTap: (){


                                  },child: new Card(
                                    child: new Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.record_voice_over,size: 30,color: Colors.blue,),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      10.0, 0, 0, 0),
                                                  child: Center(
                                                    child: new Text(
                                                      "Reminder",
                                                      style: TextStyle(
                                                        color:
                                                        Color(0xFF022253),
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                      textAlign:
                                                      TextAlign.left,
                                                    ),
                                                  )),
                                            ],
                                          )),
                                      height: 50,
                                      width: _width,
                                    ),
                                    elevation: 5,
                                  ),),
                                ),visible: false,),
                                Visibility(
                                  child:Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: GestureDetector(onTap: (){

                                    if(meeting_type=="0") {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return new EditMettings(
                                              meetId: meting_id,
                                              leadId: lead_id,
                                            );
                                          }));
                                    }

                                  },child: new Card(
                                    child: new Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.edit,size: 30,color: Colors.blue,),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      10.0, 0, 0, 0),
                                                  child: Center(
                                                    child: new Text(
                                                      "Edit Meeting",
                                                      style: TextStyle(
                                                        color:
                                                        Color(0xFF022253),
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                      textAlign:
                                                      TextAlign.left,
                                                    ),
                                                  )),
                                            ],
                                          )),
                                      height: 50,
                                      width: _width,
                                    ),
                                    elevation: 5,
                                  ),),
                                ),visible:meeting_type=="0"? true : false,),
                                Visibility(child:Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: GestureDetector(onTap: (){
                                    _displayDialog(context);

                                  },child:new Card(
                                    color: Colors.redAccent[200],
                                    child: new Container(
                                      color: Colors.redAccent[200],
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.delete_forever,size: 30,color: Colors.blue,),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      10.0, 0, 0, 0),
                                                  child: Center(
                                                    child: new Text(
                                                      'Close',
                                                      style: TextStyle(
                                                        color:
                                                        Color(0xFF022253),
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                      textAlign:
                                                      TextAlign.left,
                                                    ),
                                                  )),
                                            ],
                                          )),
                                      height: 50,
                                      width: _width,
                                    ),
                                    elevation: 5,
                                  ),),
                                ),visible:  true,),


                              ],
                              shrinkWrap: true,
                            ),
                            flex: 1,
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )),),
        resizeToAvoidBottomPadding: true);




  }

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Feedback'),

            content: Text(
                'Are you sure want to close meeting?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),

            actions: <Widget>[
              new RaisedButton(
                onPressed: (){

                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                        return new FeedBackMeeting(notes: lead_id,meetid: meting_id,);
                      }));

                },
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.lightGreen)
                ),
                padding: const EdgeInsets.all(8.0),
                textColor: Colors.white,
                color: Colors.lightGreen[400],
                child: new Text("Yes"),
              ),
              new RaisedButton(
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)
                ),
                padding: const EdgeInsets.all(8.0),
                textColor: Colors.white,
                color: Colors.redAccent[100],
                child: new Text("No"),
              )
            ],
          );
        });
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
}
