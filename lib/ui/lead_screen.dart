import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/new_lead.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'leads_details.dart';



class LeadScreen extends StatefulWidget {

  final String text,text2,text3;

  LeadScreen({Key key, @required this.text, @required this.text2,this.text3}) : super(key: key);

  @override
  _LeadScreenState createState() => new _LeadScreenState(text: text,text2: text2,text3: text3);
}

class _LeadScreenState extends State<LeadScreen> {
  final String text,text2,text3;

  _LeadScreenState({Key key, @required this.text, @required this.text2,this.text3}) : super();

  final String uri =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/leadList";

  bool isHomeDataLoading;

  String leads_tab="assets/images/leads1.png",status_tab="assets/images/status.png";

  int countValue=0;


  Future<List<Leads>> getToekn(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/leadList";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.get('user_token'),
      "type": type,
      "today_assign" :text,
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
        List<Leads> students = new List<Leads>();
        dynamicList.forEach((f) {
          Leads s = Leads.fromJson(f);
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
    // TODO: implement initState
    super.initState();
    getToekn('1');
    isHomeDataLoading = false;
  }

  setLoading(bool loading) {
    setState(() {
      isHomeDataLoading = loading;
    });
  }

  fetch() {
    setLoading(true);
  }
  Future<bool> _onBackPressed() {
    return
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyHomePage(

                ),
          ));
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: WillPopScope(
        onWillPop: _onBackPressed,
        child: new Container(
            child: new Stack(
          children: <Widget>[
            Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/backgrounddashboard.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: size.width,
            ),
             ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyHomePage(

                                        ),
                                  ));

                          }),
                      Flexible(
                        child: Center(
                          child: Text(
                            text2,
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
                            Icons.add_box,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNewLead(),
                                ));

//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                          }
                          ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 40, 40, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible( child:GestureDetector(
                        onTap: () {
                          setState(() {

                            leads_tab="assets/images/leads1.png";
                            status_tab="assets/images/status.png";
                            countValue=1;
                            getToekn('1');

                          }  );
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ForgotPasswordApp()),
//                );
                        },

                        child: new Image.asset(
                          leads_tab,
                          width: 100,
                          height: 40,
                        ),
                      ),
                        flex: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,3,0,0),
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

                              leads_tab="assets/images/leads2.png";
                              status_tab="assets/images/status_click.png";
                              countValue=0;
                              getToekn('2');

                            }  );
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ForgotPasswordApp()),
//                );
                          },
                          child: new Image.asset(
                            status_tab,
                            width: 100,
                            height: 40,
                          ),

                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),

                Container(
                  child: FutureBuilder<List<Leads>>(
                    future: getToekn('1'),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? snapshot.hasData
                          ? _LeadsCellState.homeGrid(snapshot, context)
                          : _LeadsCellState.retryButton(fetch)
                          : _LeadsCellState.circularProgress();
                    },
                  ),
                ),
              ],
            ),
          ],
        ))),
        resizeToAvoidBottomPadding: true);
  }
}

class Leads {
  String leadId;
  String name;
  String designation;
  String country, color, status, leads_customer_type, leads_lead_for;

  Leads({
    this.leadId,
    this.name,
    this.designation,
    this.country,
    this.color,
    this.status,
    this.leads_customer_type,
    this.leads_lead_for,
  });

  factory Leads.fromJson(Map<String, dynamic> json) {
    return Leads(
      leadId: json['leadId'],
      name: json['name'],
      designation: json['designation'],
      country: json['country'],
      color: json['color'],
      status: json['status'],
      leads_customer_type: json['leads_customer_type'],
      leads_lead_for: json['leads_lead_for'],
    );
  }
}

class LeadsCell extends StatefulWidget {
  int countValue = 0;
  LeadsCell(this.cellModel);
  @required
  final Leads cellModel;

  @override
  _LeadsCellState createState() => _LeadsCellState(this.cellModel);
}

class _LeadsCellState extends State<LeadsCell> {
  int countValue = 0;
  _LeadsCellState(this.cellModel);
  @required
  final Leads cellModel;

  static Container homeGrid(AsyncSnapshot<List<Leads>> snapshot, context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 1.3,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return LeadsCell(
            snapshot.data[index],
          );
        },
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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

  void _sendDataToSecondScreen(BuildContext context) {
    String textToSend = cellModel.leadId;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeadDetails(text: textToSend,),
        ));
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
    Color color2 = HexColor(cellModel.color);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0,10,18,0),
            child: Card(elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: new BorderRadius.circular(18.0)),height: 100,)
            ),
          ),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.png"),
                    fit: BoxFit.fill,

                  ),

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
                      padding: const EdgeInsets.all(4.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                            child: Text(
                              !["", null, false, 0].contains(cellModel.name)?cellModel.name:"NA",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5),
                            child: Text(
                              !["", null, false, 0].contains(cellModel.country)?cellModel.country:"NA",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text(!["", null, false, 0].contains(cellModel.leads_lead_for)?cellModel.leads_lead_for:"NA",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey)),flex: 1,),

                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 0, 5, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.brightness_1,
                                        size: 15,
                                        color: color2,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(4.0, 12, 0, 0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[

                                            Text(!["", null, false, 0].contains(cellModel.status)?cellModel.status:"NA",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: color2)),
                                            Text('Priority',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                flex: 0,
                              )
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
              height: 100,
            ),
          )
        ],)
      ),
      onTap: () {
       // setState(() => countValue == 0 ? countValue = 1 : countValue = 0);
        // Grid Click

//        Navigator.of(context).push(MaterialPageRoute<Null>(
//            builder: (BuildContext context) {
//              return new LeadDetailsHomePage();
//            }));
        _sendDataToSecondScreen(context);
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
