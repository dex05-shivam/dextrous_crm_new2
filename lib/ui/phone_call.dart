import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class CallPhone extends StatelessWidget {
  final String phone = 'tel:+2347012345678';

  _callPhone() async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Call Phone from App Example')),
      body: Center(
          child: RaisedButton(
            onPressed: _callPhone,
            child: Text('Call Phone'),
            color: Colors.red,
          )),
    );
  }
}