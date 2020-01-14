
import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/leads_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

class EditPage extends StatefulWidget {

  final String meetid;

  EditPage({ @required this.meetid}) : super();

  @override
  _EditPageState createState() => new _EditPageState(meetid: meetid);
}

class _EditPageState extends State<EditPage> {
  final String meetid;
  _EditPageState({ @required this.meetid}) : super();

  final TextEditingController _title = new TextEditingController();
  final TextEditingController _account = new TextEditingController();
  final TextEditingController _description = new TextEditingController();


  List dataLeadStatus = List();
  List dataLeadSource = List();
  List dataLeadAssigned = List();
  String leadStatus,leadSource,leadAssigned;
  Future<String> getLeadStatus() async {

    var res = await http.get(Uri.encodeFull('http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/leads_status'));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['result'];

    setState(() {
      dataLeadStatus = resBody1;
    });

    print(resBody);

    return "Sucess";
  }



  Future<bool> _onBackPressed() {


    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeadDetails(text: meetid,),
        ));

  }
  void changeLeadStatus(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/change_lead_status";
    FormData formData = new FormData.from({
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      "lead_id": meetid,
      "status": leadStatus,
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
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: body['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.green[300],
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).push(
            MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new LeadDetails(text: meetid);
            }));
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
    super.initState();


    getLeadStatus();

  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: WillPopScope(

          onWillPop: _onBackPressed,
          child:  Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/login_back.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              shrinkWrap: false,
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LeadDetails(text: meetid,),
                                ));

                          }),
                      Flexible(
                        child: Center(
                          child: Text(
                            'Change Lead Status',
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
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 8, 0, 0),
                              child: Text(
                                'Change Status',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                child: DropdownButton<String>(
                                  icon: Icon(Icons.arrow_drop_down_circle),
                                  iconSize: 24,
                                  hint: Text('Lead Status'),
                                  isExpanded: true,
                                  underline: null,
                                  style: TextStyle(color: Colors.grey),
                                  items: dataLeadStatus.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['status_name']),
                                      value: item['id'].toString(),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    // Your code to execute, when a menu item is selected from dropdown
                                    setState(() {
                                      leadStatus = newVal;
                                    });
                                  },
                                  value: leadStatus,
                                )),
                            new Flexible(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: new Card(
                                  child: new GestureDetector(
                                    onTap: () {

                                      if(!["", null, false, 0].contains(leadStatus)){
                                        changeLeadStatus('');
                                      }else{
                                        Fluttertoast.showToast(
                                            msg: "please enter lead status",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIos: 1
                                        );

                                      }

                                    },
                                    child: new Container(
                                      child: Center(
                                        child: new Text(
                                          'Save',
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
            ),
          ),
        ));
  }





}
