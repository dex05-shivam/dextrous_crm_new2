import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/add_mettings.dart';
import 'package:dextrous_crm_new2/ui/expense_list.dart';
import 'package:dextrous_crm_new2/ui/meeting_details.dart';
import 'package:dextrous_crm_new2/ui/view_task.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';
import 'login_page.dart';

class MeetingList extends StatefulWidget {
  final DateTime initialDate;

  const MeetingList({Key key, this.initialDate}) : super(key: key);

  @override
  _MeetingListState createState() => new _MeetingListState();
}

class _MeetingListState extends State<MeetingList> {
  bool isResponse = false;

  final DateTime initialDate= DateTime.now();
  DateTime selectedDate;
  static List<int> numbers = new List<int>();


  List<String> month1 = ["JAN","FEB","MAR","APR","MAY","JUN","JLY","AUG","SEP","OCT","NOV","DEC"];

  final String uri =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/meetingsList";

  bool isHomeDataLoading;

  double myInt;


  String leads_tab = "assets/images/leads1.png",
      status_tab = "assets/images/status.png";

  int countValue = 0;



  var now = new DateTime.now();
  String monthS='',date,year='',month2=DateTime.now().month.toString(),year2=DateTime.now().year.toString(),date2=DateTime.now().day.toString();

  setLoading(bool loading) {

    setState(() {

      isHomeDataLoading = loading;
    });
  }



  fetch() {
    setLoading(true);
  }





  Future<List<Meetings>> getToekn(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();





    print('datecur'+type);
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/meetingsList";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.get('user_token'),
      "date": type,
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
        List<dynamic> dynamicList = decodedMap['meetings'];
        List<Meetings> students = new List<Meetings>();
        dynamicList.forEach((f) {
          Meetings s = Meetings.fromJson(f);
          students.add(s);
        });
        return students;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }


  Future<List<Meetings>> getMeeting(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();





    print('dateonchange'+type);
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/meetingsList";
    FormData formData = new FormData.from({
      "userId": '2',
      "token": '55cf20552bd5ee24b49ed65bd69989a0',
      "date": type,
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
        List<dynamic> dynamicList = decodedMap['meetings'];
        List<Meetings> students = new List<Meetings>();
        dynamicList.forEach((f) {
          Meetings s = Meetings.fromJson(f);
          students.add(s);
        });
        return students;
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
  void initState() {
    super.initState();

    myInt = double.parse(date2);
    assert(myInt is double);

    print("list"+myInt.toString());

    selectedDate = widget.initialDate;

    print(monthS);

    if(countValue==0){
      for(var i = 0 ; i< month1.length ;i++){
        //print("as"+monthS);
        if(i+1==now.month){
          print("bs"+now.month.toString());
          monthS = now.day.toString()+" "+ month1[i]+", "+now.year.toString();
        }

      }
    }

    if(now.month==4||now.month==6||now.month==9||now.month==11){
      numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];
      print("numbers lenght"+numbers.length.toString());
    }

    if(now.month==1||now.month==3||now.month==5||now.month==7||now.month==12){
      numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
      print("numbers lenght"+numbers.length.toString());
    }

    if(now.month==2){
      numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28];
      print("numbers lenght"+numbers.length.toString());
    }


  }
  Future<bool> _onBackPressed() {
    Navigator.pop(context);
    Navigator.of(context).push(
        MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new HomePage();
        }));

  }
  String dropdownValue = 'Select Month';
  String dropdownValue1 = 'Select Year';
  Color color=HexColor('FFC0CB');
  //String dropdownValue = 'Select Month';
  @override
  Widget build(BuildContext context) {


    var controller = IndexedScrollController(
        initialIndex: DateTime.now().day-4,
        );
    return MaterialApp(
        localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
        Locale('en'),
    Locale('zh'),
    Locale('fr'),
    Locale('es'),
    Locale('de'),
    Locale('ru'),
    Locale('ja'),
    Locale('ar'),
    Locale('fa'),
    ],
    theme: ThemeData(
    primarySwatch: Colors.indigo, accentColor: Colors.pinkAccent),
    home:Scaffold(
        body: WillPopScope(
    onWillPop: _onBackPressed,
    child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                                  return new HomePage();
                                })
                            );
                          }),
                      Flexible(
                        child: Center(
                          child: Text(
                            ' Meetings And Calls',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Padding(child:new IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.redAccent,
                            size: 40,
                          ),
                          onPressed: () {

                            Navigator.of(context).push(
                                MaterialPageRoute<Null>(builder: (BuildContext context) {
                                  return new AddMettings();
                                }));
//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                          }) ,
                      padding:  const EdgeInsets.fromLTRB(0, 0, 5, 0),)
                      ,
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                      child: new Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 5.0, 10, 0),
                                    child: Text(
                                      monthS,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                GestureDetector(child:Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 5.0, 10, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 0, 0, 0),
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey[700],
                                      ),
                                    )) ,
                                onTap: (){
                                  showMonthPicker(
                                      context: context,
                                      firstDate: DateTime(DateTime.now().year - 2, 0),
                                      lastDate: DateTime(DateTime.now().year + 2, 12),
                                      initialDate: selectedDate ?? widget.initialDate)
                                      .then((date) {
                                    if (date != null) {
                                      setState(() {
                                        countValue=1;
                                        selectedDate = date;
                                        for(var i = 0 ; i< month1.length ;i++){
                                          //print("as"+monthS);
                                          if(i+1==selectedDate?.month){
                                            print("bs"+now.month.toString());
                                            monthS = now.day.toString()+" "+ month1[i]+",${selectedDate?.year} ";
                                          }

                                        }
                                        month2=selectedDate?.month.toString();
                                        year2=selectedDate?.year.toString();

                                        print(now.day.toString()+','+date.month.toString()+date.year.toString());
                                       // monthS=now.day.toString()+',${selectedDate?.year}';
                                      });
                                    }
                                  });


                                },),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.grey),
                                width: double.infinity,
                                height: 0.5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Container(
                                height: 50,

                                child: IndexedListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    controller: controller,
                                    reverse: false,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        child: GestureDetector(child: Card(
                                          color: numbers[index]==int.parse(date2)?color: Colors.white ,
                                          child: Container(
                                            child: Center(
                                                child: Text(
                                                  index<31?numbers[index].toString():"NA",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0),
                                                )),
                                          ),
                                        ),
                                        onTap: (){
                                          date2=numbers[index].toString();
                                          setState(() {
                                            date2=numbers[index].toString();
                                            for(var i = 0 ; i< month1.length ;i++){
                                              //print("as"+monthS);
                                              if(i+1==selectedDate?.month){
                                                print("bs"+now.month.toString());
                                                monthS = date2+" "+ month1[i]+",${selectedDate?.year} ";
                                              }

                                            }
                                            getToekn(year2+'-'+month2+'-'+date2);
                                          });

                                          print(date2);
                                        },),
                                      );
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.grey),
                                width: double.infinity,
                                height: 0.5,
                              ),
                            ),
                            Flexible(
                              child: FutureBuilder<List<Meetings>>(
                                future: getToekn(year2+'-'+month2+'-'+date2),
                                builder: (context, snapshot) {
                                  return snapshot.connectionState ==
                                          ConnectionState.done
                                      ? snapshot.hasData
                                          ? _MeetingsCellState.homeGrid(
                                              snapshot, context)
                                          : _MeetingsCellState.retryButton(
                                              fetch)
                                      : _MeetingsCellState.circularProgress();
                                },
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
//                        image: DecorationImage(
//                          image: AssetImage("assets/images/card_background.png"),
//                          fit: BoxFit.fill,
//
//                        ),
                            color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            image: DecorationImage(
              image: AssetImage("assets/images/login_back.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),),
        resizeToAvoidBottomPadding: false));
  }
}

class Meetings {
  String meetid;
  String lead_id;
  String subject;
  String sdate, stime, edate, etime, clientName, meet_status, address, number,meeting_type,today_meeting;

  Meetings({
    this.meetid,
    this.lead_id,
    this.subject,
    this.sdate,
    this.stime,
    this.edate,
    this.etime,
    this.clientName,
    this.meet_status,
    this.address,
    this.number,
    this.meeting_type,
    this.today_meeting,
  });

  factory Meetings.fromJson(Map<String, dynamic> json) {
    return Meetings(
      meetid: json['meetid'],
      lead_id: json['lead_id'],
      subject: json['subject'],
      sdate: json['sdate'],
      stime: json['stime'],
      edate: json['edate'],
      etime: json['etime'],
      clientName: json['clientName'],
      meet_status: json['meet_status'],
      address: json['address'],
      number: json['number'],
      meeting_type: json['meeting_type'],
      today_meeting: json['today_meeting'],
    );
  }
}

class MeetingsCell extends StatefulWidget {

  MeetingsCell(this.cellModel);
  @required
  final Meetings cellModel;

  @override
  _MeetingsCellState createState() => _MeetingsCellState(this.cellModel);
}

class _MeetingsCellState extends State<MeetingsCell> {

  _MeetingsCellState(this.cellModel);
  @required
  final Meetings cellModel;

  static Container homeGrid(AsyncSnapshot<List<Meetings>> snapshot, context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return MeetingsCell(
            snapshot.data[index],
          );
        },
      ),
    );
  }

  static SizedBox circularProgress() {
    return SizedBox(
      height: 50.0,
      width: 50.0,
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(COLORS.APP_THEME_COLOR),
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
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: new BorderRadius.circular(16.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 5, 5, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                                  child: Text(!["", null, false, 0].contains(cellModel.clientName)?cellModel.clientName:"No Name Available"
                                    ,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                flex: 1,
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Image.asset(cellModel.meeting_type=="0" ?
                                    'assets/images/meting.png' : 'assets/images/call.png',
                                    height: 30,
                                    width: 70,
                                    fit: BoxFit.fill,
                                  )),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child:

                                       Text(
                                            !["", null, false, 0]
                                                    .contains(cellModel.address)
                                                ? cellModel.address
                                                : "Not available",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[800])),



                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 5, 0, 0),
                                        child: Icon(
                                          Icons.av_timer,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4.0, 0, 0, 0),
                                        child: Text(!["", null, false, 0].contains(cellModel.stime)?cellModel.sdate+', '+ cellModel.stime : "No time available",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                ),
                                flex: 1,
                              ),
                              GestureDetector(
                                child:
                              Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Image.asset(
                                    cellModel.meeting_type=="0" ?'assets/images/go.png' : 'assets/images/callsa.png',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  )),
                                  onTap: () {

                                    if(cellModel.meeting_type=="0") {

                                      if(cellModel.today_meeting=="1") {
                                        MapsLauncher.launchQuery(
                                            cellModel.address);
                                      }

                                      if(cellModel.today_meeting=="0") {

                                      }
                                    }
                                    if(cellModel.meeting_type=="1") {
                                      _callPhone('tel:'+cellModel.number);
                                    }

                                  })
                            ],
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
          )),
      onTap: () {

        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new MeetingDetails(
            text: cellModel.meetid,
          );
        }));
      },
    );
  }
  _callPhone(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
