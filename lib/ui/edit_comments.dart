import 'dart:convert';
import 'dart:io';

import 'package:dextrous_crm_new2/ui/view_task.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'leads_details.dart';

class EditComments extends StatelessWidget {
  final String text,text2,text3;

  EditComments({Key key, @required this.text, @required this.text2 , @required this.text3}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: EditCommentsWidget(
          text: text,
          text2: text2,
          text3: text3,
        ),
      ),
    );
  }
}

class EditCommentsWidget extends StatefulWidget {
  final String text,text2,text3;

  EditCommentsWidget({Key key, @required this.text,@required this.text2, @required this.text3}) : super(key: key);

  @override
  _EditCommentsState createState() => _EditCommentsState(text: text,text2: text2,text3: text3);
}

class _EditCommentsState extends State<EditCommentsWidget> {
  String _mySelection;

  final String text,text2,text3;
  ProgressDialog pr;
  _EditCommentsState({Key key, @required this.text, @required this.text2,@required this.text3}) : super();

  final TextEditingController _comments = new TextEditingController();

  String comments = '';
  List data = List(); //edited line

  bool isResponse = false;
  void getToekn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/tasks/addEditcomment";
    FormData formData = new FormData.from({
      "comm_id": text2==['',null,""] ?' ':text2,
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'taskId': text,
      'desc': _comments.text.toString(),
    });

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        http.Response response = await http.post(login_url, body: formData);




        var body = await json.decode(response.body);
        //Simulate a service call
        print('submitting to backend...');
        new Future.delayed(new Duration(seconds: 4), () {
          setState(() async {
            if (response.statusCode == 200) {
              var body = await json.decode(response.body);

              print(response.body);

              Fluttertoast.showToast(
                  msg: body['message'],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.green[300],
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              Future.delayed(Duration(seconds: 3))
                  .then((value) {
                pr.hide().whenComplete(() {
                  isResponse = false;
                  String textToSend = text;
                  Navigator.of(context).pop(true);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetails(
                          text: text,
                        ),
                      ));
                });
              });

            } else {
              isResponse = true;
            }
          });
        });
      }
    } on SocketException catch (_) {
      pr.dismiss();
      pr.hide();
      Fluttertoast.showToast(
          msg: "Internet is not available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print('not connected');
    }





  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    } else {
      return null;
    }
  }
//
//  Future<String> getSWData() async {
//    FormData formData = new FormData.from({
//      "userId": '40',
//      "token": '44a33c06eb2286deef0d2fdddd352690',
//    });
//    var res = await http.get(Uri.encodeFull(url));
//    var resBody = json.decode(res.body);
//
//    setState(() {
//      data = resBody;
//    });
//
//    print(resBody);
//
//    return "Sucess";
//  }

  @override
  void initState() {
    super.initState();
   // this.getSWData();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Want to leave?'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetails(
                            text: text,
                          ),
                        ));
                  } else {
                    SystemNavigator.pop();
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    _comments.text =!["", null, false, 0].contains(text3) ? text3 : "";
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: ListView(
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
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetails(
                                    text: text,
                                  ),
                                ));


                          }),
                      Flexible(
                        child: Center(
                          child: Text(
                            'Comments',
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
                Center(
                  child:Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                    child: Card(
                      child: Container(
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(10.0, 28, 0, 0),
//                              child: Text(
//                                'Select Type',
//                                style: TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 13,
//                                    fontWeight: FontWeight.w700),
//                              ),
//                            ),
//                            Padding(
//                                padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
//                                child: DropdownButton<String>(
//                                  icon: Icon(Icons.arrow_drop_down_circle),
//                                  iconSize: 24,
//                                  hint: Text('Select Label'),
//                                  isExpanded: true,
//                                  underline: null,
//                                  style: TextStyle(color: Colors.grey),
//                                  items: data.map((item) {
//                                    return new DropdownMenuItem(
//                                      child: new Text(item['leb_name']),
//                                      value: item['label_id'].toString(),
//                                    );
//                                  }).toList(),
//                                  onChanged: (newVal) {
//                                    setState(() {
//                                      _mySelection = newVal;
//                                    });
//                                  },
//                                  value: _mySelection,
//                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 8, 0, 0),
                              child: Text(
                                'Comments',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Container(
                                height: 100,
                                child: TextFormField(
                                  controller: _comments,
                                  minLines: 5,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                  maxLines: 5,
                                ),
                              ),
                            ),
                            new Flexible(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: new Card(
                                  child: new GestureDetector(
                                    onTap: () {
                                     if(_comments.text.toString()==""){
                                       Fluttertoast.showToast(
                                           msg: "Please enter text",
                                           toastLength: Toast.LENGTH_SHORT,
                                           gravity: ToastGravity.CENTER,
                                           timeInSecForIos: 1
                                       );
                                     }else{
                                       print("Container clicked");

                                       FocusScope.of(context)
                                           .requestFocus(FocusNode());
                                       // No any error in validation

                                       // print("Name $name");
                                       print("Mobile $_comments");
                                       pr.show();
                                       getToekn();
                                     }

                                    },
                                    child: new Container(
                                      child: Center(
                                        child: new Text(
                                          'Submit',
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
                        ),
                      ),
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),),
              ],
            ),));
  }
}

class Label {
  String label_id;
  String leb_name;

  Label({
    this.label_id,
    this.leb_name,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      label_id: json['label_id'],
      leb_name: json['leb_name'],
    );
  }
}
