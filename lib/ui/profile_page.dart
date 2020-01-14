import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dextrous_crm_new2/drawer_ui/circular_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';
import 'login_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:splashscreen/splashscreen.dart';
//import 'package:progress_dialog/progress_dialog.dart';

//import 'home_page.dart';
////import 'login_page.dart';
//void main() => runApp(MainScreen());
//Future main() async {
// // SharedPreferences prefs = await SharedPreferences.getInstance();
//  //var email = prefs.getString('email');
//  // print("hello "+email);
//  runApp(new MaterialApp(
//    home: new SplashScreen(),
//    routes: <String, WidgetBuilder>{
//
//      '/MyApp1': (BuildContext context) =>  SplashScreen()
//    },
//  ));
//}

enum FormType { login, register }

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getSWData();
    getSWData1();
    getToekn();
  }
//  File _image;
//
//  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//
//    setState(() {
//      _image = image;
//    });
//  }

  File _imageFile;
  String base64 = '', fileName = 'Browse File';

  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      setState(() {
        _imageFile = imageFile;
        base64 = base64Encode(imageFile.readAsBytesSync());
        fileName = imageFile.path.split('/').last;
        print(fileName + '------' + base64);
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return Image.file(_imageFile);
    } else {
      return Text('Take an image to start', style: TextStyle(fontSize: 18.0));
    }
  }

  String _mySelection, _myselection2;
  final String url =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/expense/Exp_category";
  // final format = DateFormat("yyyy-MM-dd HH:mm");
  String comments = '', time1 = 'Select Time', date1 = 'Select Date';
  List data = List();
  List data1 = List(); //edited line

//  Future<File> file;
//  String status = '';
//  String base64Image;
//  File tmpFile;
//  String errMessage = 'Error Uploading Image';
//  chooseImage() {
//    setState(() {
//      file = ImagePicker.pickImage(source: ImageSource.gallery);
//    });
//    setStatus('');
//  }
//
//  setStatus(String message) {
//    setState(() {
//      status = message;
//    });
//  }
//
//  startUpload() {
//    setStatus('Uploading Image...');
//    if (null == tmpFile) {
//      setStatus(errMessage);
//      return;
//    }
//    String fileName = tmpFile.path.split('/').last;
//   // upload(fileName);
//  }
//
//  Widget showImage() {
//    return FutureBuilder<File>(
//      future: file,
//      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//        if (snapshot.connectionState == ConnectionState.done &&
//            null != snapshot.data) {
//          tmpFile = snapshot.data;
//          base64Image = base64Encode(snapshot.data.readAsBytesSync());
//          return Flexible(
//            child: Image.file(
//              snapshot.data,
//              fit: BoxFit.fill,
//            ),
//          );
//        } else if (null != snapshot.error) {
//          return const Text(
//            'Error Picking Image',
//            textAlign: TextAlign.center,
//          );
//        } else {
//          return const Text(
//            'No Image Selected',
//            textAlign: TextAlign.center,
//          );
//        }
//      },
//    );
//  }

  bool isResponse = false;
  String email='',name='',phone='',profile='',imageUrl;
  final TextEditingController _title = new TextEditingController();
  final TextEditingController _account = new TextEditingController();
  final TextEditingController _description = new TextEditingController();

  String _email = "";
  String _password = "";
  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  TextStyle style1 = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 12.0,
      fontStyle: FontStyle.normal,
      color: Colors.grey);
  TextStyle style11 = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 12.0,
      fontWeight: FontWeight.w700,
      color: Colors.black);
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

  Future<String> getSWData() async {
    FormData formData = new FormData.from({
      "userId": '40',
      "token": '44a33c06eb2286deef0d2fdddd352690',
    });
    var res = await http.get(Uri.encodeFull(url));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['exp_cat_list'];

    setState(() {
      data = resBody1;
    });

    print(resBody);

    return "Sucess";
  }

  Future<String> getSWData1() async {
    FormData formData = new FormData.from({
      "userId": '40',
      "token": '44a33c06eb2286deef0d2fdddd352690',
    });
    var res = await http.get(Uri.encodeFull(
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/expense/Exp_type"));
    var resBody = json.decode(res.body);

    var resBody1 = resBody['exp_type_list'];

    setState(() {
      data1 = resBody1;
    });

    print(resBody);

    return "Sucess";
  }

  Future<int> getToekn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email=prefs.getString('email');
    name=prefs.getString('name');
    imageUrl=prefs.getString('profile');
    phone =prefs.getString('phone');
//    String login_url =
//        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/expense/addEdit_exp";
//    FormData formData = new FormData.from({
//      "expId": '',
//      "userId": prefs.getString('userId'),
//      "token": prefs.getString('user_token'),
//      'amount': _account.text.toString(),
//      'category': _mySelection,
//      'expense_name': _title.text.toString(),
//      'expense_type': _myselection2,
//      'desc': _description.text.toString(),
//      'date': date1,
//      'time': time1,
//      'expfile': base64,
//    });
//
//    http.Response response = await http.post(login_url, body: formData);
//
//    var body = await json.decode(response.body);
//    //Simulate a service call
//    print('submitting to backend...');
//    new Future.delayed(new Duration(seconds: 4), () {
//      setState(() async {
//        if (response.statusCode == 200) {
//          var body = await json.decode(response.body);
//
//          print(response.body);
//
//          isResponse = false;
//          Navigator.of(context)
//              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
//            return new HomePage();
//          }));
//        } else {
//          isResponse = true;
//        }
//      });
//    });
//
////    prefs.setString('main_token',body['token'] );
////    print(body['token']);
//    return body['status'];
  }

  Widget _formRegistration(BuildContext context) {
    return SingleChildScrollView(
      child: new Column(
        children: <Widget>[],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(child:  Padding(
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
                          ' Profile',
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
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () {
//                            Provider.of<MenuController>(context, listen: true)
//                                .toggle();
                        }),
                  ],
                ),
              ),
              Flexible(
                child:Padding(
                    padding: const EdgeInsets.fromLTRB(25, 60, 25, 0),
                    child: new Container(
                      child: ListView(
                        children: <Widget>[
                           Container(
                             child: Center(
                               child:
                               new Container(
                                   width: 80.0,
                                   height: 80.0,
                                   decoration: new BoxDecoration(
                                       shape: BoxShape.circle,
                                       image: new DecorationImage(
                                           fit: BoxFit.fill,
                                           image: new NetworkImage(!["", null, false, 0].contains(imageUrl)? imageUrl :"https://huntpng.com/images250/avatar-png-1.png"),
                                       )
                                   )),
                             ),
                           ),


                          new Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                new TextField(
                                  controller: _title,
                                  decoration: new InputDecoration(
                                      hintText: ["", null, false, 0].contains(name)?name :name,

                                      hintStyle: style1,
                                      suffixIcon: Icon(
                                        Icons.person_outline,
                                        color: Colors.black,
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

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                  child: Text(
                                    'Mobile No',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                new TextField(
                                  controller: _account,
                                  decoration: new InputDecoration(
                                      hintText: ["", null, false, 0].contains(phone)?phone :phone,
                                      hintStyle: style1,
                                      suffixIcon: Icon(
                                        Icons.phone_iphone,
                                        color: Colors.black,
                                        size: 20,
                                      )),
                                  maxLines: 1,
                                  autofocus: false,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0,0,0,30),
                            child: new Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                                    child: Text(
                                      'Email ID',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  new TextField(
                                    controller: _account,
                                    decoration: new InputDecoration(
                                        hintText: ["", null, false, 0].contains(email)?email :email,
                                        hintStyle: style1,
                                        suffixIcon: Icon(
                                          Icons.email,
                                          color: Colors.black,
                                          size: 20,
                                        )),
                                    maxLines: 1,
                                    autofocus: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
//                          new Container(
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Padding(
//                                  padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
//                                  child: Text(
//                                    'State',
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontSize: 13,
//                                        fontWeight: FontWeight.w700),
//                                  ),
//                                ),
//                                Padding(
//                                    padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
//                                    child: DropdownButton<String>(
//                                      icon: Icon(Icons.arrow_drop_down_circle),
//                                      iconSize: 24,
//                                      hint: Text('Select State'),
//                                      isExpanded: true,
//                                      underline: null,
//                                      style: TextStyle(color: Colors.grey),
//                                      items: data.map((item) {
//                                        return new DropdownMenuItem(
//                                          child: new Text(item['exp_cat_name']),
//                                          value: item['exp_cat_id'].toString(),
//                                        );
//                                      }).toList(),
//                                      onChanged: (newVal) {
//                                        setState(() {
//                                          _mySelection = newVal;
//                                        });
//                                      },
//                                      value: _mySelection,
//                                    ))
//                              ],
//                            ),
//                          ),
//                          new Container(
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Padding(
//                                  padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
//                                  child: Text(
//                                    'Country',
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontSize: 13,
//                                        fontWeight: FontWeight.w700),
//                                  ),
//                                ),
//                                Padding(
//                                    padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
//                                    child: DropdownButton<String>(
//                                      icon: Icon(Icons.arrow_drop_down_circle),
//                                      iconSize: 24,
//                                      hint: Text('Select Country'),
//                                      isExpanded: true,
//                                      underline: null,
//                                      style: TextStyle(color: Colors.grey),
//                                      items: data1.map((item) {
//                                        return new DropdownMenuItem(
//                                          child: new Text(item['exp_type_name']),
//                                          value: item['exp_type_id'].toString(),
//                                        );
//                                      }).toList(),
//                                      onChanged: (newVal) {
//                                        setState(() {
//                                          _myselection2 = newVal;
//                                        });
//                                      },
//                                      value: _myselection2,
//                                    ))
//                              ],
//                            ),
//                          ),


//                    Visibility(child: showImage(),visible: false,),

                        ],
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
//                        image: DecorationImage(
//                          image: AssetImage("assets/images/card_background.png"),
//                          fit: BoxFit.fill,
//
//                        ),
                          color: Colors.white
                      ),)),),
//              Padding(
//                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                child: Center(
//                    child: GestureDetector(
//                      onTap: () {
//                        getToekn();
//                      },
//                      child: Card(
//                        child: Container(
//                          decoration: new BoxDecoration(
//                            color: Colors.blue,
//                            borderRadius: new BorderRadius.circular(40),
//                          ),
//                          height: 40.0, // height of the button
//                          width: 120.0, // width of the button
//                          child: Center(
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  Text(
//                                    'Submit',
//                                    style: TextStyle(
//                                        color: Colors.white,
//                                        fontWeight: FontWeight.w600),
//                                  ),
//                                  Icon(
//                                    Icons.arrow_forward_ios,
//                                    size: 15,
//                                    color: Colors.white,
//                                  )
//                                ],
//                              )),
//                        ),
//                        elevation: 5,
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(40.0),
//                        ),
//                      ),
//                    )),
//              ),
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

        resizeToAvoidBottomPadding: false);
  }
}
