import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class MeetingOptions extends StatefulWidget {
  @override
  _MeetingOptionsState createState() => new _MeetingOptionsState();

}
class _MeetingOptionsState extends State<MeetingOptions>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: WillPopScope(
          child:new Container(
              child: new Stack(
                children: <Widget>[

                  Container(
//                    child: Image.asset(
//                      'images/map_background.jpg',
//                      fit: BoxFit.fill,
//                    ),
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

                            Expanded(
                              child: Text(
                                'Client Name',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
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



                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(children: <Widget>[
                                    Text("Subject",
                                      style: new TextStyle(fontSize: 20.0,color: Colors.blue,fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                  child: Row(children: <Widget>[
                                    Text("Name", style: new TextStyle(fontWeight: FontWeight.bold),),
                                    Spacer(),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text("Address", style: new TextStyle(fontWeight: FontWeight.bold),)),
                                      Spacer(),
                                      Icon(Icons.location_on),
                                      //Icon(Icons.directions_car),
                                    ],
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text("Date", style: new TextStyle(fontWeight: FontWeight.bold),),
                                      Spacer(),
                                      Text("Time", style: new TextStyle(fontWeight: FontWeight.bold),),
                                      Spacer(),

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text("Description",
                                        style: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                      Spacer(),


                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text("member", style: new TextStyle(fontWeight: FontWeight.bold),),
                                      Spacer(),

                                      //Icon(Icons.location_on),
                                    ],
                                  ),
                                )
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

                                          // Within the `FirstRoute` widget
                                          onPressed: () {
                                            Navigator.of(context).pushNamed('/check_in');
                                          },
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(Icons.check_circle,size: 40.0,),
                                              Text("Check-In")
                                            ],
                                          ),
                                        ),
                                      )
                                      ,
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () => {
                                            _launchURL("9899285839")
                                          },
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(Icons.call,size: 40.0,),
                                              Text("Call")
                                            ],
                                          ),
                                        ),
                                      )
                                      ,
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () => { _textMe()

                                          },
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(Icons.email,size: 40.0,),
                                              Text("Message")
                                            ],
                                          ),
                                        ),
                                      )
                                      ,
                                      Expanded(
                                        child: FlatButton(

                                          onPressed: () => {},
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(Icons.close,size: 40.0,),
                                              Text("Close")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              )
                          )
                      ),
                    ],
                  )
                ],
              )),
        ),
        resizeToAvoidBottomPadding: true);
  }

}


void _calling(){
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