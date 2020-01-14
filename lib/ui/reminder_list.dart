import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/view_task.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_button/toggle_button.dart';

import 'add_expense.dart';
import 'add_reminder.dart';
import 'home_screen.dart';
import 'leads_details.dart';


class Reminder extends StatefulWidget {

  final String text;

  Reminder({Key key, @required this.text}) : super(key: key);

  @override
  _ReminderState createState() => new _ReminderState(text: text);
}

class _ReminderState extends State<Reminder> {
  final String text;

  _ReminderState({Key key, @required this.text}) : super();

  final String uri =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/taskList";

  bool isHomeDataLoading;

  String leads_tab="assets/images/leads1.png",status_tab="assets/images/status.png";

  int countValue=0;


  Future<List<Leads>> getToekn(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/taskList";
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
        List<dynamic> dynamicList = decodedMap['taskList'];
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
    isSelected = [true, false];
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
  List<bool> isSelected;
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
          child:new Container(
              child: new Stack(
                children: <Widget>[
                  Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/login_back.png',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: size.width,
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
                                  'Reminder',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),


                            IconButton(icon: Icon(Icons.add_box,size: 30,color: Colors.white,),onPressed: ()
                            {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                    builder: (context) =>
//                                        AddNewReminder(),
//                                  ));

                            },)


                          ],
                        ),
                      ),



                      Row(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[


                        Text('Auto Send Mail : ',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),
                        ),
                       SizedBox(child:  ToggleButtons(

                         borderWidth: 3,
                         selectedBorderColor: Colors.green,
                         selectedColor: Colors.green,
                         borderRadius: BorderRadius.circular(50),
                         borderColor: Colors.redAccent,
                         color: Colors.redAccent,


                         children: <Widget>[
                           Icon(Icons.edit_attributes),
                           Icon(Icons.tonality),
                         ],
                         onPressed: (int index) {
                           setState(() {
                             for (int i = 0; i < isSelected.length; i++) {
                               if (i == index) {
                                 isSelected[i] = true;
                               } else {
                                 isSelected[i] = false;
                               }
                             }
                           });
                         },
                         isSelected: isSelected,
                       ),height: 30,)
                      ],),

                      Flexible(
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
              )),),
        resizeToAvoidBottomPadding: true);
  }
}

class Leads {
  String id;
  String name;
  String priority;
  String task_status, startdate, duedate;

  Leads({
    this.id,
    this.name,
    this.priority,
    this.task_status,
    this.startdate,
    this.duedate,
  });

  factory Leads.fromJson(Map<String, dynamic> json) {
    return Leads(
      id: json['id'],
      name: json['name'],
      priority: json['priority'],
      task_status: json['task_status'],
      startdate: json['startdate'],
      duedate: json['duedate'],
//      expense_name: json['expense_name'],
//      date: json['date'],
//      time: json['time'],
//      category_name: json['category_name'],
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
      height: size.height ,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return LeadsCell(
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
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0,10,18,0),
              child: Card(elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: new BorderRadius.circular(18.0)),height: 90,)
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
                        padding: const EdgeInsets.fromLTRB(18.0,5,5,5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(child:Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                                  child: Text(
                                    cellModel.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ) ,flex: 1,)

                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.fromLTRB(4.0, 5, 5, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Priority: ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey)),
                                      Text(cellModel.priority,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800])),

                                    ],
                                  ),
                                ),flex: 1,)
                                ,
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.fromLTRB(4.0, 5, 5, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Status: ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey)),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Text(
                                          cellModel.task_status,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),flex: 1,)

                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(child:
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5,5,0,0),
                                  child: Row(
                                    children: <Widget>[
                                      Text("Start Date:" ,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey)),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                                        child: Text(cellModel.startdate,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black)),
                                      ),

                                    ],
                                  ),
                                ),flex: 1,),

                                Expanded(child:Padding(
                                  padding: const EdgeInsets.fromLTRB(10,5,0,0),
                                  child: Row(
                                    children: <Widget>[

                                      Text("Due Date:" ,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey)),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                                        child: Text(cellModel.duedate ,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                ),flex: 1,),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5.0,5,0,5),
                                  child: Icon(Icons.attachment),
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
              ),
            )
          ],)
      ),
      onTap: () {
        // setState(() => countValue == 0 ? countValue = 1 : countValue = 0);
        // Grid Click

        Navigator.of(context).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new TaskDetails(text: cellModel.id,);
            }));
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
