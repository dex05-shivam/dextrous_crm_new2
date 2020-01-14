import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/add_reminder.dart';
import 'package:dextrous_crm_new2/ui/expense_list.dart';
import 'package:dextrous_crm_new2/ui/reminder_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_comments_screen.dart';
import 'change_lead_status.dart';
import 'edit_comments.dart';
import 'lead_screen.dart';



class LeadDetailsHomePage extends StatelessWidget {
  final String text;

  LeadDetailsHomePage({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Dextrous CRM',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LeadDetails(text: text,),
    );
  }
}

class LeadDetails extends StatefulWidget {
  final String text;

  LeadDetails({Key key, @required this.text}) : super(key: key);
  @override
  _LeadDetailsState createState() => new _LeadDetailsState(text: text);
}

class _LeadDetailsState extends State<LeadDetails> {
  final String text;

  _LeadDetailsState({@required this.text}) : super();
  final String uri =
      "http://ems.dextrousinfosolutions.com/dexcrm/api/leads/leadList";

  String leads_tab = "assets/images/leads1.png",
      status_tab = "assets/images/status.png";

  int countValue = 1;

  bool isHomeDataLoading = false;

  String leadId,
      name,
      email,
      phonenumber,
      designation,
      website,
      company,
      address,
      summary,
      country,
      color,
      leads_skype_id,
      leads_mobile_number,
      leads_whapapp_number,
      leads_customer_type,
      leads_price,
      leads_subject,
      leads_lead_for;

  String contact_on = "assets/images/contact-on.png",
      summary_off = "assets/images/summary-off.png",
      comment_off = "assets/images/comment-off.png";

  void getToekn(String type) async {
    isHomeDataLoading = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/leadDetail";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "leadId": text,
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
        leadId = body['leadId'];
        name = body['name'];
        email = body['email'];
        phonenumber = body['phonenumber'];
        designation = body['designation'];
        website = body['website'];
        company = body['company'];
        address = body['address'];
        summary = body['summary'];
        country = body['country'];
        color = body['color'];

        // status=body['status'];
        leads_skype_id = body['leads_skype_id'];
        leads_mobile_number = body['leads_mobile_number'];
        leads_whapapp_number = body['leads_whapapp_number'];
        leads_customer_type = body['leads_customer_type'];
        leads_price = body['leads_price'];
        leads_subject = body['leads_subject'];
        leads_lead_for = body['leads_lead_for'];
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

  void getToekn3(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/leadDetail";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "leadId": text,
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
        leadId = body['leadId'];

        phonenumber = body['phonenumber'];

        website = body['website'];
        company = body['company'];
        address = body['address'];
        color = body['color'];

        // status=body['status'];
        leads_skype_id = body['leads_skype_id'];
        leads_mobile_number = body['leads_mobile_number'];
        leads_whapapp_number = body['leads_whapapp_number'];
        leads_customer_type = body['leads_customer_type'];
        leads_price = body['leads_price'];
        leads_subject = body['leads_subject'];
        leads_lead_for = body['leads_lead_for'];

      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  void getToekn1(String type) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/leadDetail";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "leadId": text,
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
        leadId = body['leadId'];

        summary = body['summary'];

      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }

//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  void _sendDataToSecondScreen(BuildContext context) {
    String textToSend = text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddComments(text: textToSend,),
        ));
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


    return Future.value(true);

  }
  Future<List<Notes>> getToekn2(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/leadDetail";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "leadId": text,
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
        List<dynamic> dynamicList = decodedMap['notes'];
        List<Notes> students = new List<Notes>();
        dynamicList.forEach((f) {
          Notes s = Notes.fromJson(f);
          students.add(s);
        });
        return students;
      } else {
        print('exception'+MESSAGES.INTERNET_ERROR);
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print('exception'+e.toString());
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countValue = 1;
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
                                      Navigator.of(context).push(MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return new LeadScreen(text: "",text2: "Leads",text3: "",);
                                          }));

                                    }),
                                Flexible(
                                  child: Center(
                                    child: Text(
                                      'Leads',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                new IconButton(
                                    icon: Icon(
                                      Icons.notifications_active,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                                    }),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25.0, 10, 25, 10),
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
                                            height: 80,
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
                                                        leads_lead_for == ''
                                                            ? 'not available'
                                                            : leads_lead_for,
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
                                                        name == ''
                                                            ? 'not available'
                                                            : name,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(email,
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
                                            new IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.pinkAccent,
                                                  size: 30,
                                                ),
                                                onPressed: () {


                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => EditPage(meetid: text,),
                                                      ));
//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                                                }),
                                            new IconButton(
                                                icon: Icon(
                                                  Icons.notification_important,
                                                  color: Colors.blueGrey,
                                                  size: 30,
                                                ),
                                                onPressed: () {


                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => AddNewReminder(text: text,text2: '',),
                                                      ));
//
//                                                 /* Navigator.push(
//                                                      context,
//                                                      MaterialPageRoute(
//                                                        builder: (context) => Reminder(text: text,),
//                                                      ));*/
//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                                                }),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25.0, 10, 25, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        contact_on = "assets/images/contact-on.png";
                                        summary_off =
                                            "assets/images/summary-off.png";
                                        comment_off =
                                            "assets/images/comment-off.png";
                                        countValue = 1;
                                        getToekn3('1');
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
                                  padding: const EdgeInsets.fromLTRB(0.0, 3, 0, 0),
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
                                        contact_on =
                                            "assets/images/contact-off.png";
                                        summary_off =
                                            "assets/images/summary-on.png";
                                        comment_off =
                                            "assets/images/comment-off.png";
                                        countValue = 2;
                                        getToekn1('2');
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
                                  padding: const EdgeInsets.fromLTRB(0.0, 3, 0, 0),
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
                                        contact_on =
                                            "assets/images/contact-off.png";
                                        summary_off =
                                            "assets/images/summary-off.png";
                                        comment_off =
                                            "assets/images/comment-on.png";
                                        countValue = 3;
                                        getToekn2('2');
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
                          countValue == 1
                              ? new Flexible(
                                  child: new ListView(
                                    children: <Widget>[
                                      Visibility(child:Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: GestureDetector(onTap: (){
                                          _callPhone('tel:'+phonenumber);

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
                                                            phonenumber == ""
                                                                ? 'No number available'
                                                                : phonenumber,
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
                                      ) ,visible: phonenumber == "" ? false : true,),
                                      Visibility(child:Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child:GestureDetector(onTap: (){
                                         _launchURL(website);

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
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/website.png',
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Expanded(child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10.0, 0, 0, 0),
                                                      child:  new Text(
                                                        website == ""
                                                            ? 'No website available'
                                                            : website,
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
                                      ),visible: website == "" ? false : true,),
                                      Visibility(child:Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: GestureDetector(onTap: (){
                                          MapsLauncher.launchQuery(address);

                                        },child: new Card(
                                          child: new Container(
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                Visibility(child:Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/company.png',
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                        Expanded(child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              10.0, 5, 0, 0),
                                                          child: new Text(
                                                            company == ""
                                                                ? 'No company available'
                                                                : company,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF022253),
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                            ),
                                                            textAlign:
                                                            TextAlign.left,
                                                          ),
                                                        )),
                                                      ],
                                                    ),visible: company==""? false : true,),
                                                    Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(0, 5, 0, 0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
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
                                                                    child: Center(
                                                                      child: new Text(
                                                                        address == ""
                                                                            ? 'No address available'
                                                                            : address,
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
                                                                    ), width: _width)),)

                                                          ],
                                                        ))
                                                  ],
                                                )),

                                            width: _width,
                                          ),
                                          elevation: 5,
                                        ),),
                                      ),visible: address == "" ? false : true,),
                                      Visibility(child:Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: GestureDetector(onTap: (){
                                          _callPhone(leads_mobile_number);

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
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/mobilenumber.png',
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            10.0, 0, 0, 0),
                                                        child: Center(
                                                          child: new Text(
                                                            leads_mobile_number ==
                                                                ""
                                                                ? 'No mobile available'
                                                                : leads_mobile_number,
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
                                      ),visible: leads_mobile_number == "" ? false : true,),
                                      Visibility(child:Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: new Card(
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
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/skype.png',
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            10.0, 0, 0, 0),
                                                        child: Center(
                                                          child: new Text(
                                                            leads_mobile_number ==
                                                                ""
                                                                ? 'No skype available'
                                                                : leads_mobile_number,
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
                                        ),
                                      ),visible: leads_skype_id == "" ? false : true,),
                                      Visibility(child:Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: new Card(
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
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/whasapp.png',
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            10.0, 0, 0, 0),
                                                        child: Center(
                                                          child: new Text(
                                                            leads_whapapp_number ==
                                                                ""
                                                                ? 'No whats app available'
                                                                : leads_whapapp_number,
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
                                        ),
                                      ),visible: leads_whapapp_number == "" ? false : true,),


                                    ],
                                    shrinkWrap: true,
                                  ),
                                  flex: 1,
                                )
                              : SingleChildScrollView(
                                  child: countValue == 2
                                      ? new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  20, 0, 20, 0),
                                              child: new Card(
                                                child: new Container(
                                                  child:
                                                  ["", null, false, 0].contains(summary)?Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child: Text(
                                                        'No Summary Available',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      )
                                                  ):
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        child: SingleChildScrollView(
                                                          child: Html(
                                                            data: summary,
                                                            onLinkTap: (url) {
                                                              print("Opening $url...");
                                                            },
                                                          ),
                                                        )
                                                      ),

                                                  height: _height / 2,
                                                  width: _width,
                                                ),
                                                elevation: 5,
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
                                              padding: const EdgeInsets.fromLTRB(
                                                  20, 0, 20, 0),
                                              child:  new Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      child: FutureBuilder<
                                                          List<Notes>>(
                                                        future: getToekn2('1'),
                                                        builder:
                                                            (context, snapshot) {
                                                          return snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .done
                                                              ? snapshot.hasData
                                                                  ? _NotesCellState
                                                                      .homeGrid(
                                                                          snapshot,
                                                                          context,text)
                                                                  : _NotesCellState
                                                                      .retryButton(
                                                                          fetch)
                                                              : _NotesCellState
                                                                  .circularProgress();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  height: _height / 2,
                                                  width: _width,
                                                ),

                                            ),
                                            new Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                                child:new Card(
                                                child: new GestureDetector(
                                                  onTap: () {
                                                    print("Container clicked");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddComments(text: text,text2: '',),
                                            ));
                                                  },
                                                  child: new Container(
                                                    child: Center(
                                                      child: new Text(
                                                        'Add Notes',
                                                        style: TextStyle(
                                                          color: Color(0xFFFFFFFF),
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    height: 50,
                                                    width: _width,
                                                  ),
                                                ),
                                                color: Color(0xFFf79020),
                                                elevation: 5,
                                              ),),
                                              flex: 0,
                                            ),
                                          ],
                                        )),
                        ],
                      ),
              ),
            ),
          ],
        )),),
        resizeToAvoidBottomPadding: true);
  }
}

class Notes {
  String noteId;
  String added_by;
  String label_id;
  String label_name, description;

  Notes({
    this.noteId,
    this.added_by,
    this.label_id,
    this.label_name,
    this.description,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      noteId: json['noteId'],
      added_by: json['added_by'],
      label_id: json['label_id'],
      label_name: json['label_name'],
      description: json['description'],
    );
  }
}

class NotesCell extends StatefulWidget {
  int countValue = 0;
  NotesCell(this.cellModel,this.text);
  @required
  final Notes cellModel;
  String text;

  @override
  _NotesCellState createState() => _NotesCellState(this.cellModel,this.text);
}

class _NotesCellState extends State<NotesCell> {
  int countValue = 0;
  String text;
  _NotesCellState(this.cellModel,this.text);
  @required
  final Notes cellModel;

  static Container homeGrid(AsyncSnapshot<List<Notes>> snapshot, context,text) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 1.3,
      width: double.infinity,
      child: snapshot.data.length > 0 ?ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        itemBuilder: (BuildContext context, int index) {
          return NotesCell(
            snapshot.data[index],text
          );
        },
      ) : Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(16.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//                      Flexible(
//                        child: Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: new Image.asset(
//                            'assets/images/profile.png',
//                            width: 60,
//                            height: 60,
//                            fit: BoxFit.fill,
//                          ),
//                        ),
//                        flex: 0,
//                      ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                        child: Text(
                          ' No Data Available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
//                              Padding(
//                                padding:
//                                const EdgeInsets.fromLTRB(0, 5.0, 0, 5),
//                                child: SingleChildScrollView(
//                                  child: Html(
//                                    data: cellModel.description,
//                                    padding: EdgeInsets.all(8.0),
//                                    onLinkTap: (url) {
//                                      print("Opening $url...");
//                                    },
//                                  ),
//                                ),
//                              ),
//                              Text(cellModel.label_name,
//                                  style: TextStyle(
//                                      fontSize: 10,
//                                      fontWeight: FontWeight.w700,
//                                      color: Colors.grey)),
                    ],
                  ),
                ),
                flex: 2,
                fit: FlexFit.tight,
              ),
            ],
          ),
        ),
      ),
    );
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
  static FlatButton retryButton(Function fetch) {
    return FlatButton(
      child: Text(
        MESSAGES.INTERNET_ERROR_RETRY,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      onPressed: () => fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Color color2 = HexColor(cellModel.color);
    return GestureDetector(
      child: Padding(
          padding: const EdgeInsets.all(0),
          child: Stack(
            children: <Widget>[
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(16.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/profile.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.fill,
                          ),
                        ),
                        flex: 0,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child:Text(
                                      cellModel.added_by,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ) ,flex: 1,)
                                    ,
                                   Visibility(child:  Align(
                                     alignment: Alignment.topRight,
                                     child:Row(
                                       mainAxisAlignment: MainAxisAlignment.end,
                                       crossAxisAlignment:
                                       CrossAxisAlignment.end,
                                       mainAxisSize: MainAxisSize.min,
                                       children: <Widget>[
                                         Padding(
                                           padding: const EdgeInsets.fromLTRB(0,0,5,0),
                                           child: GestureDetector(
                                             onTap: () {
                                               Navigator.push(
                                                   context,
                                                   MaterialPageRoute(
                                                     builder: (context) =>
                                                         AddComments(
                                                           text: text,
                                                           text2: cellModel.noteId,
                                                         ),
                                                   ));
                                             },
                                             child: Image.network(
                                               'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/writing.png',
                                               height: 15,width: 15,),
                                           ),
                                         ),
                                         GestureDetector(
                                           onTap: () {


                                           },
                                           child: Image.network(
                                             'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/delete.png',
                                             height: 15,width: 15,),
                                         ),
                                       ],
                                     ),),visible: false,)
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 5.0, 0, 5),
                                child: SingleChildScrollView(
                                  child: Html(
                                    data: cellModel.description,
                                    onLinkTap: (url) {
                                      print("Opening $url...");
                                    },
                                  ),
                                ),
                              ),

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

//        Navigator.of(context).push(MaterialPageRoute<Null>(
//            builder: (BuildContext context) {
//              return new LeadDetailsHomePage();
//            }));
      },
    );
  }
}
