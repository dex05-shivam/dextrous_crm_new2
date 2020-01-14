import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'feedbackPage.dart';

class Checkout extends StatefulWidget {
  String meetid = '';
  Checkout({Key key, this.meetid}) : super(key: key);
  @override
  _CheckoutState createState() => new _CheckoutState(meetid: meetid);
}

class _CheckoutState extends State<Checkout> {
  String meetid = '';
  _CheckoutState({Key key, this.meetid}) : super();
  final TextEditingController _notes = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: WillPopScope(
          child: new Container(
              child: new Stack(
                children: <Widget>[
                  Container(
                    child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/login_back.png',
                      fit: BoxFit.fill,
                    ),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                'Checkout',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xF3253F5A),
                                  fontSize: 20,
                                ),
                              ),
                              flex: 1,
                            ),
//                            new IconButton(
//                                icon: Icon(
//                                  Icons.home,
//                                  color: Colors.black,
//                                  size: 20,
//                                ),
//                                onPressed: () {
////                            Provider.of<MenuController>(context, listen: true)
////                                .toggle();
//                                }),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            "Notes :",
                            textAlign: TextAlign.left,
                            style: new TextStyle(color: Color(0xF3253F5A),fontSize: 20.0),

                          )),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  controller: _notes,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Notes';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Notes',
                                      hintText: 'Enter your notes',
                                      errorStyle: TextStyle(
                                          color: Color(0xF3253F5A), fontSize: 15.0),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0))),
                                ),
                              ],
                            ),
                          )),
                      Container(
                        // This align moves the children to the bottom
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              // This container holds all the children that will be aligned
                              // on the bottom and should not scroll with the above ListView
                              child: Container(
                                  width: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () => {
                                            Navigator.of(context).push(
                                                MaterialPageRoute<Null>(builder:
                                                    (BuildContext context) {
                                                  return new FeedBack(notes: _notes.text.toString(),
                                                    meetid: meetid,
                                                  );
                                                }))
                                          },
                                          color: Color(0xF3253F5A),
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                                size: 40.0,
                                              ),
                                              Text("Check-Out",style: TextStyle(color: Colors.white,),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )))),
                    ],
                  )
                ],
              )),
        ),
        resizeToAvoidBottomPadding: true);
  }
}

void _calling() {
  _launchURL("9899285839");
}

_launchURL(String phone) async {
  const url = 'tel:"9899285839"';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_textMe() async {
  // Android
  const uri = 'sms:+91 9899285839?body=hello%20there';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    // iOS
    const uri = 'sms:9899285839';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
