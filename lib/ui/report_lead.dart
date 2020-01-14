import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/attandence_report.dart';
import 'package:dextrous_crm_new2/ui/filter_report.dart';
import 'package:dextrous_crm_new2/ui/report_dash.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportLead extends StatefulWidget {

  String start_date,end_date;

  ReportLead({Key key, @required this.start_date, this.end_date}) : super(key: key);

  @override
  _ReportLeadState createState() => new _ReportLeadState(start_date: start_date,end_date: end_date);
}

class _ReportLeadState extends State<ReportLead> {


  String start_date,end_date;

  _ReportLeadState({ @required this.start_date, this.end_date}) : super();


  Future<List<LeadsReport>> getToekn(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/report/leads_report";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.get('user_token'),
      "startDate" : !["", null, false, 0].contains(start_date)?start_date:'',
      "endDate" : !["", null, false, 0].contains(end_date)?end_date:'',
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
        List<LeadsReport> students = new List<LeadsReport>();
        dynamicList.forEach((f) {
          LeadsReport s = LeadsReport.fromJson(f);
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


  bool isResponse = false;

  bool isHomeDataLoading = false;
  final TextEditingController _feedback = new TextEditingController();

  Future<bool> _onBackPressed() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: WillPopScope(onWillPop:_onBackPressed,
          child: Container(
          child:  Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,30),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReportsOne(
                                      ),
                                ));
                          }),
                      Flexible(
                        child: Center(
                          child: Text(
                            'Lead Reports',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      new IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilterReport(start_date: '',end_date: '',type:'lead',
                                  ),
                                ));

//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                          }),
                    ],
                  ),
                ),

                Expanded(child:   Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),child:
                Container(child: FutureBuilder<List<LeadsReport>>(
                  future: getToekn('1'),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.done
                        ? snapshot.hasData
                        ? _LeadsReportCellState.homeGrid(snapshot, context)
                        : _LeadsReportCellState.retryButton(fetch)
                        : _LeadsReportCellState.circularProgress();
                  },
                ),
                  color: Colors.white,height: size.height,),),flex: 1,)



              ],
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              color: Colors.lightBlue[50]
          ),
        ),),

        resizeToAvoidBottomPadding: false);
  }
}
class LeadsReport {
  String lead_id;
  String lead;
  String count;
  //String task_status, startdate, duedate;

  LeadsReport({
    this.lead_id,
    this.lead,
    this.count,
  });

  factory LeadsReport.fromJson(Map<String, dynamic> json) {
    return LeadsReport(
      lead_id: json['lead_id'],
      lead: json['lead'],
      count: json['count'],

//      expense_name: json['expense_name'],
//      date: json['date'],
//      time: json['time'],
//      category_name: json['category_name'],
    );
  }
}

class LeadsReportCell extends StatefulWidget {
  int countValue = 0;
  LeadsReportCell(this.cellModel);
  @required
  final LeadsReport cellModel;

  @override
  _LeadsReportCellState createState() => _LeadsReportCellState(this.cellModel);
}

class _LeadsReportCellState extends State<LeadsReportCell> {
  int countValue = 0;
  _LeadsReportCellState(this.cellModel);
  @required
  final LeadsReport cellModel;

  static Container homeGrid(AsyncSnapshot<List<LeadsReport>> snapshot, context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height ,
      width: double.infinity,
      child: Padding(padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child:GridView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: LeadsReportCell(snapshot.data[index]),
            onTap: () {},
          );
        },
      ) ,)
    );
  }

  static Center circularProgress() {
    return Center(
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
      child: Padding(padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),child: Card(
        color: Colors.lightBlue[100],
        child: Center(
          child: Container(
            child: Column(
                mainAxisSize:
                MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment
                    .center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/new_f.png',height: 30,width: 30,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,3,0,0),
                    child: Center(
                      child: Text(!["", null, false, 0].contains(cellModel.count)?
                        cellModel.count : "0",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w900
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    child: Center(
                      child: Text(
                        !["", null, false, 0].contains(cellModel.lead)?
                        cellModel.lead : "NA"
                        ,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w900
                        ),

                      ),
                    ),
                  )


                ]),
            height: 100,


          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(8.0),
        ),
        elevation: 10,
      ),),
      onTap: () {
        // setState(() => countValue == 0 ? countValue = 1 : countValue = 0);
        // Grid Click

//        Navigator.of(context).push(MaterialPageRoute<Null>(
//            builder: (BuildContext context) {
//              return new TaskDetails(text: cellModel.id,);
//            }));
      },
    );
  }
}