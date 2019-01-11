import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:ios_health/ios_health.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isAuthorized = false;
  String _basicHealthString = "";
  String _activityData;


  final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  DateTime dateS;
  DateTime dateE;


  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
//    String platformVersion;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await FlutterHealthFit.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
  }

  _authorizeHealthOrFit() async {
    bool isAuthorized = await IosHealth.authorize;
    setState(() {
      _isAuthorized = isAuthorized;
    });
  }

  _getUserBasicHealthData() async{
    var basicHealth = await IosHealth.getBasicHealthData;
    setState(() {
      _basicHealthString = basicHealth.toString();
    });
  }

  _getActivityHealthData() async {
    print(dateFormat.format(dateS));
    print(dateFormat.format(dateE));
    String StartDate = dateFormat.format(dateS) + "+0000";
    String EndDate = dateFormat.format(dateE) + "+0000";
    var steps = await IosHealth.getStepsByRange(StartDate, EndDate);
    var running = await IosHealth.getWalkingAndRunningDistanceByRange(StartDate, EndDate);
    var cycle = await IosHealth.geCyclingDistanceByRange(StartDate, EndDate);
    var flights = await IosHealth.getFlightsByRange(StartDate, EndDate);
    setState(() {
      _activityData = "steps: $steps\nwalking running: $running\ncycle: $cycle flights: $flights";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Container(
          child:
//          ListView(
//            children: <Widget>[
//              DateTimePickerFormField(
//                format: dateFormat,
//                decoration: InputDecoration(labelText: 'Date'),
//                onChanged: (dt) => setState(() => date = dt),
//              ),
//              SizedBox(height: 16.0),
//              TimePickerFormField(
//                format: timeFormat,
//                decoration: InputDecoration(labelText: 'Time'),
//                onChanged: (t) => setState(() => time = t),
//              ),
//              SizedBox(height: 16.0),
//              Text('date.toString(): $date', style: TextStyle(fontSize: 18.0)),
//              SizedBox(height: 16.0),
//              Text('time.toString(): $time', style: TextStyle(fontSize: 18.0)),
//            ],
//          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              Text('Authorized: $_isAuthorized\n'),
              RaisedButton(child: Text("Authorize Health"), onPressed: (){_authorizeHealthOrFit();
              }),
              RaisedButton(child: Text("Get basic data"), onPressed: _getUserBasicHealthData),

              Text('Basic health: $_basicHealthString\n'),

              DateTimePickerFormField(
                format: dateFormat,
                decoration: InputDecoration(labelText: 'StartDate'),
                onChanged: (dt) => setState(() => dateS = dt),
              ),
              DateTimePickerFormField(
                format: dateFormat,
                decoration: InputDecoration(labelText: 'EndDate'),
                onChanged: (dt) => setState(() => dateE = dt),
              ),


              RaisedButton(child: Text("Get Activity Data"), onPressed: _getActivityHealthData),
              Text('\n$_activityData\n'),
            ],
          ),
        ),
      ),
    );
  }
}