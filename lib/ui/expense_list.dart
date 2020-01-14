import 'dart:io';

import 'package:dextrous_crm_new2/conts/config.dart';
import 'package:dextrous_crm_new2/ui/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_expense.dart';
import 'filter_screen.dart';
import 'leads_details.dart';


class ExpenseLis extends StatefulWidget {
   String status;
  String e_date='',s_date='';

  ExpenseLis({Key key, this.status,  this.e_date, this.s_date}) : super(key: key);

  @override
  _ExpenseLisState createState() => new _ExpenseLisState(status: status,e_date: e_date,s_date: s_date);
}

class _ExpenseLisState extends State<ExpenseLis> {
   String status,type;
  String e_date='',s_date='';

  _ExpenseLisState({Key key, this.status,  this.e_date, this.s_date}) : super();

  final String uri =
      "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/expense/expList";

  bool isHomeDataLoading;

  String leads_tab = "assets/images/leads1.png",
      status_tab = "assets/images/status.png";





  int countValue = 0;

  Future<List<Leads>> getToekn(String type) async {
    print("Status"+ type);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FormData formData;
    String login_url =
        "http://ems.dextrousinfosolutions.com/dev-dexcrm/api/expense/expList";
    if(type =="0"){
       formData = new FormData.from({
        "userId": prefs.getString('userId'),
        "token": prefs.getString('user_token'),
        "status":type,
        "start_date": !["", null, false, 0].contains(s_date) ? s_date : "",
        "end_date":!["", null, false, 0].contains(e_date) ? e_date : "" ,
      });
    }

    if(type =="1"){
      formData = new FormData.from({
        "userId": prefs.getString('userId'),
        "token": prefs.getString('user_token'),
        "status":type,
        "start_date": !["", null, false, 0].contains(s_date) ? s_date : "",
        "end_date":!["", null, false, 0].contains(e_date) ? e_date : "" ,
      });
    }


    if(type =="2"){
      formData = new FormData.from({
        "userId": prefs.getString('userId'),
        "token": prefs.getString('user_token'),
        "status":type,
        "start_date": !["", null, false, 0].contains(s_date) ? s_date : "",
        "end_date":!["", null, false, 0].contains(e_date) ? e_date : "" ,
      });
    }

    http.Response response = await http.post(login_url, body: formData);

    print("formData"+formData.toString());

    var body = await json.decode(response.body);
    //Simulate a service call
    print('submitting to backend...');
    Map<String, dynamic> decodedMap = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> dynamicList = decodedMap['expList'];
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
    setState(() {
      type=status;
    });
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

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: new Container(
            child: new Stack(
              children: <Widget>[
                Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/backgrounddashboard.png',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: size.width,
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      builder: (context) => HomePage(

                                      ),
                                    ));
                              }),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40.0, 0, 0, 0),
                              child: Center(
                                child: Container(
                                  child: Text(
                                    'Expense List',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            flex: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                    child: GestureDetector(
                                      child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/filter11.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                      onTap: () {

                                        Navigator.of(context).push(
                                            MaterialPageRoute<Null>(
                                                builder: (BuildContext context) {
                                                  return new Filter();
                                                }));
                                      },
                                    )),
                                flex: 0,
                              ),
                              Flexible(
                                child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8.0, 0, 10, 0),
                                    child: GestureDetector(
                                      child: Image.network(
        'http://ems.dextrousinfosolutions.com/dev-dexcrm/flutter_images/images/expense11.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute<Null>(
                                                builder: (BuildContext context) {
                                                  return new AddExpense();
                                                }));
                                      },
                                    )),
                                flex: 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),



                    Flexible(
                      child: FutureBuilder<List<Leads>>(
                        future: getToekn(type),
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
            )),
        resizeToAvoidBottomPadding: true);
  }
}

class Leads {
  String expId;
  String file;
  String category;
  String expense_type,
      amount,
      reference_no,
      expense_name,
      date,
      time,
      category_name,expense_status_color;
  int expense_status;

  Leads({
    this.expId,
    this.file,
    this.category,
    this.expense_type,
    this.amount,
    this.reference_no,
    this.expense_name,
    this.date,
    this.time,
    this.category_name,
    this.expense_status,
    this.expense_status_color,
  });

  factory Leads.fromJson(Map<String, dynamic> json) {
    return Leads(
      expId: json['expId'],
      file: json['file'],
      category: json['category'],
      expense_type: json['expense_type'],
      amount: json['amount'],
      reference_no: json['reference_no'],
      expense_name: json['expense_name'],
      date: json['date'],
      time: json['time'],
      category_name: json['category_name'],
      expense_status: json['expense_status'],
      expense_status_color: json['expense_status_color'],
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
      height: size.height,
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


  Future<File> _imageFile;
  void _onImageSaveButtonPressed(String url) async {
    print("_onImageSaveButtonPressed");
    var response = await http
        .get(url);

    debugPrint(response.statusCode.toString());

    var filePath = await ImagePickerSaver.saveFile(
        fileData: response.bodyBytes);

    var savedFile= File.fromUri(Uri.file(filePath));
    setState(() {
      _imageFile = Future<File>.sync(() => savedFile);
    });
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            debugPrint(snapshot.data.path);
            return Image.file(snapshot.data);
          } else if (snapshot.error != null) {
            return const Text(
              'Error picking image.',
              textAlign: TextAlign.center,
            );
          } else {
            return const Text(
              'You have not yet picked an image.',
              textAlign: TextAlign.center,
            );
          }
        });
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Feedback'),

            content:Center(
              child:  _previewImage(),
            ),

            actions: <Widget>[
              new RaisedButton(
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)
                ),
                padding: const EdgeInsets.all(8.0),
                textColor: Colors.white,
                color: Colors.redAccent[100],
                child: new Text("Ok"),
              )
            ],
          );
        });
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
    Color color2 = HexColor(cellModel.expense_status_color);
    return GestureDetector(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 5, 5, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(4, 5.0, 0, 0),
                                child: Text(!["", null, false, 0].contains( cellModel.expense_name)? cellModel.expense_name:"NA"
                                 ,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              flex: 1,
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(4.0, 5, 5, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('Category: ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey)),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Text(
                                        !["", null, false, 0].contains(cellModel.category_name)?cellModel.category_name:"NA",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                        maxLines: 1,
                                      ),
                                      flex: 4,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 5, 5, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text('Type: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey)),
                                flex: 1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Text(
                                    !["", null, false, 0].contains(cellModel.expense_type)?cellModel.expense_type:"NA",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                flex: 4,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text('Amount: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey)),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(!["", null, false, 0].contains(cellModel.amount)?cellModel.amount:"NA",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[800])),
                                flex: 2,
                              ),

                              Expanded(
                                child: Container(
                                    child: Center(
                                      child: Text(cellModel.expense_status==0?'Pending' : 'Approved',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white)),
                                    ),
                                    width: 80,
                                    height: 25,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: color2,
                                    )
                                ),
                                flex: 0,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Text("Date:",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          4.0, 0, 0, 0),
                                      child: Text(!["", null, false, 0].contains(cellModel.date)?cellModel.date:"NA",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Text("Time:",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          4.0, 0, 0, 0),
                                      child: Text(!["", null, false, 0].contains(cellModel.time)?cellModel.time:"NA",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              flex: 1,
                            ),
                            Visibility(child:GestureDetector(child:  Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 5, 0, 5),
                              child: Icon(Icons.attachment),
                            ),onTap: (){
                              _onImageSaveButtonPressed(cellModel.file);
                            },),visible: !["", null, false, 0].contains(cellModel.file)?true:false,)
                          ],
                        ),
                      ],
                    ),
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