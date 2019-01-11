import 'dart:async';

import 'package:flutter/services.dart';

enum _ActivityType{ steps, cycling, walkRun, heartRate, flights }
class IosHealth {
  static const MethodChannel _channel =
      const MethodChannel('ios_health');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> get authorize async {
    return await _channel.invokeMethod('requestAuthorization');
  }

  static Future<Map<dynamic, dynamic>> get getBasicHealthData async {
    return await _channel.invokeMethod('getBasicHealthData');
  }

//  static Future<double> get getSteps async {
//    return await _getActivityData(_ActivityType.steps, "count");
//  }
//
//  static Future<double> get getWalkingAndRunningDistance async {
//    return await _getActivityData(_ActivityType.walkRun, "m");
//  }
//
//  static Future<double> get geCyclingDistance async {
//    return await _getActivityData(_ActivityType.cycling, "m");
//  }
//
//  static Future<double> get getFlights async {
//    return await _getActivityData(_ActivityType.flights, "count");
//  }
  static Future<double>  getStepsByRange(String StartDate,String EndDate) async {
    return await _getActivityDataByRange(_ActivityType.steps, "count", StartDate, EndDate);
  }

  static Future<double>  getWalkingAndRunningDistanceByRange(String StartDate,String EndDate) async {
    return await _getActivityDataByRange(_ActivityType.walkRun, "m", StartDate, EndDate);
  }

  static Future<double>  geCyclingDistanceByRange(String StartDate,String EndDate) async {
    return await _getActivityDataByRange(_ActivityType.cycling, "m", StartDate, EndDate);
  }

  static Future<double>  getFlightsByRange(String StartDate,String EndDate) async {
    return await _getActivityDataByRange(_ActivityType.flights, "count", StartDate, EndDate);
  }
  static Future<double> _getActivityDataByRange(_ActivityType activityType, String units, String StartDate,String EndDate) async {
    var result;

    try {
      result = await _channel.invokeMethod(
          'getActivityDataByDateRange',
          {
            "name": activityType
                .toString()
                .split(".")
                .last,
            "units": units,
            "StartDate":StartDate,
            "EndDate":EndDate
          }
      );
    }
    catch (e) {
      print(e.toString());
      return null;
    }

    if (result == null || result.isEmpty){
      return null;
    }

    return result["value"];
  }
//  static Future<double> _getActivityData(_ActivityType activityType, String units) async {
//    var result;
//
//    try {
//      result = await _channel.invokeMethod(
//          'getActivity',
//          {
//            "name": activityType
//                .toString()
//                .split(".")
//                .last,
//            "units": units
//          }
//      );
//    }
//    catch (e) {
//      print(e.toString());
//      return null;
//    }
//
//    if (result == null || result.isEmpty){
//      return null;
//    }
//
//    return result["value"];
//  }
}
