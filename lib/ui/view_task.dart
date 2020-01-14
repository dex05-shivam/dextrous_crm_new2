import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/add_checklist.dart';
import 'package:dextrous_crm_new2/ui/task_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'add_comments_screen.dart';
import 'edit_comments.dart';
import 'lead_screen.dart';

class TaskDetails extends StatefulWidget {
  final String text;

  TaskDetails({Key key, @required this.text}) : super(key: key);
  @override
  _TaskDetailsState createState() => new _TaskDetailsState(text: text);
}

class _TaskDetailsState extends State<TaskDetails> {
  final String text;

  _TaskDetailsState({@required this.text}) : super();
  final String uri =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/taskList";

  int countValue = 1;

  bool isHomeDataLoading = false;

  String id, name, priority, task_status, startdate, duedate;
//      company,
//      address,
//      summary,
//      country,
//      color,
//      leads_skype_id,
//      leads_mobile_number,
//      leads_whapapp_number,
//      leads_customer_type,
//      leads_price,
//      leads_subject,
//      leads_lead_for;

  String contact_on = "assets/images/check.png",
      summary_off = "assets/images/comments2.png";

  void getToekn(String type) async {
    isHomeDataLoading = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/task_view";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "taskId": text,
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
        id = body['id'];
        name = body['name'];
        priority = body['priority'];
        task_status = body['task_status'];
        startdate = body['startdate'];
        duedate = body['duedate'];
//        company = body['company'];
//        address = body['address'];
//        summary = body['summary'];
//        country = body['country'];
//        color = body['color'];

//        // status=body['status'];
//        leads_skype_id = body['leads_skype_id'];
//        leads_mobile_number = body['leads_mobile_number'];
//        leads_whapapp_number = body['leads_whapapp_number'];
//        leads_customer_type = body['leads_customer_type'];
//        leads_price = body['leads_price'];
//        leads_subject = body['leads_subject'];
//        leads_lead_for = body['leads_lead_for'];
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

  Future<List<Notes>> getToekn1(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/task_view";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "taskId": text,
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
        List<dynamic> dynamicList = decodedMap['checkList'];
        List<Notes> students = new List<Notes>();
        dynamicList.forEach((f) {
          Notes s = Notes.fromJson(f);
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

  Future<List<Notes1>> getToekn2(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/task_view";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "taskId": text,
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
        List<dynamic> dynamicList = decodedMap['commList'];
        List<Notes1> students = new List<Notes1>();
        dynamicList.forEach((f) {
          Notes1 s = Notes1.fromJson(f);
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

  Future<bool> _onBackPressed() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

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
                  Container(
                    child: isHomeDataLoading == false
                        ? circularProgress()
                        : ListView(
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
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    print('hello');
                                    Navigator.of(context).push(MaterialPageRoute<Null>(
                                        builder: (BuildContext context) {
                                          return new TaskList(text: "",text2: "",);
                                        }));
                                    // Navigator.pop(context);
                                  }),
                              Flexible(
                                child: Center(
                                  child: Text(
                                    'View Task',
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
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        18.0, 10, 18, 0),
                                    child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                              new BorderRadius.circular(
                                                  18.0)),
                                          height: 90,
                                        )),
                                  ),
                                  Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/back.png"),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius:
                                          new BorderRadius.circular(
                                              16.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  18.0, 5, 5, 5),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0,
                                                              5.0,
                                                              0,
                                                              0),
                                                          child: Text(
                                                            name,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                            ),
                                                          ),
                                                        ),
                                                        flex: 1,
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              4.0,
                                                              5,
                                                              5,
                                                              0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: <
                                                                Widget>[
                                                              Text(
                                                                  'Priority : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                      color: Colors
                                                                          .grey)),
                                                              Text(priority,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                      color: Colors
                                                                          .grey[800])),
                                                            ],
                                                          ),
                                                        ),
                                                        flex: 1,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              4.0,
                                                              5,
                                                              5,
                                                              0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: <
                                                                Widget>[
                                                              Text('Status: ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                      color: Colors
                                                                          .grey)),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    5),
                                                                child: Text(
                                                                  task_status,
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        flex: 1,
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              5, 5, 0, 0),
                                                          child: Row(
                                                            children: <
                                                                Widget>[
                                                              Text(
                                                                  "Start Date :",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      10,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                      color: Colors
                                                                          .grey)),
                                                          Flexible(child:Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    4.0,
                                                                    0,
                                                                    0,
                                                                    0),
                                                                child: Text(
                                                                    startdate,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        12,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        color:
                                                                        Colors.black)),
                                                              )),
                                                            ],
                                                          ),
                                                        ),
                                                        flex: 1,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              10,
                                                              5,
                                                              0,
                                                              0),
                                                          child: Row(
                                                            children: <
                                                                Widget>[
                                                              Text(
                                                                  "Due Date :",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      10,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                      color: Colors
                                                                          .grey)),
                                                              Flexible(child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    4.0,
                                                                    0,
                                                                    0,
                                                                    0),
                                                                child: Text(
                                                                    duedate,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        12,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        color:
                                                                        Colors.black)),
                                                              ),flex: 1,)
                                                              ,
                                                            ],
                                                          ),
                                                        ),
                                                        flex: 1,
                                                      ),
//                                                      Padding(
//                                                        padding:
//                                                        const EdgeInsets
//                                                            .fromLTRB(
//                                                            5.0, 5, 0, 5),
//                                                        child: Icon(
//                                                            Icons.attachment),
//                                                      )
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
                                      contact_on = "assets/images/check.png";
                                      summary_off =
                                      "assets/images/comments2.png";
                                      countValue = 1;
                                      getToekn1('1');
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
                                padding:
                                const EdgeInsets.fromLTRB(0.0, 3, 0, 0),
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
                                      contact_on = "assets/images/check2.png";
                                      summary_off =
                                      "assets/images/comments.png";
                                      countValue = 2;
                                      getToekn2('2');
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
                            ],
                          ),
                        ),
                        countValue == 1
                            ? SingleChildScrollView(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 0, 20, 0),
                                child: new Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: FutureBuilder<List<Notes>>(
                                        future: getToekn1('1'),
                                        builder: (context, snapshot) {
                                          return snapshot
                                              .connectionState ==
                                              ConnectionState.done
                                              ? snapshot.hasData
                                              ? _NotesCellState
                                              .homeGrid(
                                              snapshot,
                                              context,
                                              text)
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 20, 20, 0),
                                child: new Card(
                                  child: new GestureDetector(
                                    onTap: () {
                                      print("Container clicked");
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddCheckList(
                                                  text: text,
                                                  text2: '',
                                                  text3: '',
                                                ),
                                          ));
                                    },
                                    child: new Container(
                                      child: Center(
                                        child: new Text(
                                          'Add CheckList',
                                          style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      height: 40,
                                      width: _width,
                                    ),
                                  ),
                                  color: Color(0xFFf79020),
                                  elevation: 5,
                                ),
                              ),
                            ],
                          ),
                        )
                            : SingleChildScrollView(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 0, 20, 0),
                                  child: new Container(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 5, 0, 5),
                                      child: Container(
                                        child: FutureBuilder<List<Notes1>>(
                                          future: getToekn2('1'),
                                          builder: (context, snapshot) {
                                            return snapshot
                                                .connectionState ==
                                                ConnectionState.done
                                                ? snapshot.hasData
                                                ? _NotesCellState1
                                                .homeGrid(snapshot,
                                                context, text)
                                                : _NotesCellState1
                                                .retryButton(fetch)
                                                : _NotesCellState1
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
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: new Card(
                                      child: new GestureDetector(
                                        onTap: () {
                                          print("Container clicked");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditCommentsWidget(
                                                      text: text,
                                                      text2: '',
                                                      text3: '',
                                                    ),
                                              ));
//
                                        },
                                        child: new Container(
                                          child: Center(
                                            child: new Text(
                                              'Add Comments',
                                              style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          height: 40,
                                          width: _width,
                                        ),
                                      ),
                                      color: Color(0xFFf79020),
                                      elevation: 5,
                                    ),
                                  ),
                                  flex: 0,
                                ),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              )),
        ),
        resizeToAvoidBottomPadding: true);
  }
}

class Notes {
  String check_list_id;
  String check_list_decs;
  String finished;
  //String label_name, description;

  Notes({this.check_list_id, this.check_list_decs, this.finished
//    this.label_name,
//    this.description,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      check_list_id: json['check_list_id'],
      check_list_decs: json['check_list_decs'],
      finished: json['finished'],
//      label_name: json['label_name'],
//      description: json['description'],
    );
  }
}

class NotesCell extends StatefulWidget {
  int countValue = 0;
  NotesCell(this.cellModel, this.text);
  @required
  final Notes cellModel;
  final String text;

  @override
  _NotesCellState createState() => _NotesCellState(this.cellModel, this.text);
}

class _NotesCellState extends State<NotesCell> {
  int countValue = 0;
  final String text;
  _NotesCellState(this.cellModel, this.text);
  @required
  final Notes cellModel;
  Future<List<Notes>> getDelete(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/deleteCheckList";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "check_id": cellModel.check_list_id,
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

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetails(
                text: text,
              ),
            ));
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  Future<List<Notes>> getFinished(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/finished_checkList";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "check_id": cellModel.check_list_id,
      "taskId": text,
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

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetails(
                text: text,
              ),
            ));
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  static WillPopScope homeGrid(
      AsyncSnapshot<List<Notes>> snapshot, context, text) {
    Future<bool> _onBackPressed() {
      return Future.value(true);
    }

    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
            height: size.height / 1.3,
            width: double.infinity,
            child: snapshot.data.length > 0
                ? ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return NotesCell(snapshot.data[index], text);
              },
            )
                : Card(
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
            )));
  }

  Future<bool> _onBackPressed() {
    return Future.value(true);
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
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: GestureDetector(
          child: Padding(
              padding: const EdgeInsets.all(2.0),
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
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          ![
                                            "",
                                            null,
                                            false,
                                            0,
                                            "0"
                                          ].contains(cellModel.finished) ? getFinished('0') : getFinished('1');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 1, 0, 0),
                                          child: Icon(
                                            ![
                                              "",
                                              null,
                                              false,
                                              0,
                                              "0"
                                            ].contains(cellModel.finished)
                                                ? Icons.check_circle
                                                : Icons.brightness_1,
                                            size: 20,
                                            color: ![
                                              "",
                                              null,
                                              false,
                                              0,
                                              "0"
                                            ].contains(cellModel.finished)
                                                ? Colors.green
                                                : Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2.0, 0, 0),
                                          child: Text(
                                            ["", null, false, 0].contains(
                                                cellModel.check_list_decs)
                                                ? ' No Data Available'
                                                : cellModel.check_list_decs,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.clip,
                                            maxLines: 4,
                                          ),
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 1, 5, 3),
                                          child: GestureDetector(
                                            onTap: () {


                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCheckList(
                                                          text: text,
                                                          text2: cellModel
                                                              .check_list_id,
                                                          text3: cellModel.check_list_decs,
                                                        ),
                                                  ));
                                            },
                                            child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/writing.png',
                                              height: 15,
                                              width: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 1, 5, 3),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Center(child: Text('DexCRM')),
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text(
                                                              "Are you sure want to delete checklist?",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                FlatButton(
                                                                    child: Text('Yes'),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                      getDelete('1');
                                                                    }),
                                                                FlatButton(
                                                                    child: Text('No'),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    })
                                                              ])
                                                        ],
                                                      ),
                                                    );
                                                  });


                                            },
                                            child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/delete.png',
                                              height: 15,
                                              width: 15,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
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
        ));
  }
}

class Notes1 {
  String comm_id;
  String comm_desc;
//  String finished;
  String comm_added_by, comm_addeddate;

  Notes1({
    this.comm_id,
    this.comm_desc,
    this.comm_added_by,
    this.comm_addeddate,
//    this.description,
  });

  factory Notes1.fromJson(Map<String, dynamic> json) {
    return Notes1(
      comm_id: json['comm_id'],
      comm_desc: json['comm_desc'],
      comm_added_by: json['comm_added_by'],
      comm_addeddate: json['comm_addeddate'],

//      label_name: json['label_name'],
//      description: json['description'],
    );
  }
}

class NotesCell1 extends StatefulWidget {
  int countValue = 0;
  final String text;
  NotesCell1(this.cellModel, this.text);
  @required
  final Notes1 cellModel;

  @override
  _NotesCellState1 createState() => _NotesCellState1(this.cellModel, this.text);
}

class _NotesCellState1 extends State<NotesCell1> {
  int countValue = 0;
  final String text;
  _NotesCellState1(this.cellModel, this.text);
  @required
  final Notes1 cellModel;

  Future<List<Notes>> getDelete(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/deleteComment";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "comm_id": cellModel.comm_id,
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

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetails(
                text: text,
              ),
            ));
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      throw Exception(e);
    }
//    prefs.setString('main_token',body['token'] );
//    print(body['token']);
  }

  static Container homeGrid(
      AsyncSnapshot<List<Notes1>> snapshot, context, text) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height / 1.3,
        width: double.infinity,
        child: snapshot.data.length > 0
            ? ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return NotesCell1(snapshot.data[index], text);
          },
        )
            : Card(
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
        ));
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
    Size size = MediaQuery.of(context).size;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return GestureDetector(
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            children: <Widget>[
              ["", null, false, 0].contains(cellModel.comm_id)
                  ? Card(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 5.0, 0, 0),
                                child: Text(
                                  ["", null, false, 0]
                                      .contains(cellModel.comm_id)
                                      ? ' No Data Available'
                                      : cellModel.comm_id,
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
              )
                  : Card(
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
                              Container(
                                width: _width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        cellModel.comm_addeddate,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                0, 0, 5, 0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditCommentsWidget(
                                                            text: text,
                                                            text2: cellModel
                                                                .comm_id,
                                                            text3: cellModel.comm_desc,
                                                          ),
                                                    ));
                                              },
                                              child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/writing.png',
                                                height: 15,
                                                width: 15,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              getDelete('');
                                            },
                                            child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/delete.png',
                                              height: 15,
                                              width: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 0.0, 0, 5),
                                child: Text(
                                  cellModel.comm_added_by,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 0.0, 0, 5),
                                child: SingleChildScrollView(
                                  child: Html(
                                    data: cellModel.comm_desc,
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