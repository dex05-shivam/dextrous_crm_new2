import 'package:dextrous_crm_new2/ui/lead_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNewLead extends StatefulWidget {
  @override
  _AddNewLeadState createState() => new _AddNewLeadState();
}

class _AddNewLeadState extends State<AddNewLead> {
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _mail = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  final TextEditingController _address = new TextEditingController();

  String leadStatus,leadSource,leadAssigned,leadCountry;

  String _email = "";
  String _password = "";
  // our default setting is to login, and we should switch to creating an account when the user chooses to


  TextStyle style1 = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 12.0,
      fontStyle: FontStyle.normal,
      color: Colors.grey);
  TextStyle style11 = TextStyle(
      fontFamily: 'Montserrat-BoldItalic',
      fontSize: 15.0,
      fontWeight: FontWeight.w700,
      color: Colors.white);
  TextStyle style2 = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12.0,
    fontStyle: FontStyle.normal,
    color: Color(0xff0D314D),
    decoration: TextDecoration.underline,
  );
  TextStyle style3 = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 12.0,
      fontStyle: FontStyle.normal,
      color: Color(0xff0D314D),
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.bold);
  final _text = TextEditingController();


  List dataLeadStatus = List();
  List dataLeadSource = List();
  List dataLeadAssigned = List();

  List dataLeadCountry = List();

  Future<String> getCountry() async {

    var res = await http.get(Uri.encodeFull('http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/country_list'));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['country'];

    setState(() {
      dataLeadCountry = resBody1;
    });

    print(resBody);

    return "Sucess";
  }


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

  Future<String> getLeadSource() async {

    var res = await http.get(Uri.encodeFull('http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/leads_source'));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['result'];

    setState(() {
      dataLeadSource = resBody1;

    });

    print(resBody);

    return "Sucess";
  }

  Future<String> getLeadAssigned() async {

    var res = await http.get(Uri.encodeFull('http://ems.dextrousinfosolutions.com/dev-dexcrm/api/meeting/members_list'));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['members'];



    setState(() {
      dataLeadAssigned = resBody1;
    });

    print(resBody);

    return "Sucess";
  }


  ProgressDialog pr;
  bool isResponse = false;
  Future<int> saveLead() async {
    pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/leads/add_lead";
    FormData formData = new FormData.from({
      "status": leadStatus,
      "userId": prefs.getString('userId'),
      "token": prefs.getString('user_token'),
      'name': _name.text.toString(),
      'source': leadSource,
      'address': _address.text.toString(),
      'assigned': leadAssigned,
      'email': _mail.text.toString(),
      'phonenumber': _phone.text.toString(),
      'description': '',
      'country' : leadCountry,
    });

    http.Response response = await http.post(login_url, body: formData);

    var body = await json.decode(response.body);
    //Simulate a service call
    print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 4), () {
      setState(() async {
        if (response.statusCode == 200) {
          var body = await json.decode(response.body);
          isResponse = false;
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
              isResponse = false;
              openAlertBox(body['leadId']);

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


  @override
  void initState() {
    super.initState();

    getLeadAssigned();
    getLeadSource();
    getLeadStatus();

    getCountry();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                body:Container(
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
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      SystemNavigator.pop();
                                    }
                                  }),
                              Flexible(
                                child: Center(
                                  child: Text(
                                    ' New Lead',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                flex: 1,
                              ),

                            ],
                          ),
                        ),
                        Flexible(
                          child:Padding(
                              padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                              child: new Container(
                                child: SingleChildScrollView(

                                    child:
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                  children: <Widget>[
                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                                child: Text(
                                                  'Lead Status',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
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
                                              ))
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                                child: Text(
                                                  'Select Source',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                              child: DropdownButton<String>(
                                                icon: Icon(Icons.arrow_drop_down_circle),
                                                iconSize: 24,
                                                hint: Text('Select Source'),
                                                isExpanded: true,
                                                underline: null,
                                                style: TextStyle(color: Colors.grey),
                                                items: dataLeadSource.map((item) {
                                                  return new DropdownMenuItem(
                                                    child: new Text(item['source_name']),
                                                    value: item['id'].toString(),
                                                  );
                                                }).toList(),
                                                onChanged: (newValueSelected) {
                                                  // Your code to execute, when a menu item is selected from dropdown
                                                  setState(() {
                                                    leadSource = newValueSelected;
                                                  });
                                                },
                                                value: leadSource,
                                              ))
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                                child: Text(
                                                  'Assigned',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                              child: DropdownButton<String>(
                                                icon: Icon(Icons.arrow_drop_down_circle),
                                                iconSize: 24,
                                                hint: Text('Assigned'),
                                                isExpanded: true,
                                                underline: null,
                                                style: TextStyle(color: Colors.grey),
                                                items: dataLeadAssigned.map((item) {
                                                  return new DropdownMenuItem(
                                                    child: new Text(item['name']),
                                                    value: item['id'].toString(),
                                                  );
                                                }).toList(),
                                                onChanged: (newValueSelected) {
                                                  // Your code to execute, when a menu item is selected from dropdown
                                                  setState(() {
                                                    leadAssigned = newValueSelected;
                                                  });
                                                },
                                                value: leadAssigned,
                                              ))
                                        ],
                                      ),
                                    ),

                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                                child: Text(
                                                  'Country',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                              child: DropdownButton<String>(
                                                icon: Icon(Icons.arrow_drop_down_circle),
                                                iconSize: 24,
                                                hint: Text('Country'),
                                                isExpanded: true,
                                                underline: null,
                                                style: TextStyle(color: Colors.grey),
                                                items: dataLeadCountry.map((item) {
                                                  return new DropdownMenuItem(
                                                    child: new Text(item['name']),
                                                    value: item['id'].toString(),
                                                  );
                                                }).toList(),
                                                onChanged: (newValueSelected) {
                                                  // Your code to execute, when a menu item is selected from dropdown
                                                  setState(() {
                                                    leadCountry = newValueSelected;
                                                  });
                                                },
                                                value: leadCountry,
                                              ))
                                        ],
                                      ),
                                    ),

                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                                child: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          new TextField(
                                            controller: _name,
                                            decoration: new InputDecoration(
                                                hintText: 'Enter name',
                                                hintStyle: style1,
                                                suffixIcon: Icon(
                                                  Icons.person_outline,
                                                  color: Colors.grey,
                                                  size: 20,
                                                )),
                                            maxLines: 1,
                                            autofocus: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                                child: Text(
                                                  'Email',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          new TextField(
                                            controller: _mail,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: new InputDecoration(
                                                hintText: 'Enter email',
                                                hintStyle: style1,
                                                suffixIcon: Icon(
                                                  Icons.email,
                                                  color: Colors.grey,
                                                  size: 20,
                                                )),
                                            maxLines: 1,
                                            autofocus: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                                child: Text(
                                                  'Phone',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          new TextField(
                                            controller: _phone,
                                            keyboardType: TextInputType.number,
                                            decoration: new InputDecoration(
                                                hintText: 'Enter phone',
                                                hintStyle: style1,
                                                suffixIcon: Icon(
                                                  Icons.phone,
                                                  color: Colors.grey,
                                                  size: 20,
                                                )),
                                            maxLines: 1,
                                            autofocus: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                                child: Text(
                                                  'Address',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          new TextField(
                                            controller: _address,
                                            decoration: new InputDecoration(
                                                hintText: 'Enter address',
                                                hintStyle: style1,
                                                suffixIcon: Icon(
                                                  Icons.location_city,
                                                  color: Colors.grey,
                                                  size: 20,
                                                )),
                                            maxLines: 1,
                                            autofocus: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              //_showDialog();

                                              if(!["", null, false, 0].contains(_name.text.toString())){
                                                      if(!["", null, false, 0].contains(leadAssigned.toString())){
                                                        if(!["", null, false, 0].contains(leadSource.toString())){
                                                          if(!["", null, false, 0].contains(_name.text.toString())){
                                                            if(!["", null, false, 0].contains(leadCountry))
                                                            {
                                                              if(_phone.text.toString().length==11) {
                                                                saveLead();
                                                              }
                                                              else
                                                                {
                                                                  Fluttertoast.showToast(
                                                                      msg: "Please enter valid mobile number",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.CENTER,
                                                                      timeInSecForIos: 1
                                                                  );
                                                                }
                                                            }else{
                                                              Fluttertoast.showToast(
                                                                  msg: "please select country",
                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                  gravity: ToastGravity.CENTER,
                                                                  timeInSecForIos: 1
                                                              );
                                                            }

                                                          }else{
                                                            Fluttertoast.showToast(
                                                                msg: "please enter lead status",
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                gravity: ToastGravity.CENTER,
                                                                timeInSecForIos: 1
                                                            );

                                                          }

                                                          //saveLead();
                                                        }else{
                                                          Fluttertoast.showToast(
                                                              msg: "please enter source name",
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.CENTER,
                                                              timeInSecForIos: 1
                                                          );

                                                        }

                                                        //saveLead();
                                                      }else{
                                                        Fluttertoast.showToast(
                                                            msg: "please enter assigned person",
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.CENTER,
                                                            timeInSecForIos: 1
                                                        );

                                                      }

                                                      //saveLead();




                                                  //saveLead();

                                                // saveLead();
                                              }else{
                                                Fluttertoast.showToast(
                                                    msg: "please enter name",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    timeInSecForIos: 1
                                                );
                                              }


                                              //_showDialog();
                                              // No any error in validation
                                              // print("Name $name");
                                              // print("Mobile $_comments");

                                            },
                                            child: Card(
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: new BorderRadius.circular(40),
                                                ),
                                                height: 40.0, // height of the button
                                                width: 120.0, // width of the button
                                                child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text(
                                                          'Submit',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                        Icon(
                                                          Icons.arrow_forward_ios,
                                                          size: 15,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    )),
                                              ),
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40.0),
                                              ),
                                            ),
                                          )),
                                    ),


//                    Visibility(child: showImage(),visible: false,),

                                  ],

                                ),)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
//                        image: DecorationImage(
//                          image: AssetImage("assets/images/card_background.png"),
//                          fit: BoxFit.fill,
//
//                        ),
                                    color: Colors.white
                                ),)),),

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
                ),


                resizeToAvoidBottomPadding: false)));
  }



  openAlertBox(String leadID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.network(
                    'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/logo_dex.png',
                    height: 20,
                    width: 100,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       Row(crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                         Icon(Icons.check_box,color: Colors.greenAccent,),
                         new Text("New Lead Created",style: TextStyle(fontSize:20,color: Colors.blueGrey,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic)),
                       ],),

                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                            child: Text("Lead Number is : "+leadID,style: style3,)
                        ),
                      ],
                    ),
                  ),


                  InkWell(

                    child: Container(

                      padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1F244C),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: new FlatButton(
                        child: new Text("Close",style: style11,),
                        onPressed: () {
                          Navigator.of(context).pop();

                          Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                                return new LeadScreen(text: "",text2: "Leads",text3: "",);
                              }));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
