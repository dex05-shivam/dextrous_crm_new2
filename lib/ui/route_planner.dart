
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dextrous_crm_new2/ui/checkout_page.dart';
import 'package:dextrous_crm_new2/ui/feedbackPage.dart';
import 'package:dextrous_crm_new2/ui/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'checked_in_route.dart';



class ClientList extends StatefulWidget{
  @override
  _ClientListState createState() => new _ClientListState();
}

class _ClientListState extends State<ClientList>
{
  final String uri =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/client_list";

  bool isHomeDataLoading;

  String leads_tab="assets/images/leads1.png",status_tab="assets/images/status.png";

  int countValue=0;




  Future<List<Clients>> getToekn(String type) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/route/client_list";
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
        List<dynamic> dynamicList = decodedMap['result'];
        List<Clients> students = new List<Clients>();
        dynamicList.forEach((f) {
          Clients s = Clients.fromJson(f);
          students.add(s);
        });
        return students;
      } else {
        throw Exception("Internet Error");
      }
    } catch (e) {
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToekn('1');
    isHomeDataLoading = false;
  }
  Future<bool> _onBackPressed() {
    return Future.value(true);
  }
  setLoading(bool loading) {
    setState(() {
      isHomeDataLoading = loading;
    });
  }

  fetch() {
    setLoading(true);
  }

//  Future<bool> _onBackPressed() {
//    return
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) =>
//                ClientList(),
//          ));
//  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child:new Container(
              child: new Stack(
                children: <Widget>[

                  Container(
                    child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/map_background.jpg',
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
                            Expanded(
                              child: Text(
                                ' Route Planner',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xF3253F5A),
                                  fontSize: 20,
                                ),
                              ),
                              flex: 1,
                            ),
                            new IconButton(
                                icon: Icon(
                                  Icons.home,
                                  color: Color(0xF3253F5A),
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(
                                            ),
                                      ));
//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                                }),
                          ],
                        ),
                      ),
                      Flexible(
                        child: FutureBuilder<List<Clients>>(
                          future: getToekn('1'),
                          builder: (context, snapshot) {
                            return snapshot.connectionState == ConnectionState.done
                                ? snapshot.hasData
                                ? _ClientsCellState.homeGrid(snapshot, context)
                                : _ClientsCellState.retryButton(fetch)
                                : _ClientsCellState.circularProgress();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
        resizeToAvoidBottomPadding: true);
  }

}

class Clients {
  final String meting_id;
  final String subject;
  final String member;
  final String client_name;
  final String location;
  final String metting_date;
  final String metting_time;
  final String client_number;
  final String meeting_status;
  final String meeting_status_id;

  Clients({
    this.meting_id,
    this.subject,
    this.member,
    this.client_name,
    this.location,
    this.metting_date,
    this.metting_time,
    this.client_number,
    this.meeting_status,
    this.meeting_status_id,

  });

  factory Clients.fromJson(Map<String, dynamic> json) {
    return Clients(
      meting_id: json['meting_id'],
      subject: json['subject'],
      member: json['member'],
      client_name: json['client_name'],
      location: json['location'],
      metting_date: json['metting_date'],
      metting_time: json['metting_time'],
      client_number: json['client_number'],
      meeting_status: json['meeting_status'],
      meeting_status_id: json['meeting_status_id'],
    );
  }
}

class ClientsCell extends StatefulWidget {
  int countValue = 0;
  ClientsCell(this.cellModel);
  @required
  final Clients cellModel;

  @override
  _ClientsCellState createState() => _ClientsCellState(this.cellModel);
}

class _ClientsCellState extends State<ClientsCell> {
  int countValue = 0;
  _ClientsCellState(this.cellModel);
  @required
  final Clients cellModel;

  static Container homeGrid(AsyncSnapshot<List<Clients>> snapshot, context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height ,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return ClientsCell(
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
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightGreen),
      ),
    );
  }

  static FlatButton retryButton(Function fetch) {
    return FlatButton(
      child: Text(
        "No Internet",
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
          child: Container(
            child: Card(

              color: Color.fromRGBO(238, 254, 254, 0.9),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  side: BorderSide(width: 1.5, color: Color(0xF3253F5A))),



              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 4.0),
                      child: Row(children: <Widget>[
                        Text(!["", null, false, 0].contains(cellModel.subject)?cellModel.subject:'N/A',
                          style: new TextStyle(fontSize: 24.0,color: Color(0xF3253F5A),fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Row(children: <Widget>[
                        Text(!["", null, false, 0].contains(cellModel.client_name)?cellModel.client_name:'N/A', style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                        Spacer(),
                      ]),
                    ),
                    GestureDetector(child: Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(!["", null, false, 0].contains(cellModel.location)?cellModel.location:'N/A', style: new TextStyle(fontSize: 18.0,),)),
                          Spacer(),
                          Icon(Icons.location_on,color: Color(0xFFF88C9C),),
                          //Icon(Icons.directions_car),
                        ],
                      ),
                    ),onTap: (){
                      MapsLauncher.launchQuery(
                          cellModel.location);
                    },),


                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Row(
                        children: <Widget>[
                          Text(!["", null, false, 0].contains(cellModel.metting_date)?cellModel.metting_date:'N/A', style: new TextStyle(),),
                          Spacer(),
                          Icon(Icons.calendar_today,color:Color(0xFFF88C9C)),
                          Spacer(),


                          Text(!["", null, false, 0].contains(cellModel.metting_time)?cellModel.metting_time:'N/A', style: new TextStyle(),),
                          Spacer(),
                          Icon(Icons.access_time,color: Color(0xFFF88C9C),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration (
                                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                color: Colors.redAccent
                            ),
                            padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child:Text(!["", null, false, 0].contains(cellModel.meeting_status)?cellModel.meeting_status:'N/A',
                              style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),

                          Spacer(),


                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Row(
                        children: <Widget>[
                          Text(!["", null, false, 0].contains(cellModel.member)?cellModel.member:'N/A', style: new TextStyle(fontWeight: FontWeight.bold),),
                          Spacer(),

                          //Icon(Icons.location_on),
                        ],
                      ),
                    )
                  ],
                ),
              ),

            ),
          )
      ),
      onTap: () {
        // setState(() => countValue == 0 ? countValue = 1 : countValue = 0);
        // Grid Click
//        Navigator.of(context).pushNamed('/check_in');
//        MapsLauncher.launchQuery(
//            cellModel.location);
        if(cellModel.meeting_status_id=="checkedIn") {
          Navigator.of(context).push(MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return new Checkout(meetid: cellModel.meting_id,);
              })
          );
        }else{
          Navigator.of(context).push(MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return new MeetingOptions(meeting_id: cellModel.meting_id,status: cellModel.meeting_status,);
              })
          );
        }
      },
    );
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