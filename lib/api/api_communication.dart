import 'dart:convert';
import 'dart:developer';
import 'package:digittwinsystem/api/server.dart';
import 'package:http/http.dart' as http;

class ServicesRealTime {
  static var MSSQLAPILocation = APILocation;
  static var REALTIME = MSSQLAPILocation + 'realtime.php';
  static var _LIVE_CONTROL = "Live Control";
  static var _CONNECTION_STATUS = "Connection_Info";
  static var _GET_DETECTED_IMAGE = "GET_DETECTION";
  static var _GET_BOX_COUNT = "BOX_COUNT";
  static var _GET_LATENCY_GRAPH = "GET_LATENCY_GRAPH";

  ///Query Runtime Data
  static Future<List> getLatencyGraph(
    String action,
    String mode,
    String act_joint,
    String end_eff,
    String conveyorbox,
    String conveyorfruit,
    String digitaltwin,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['task'] = _GET_LATENCY_GRAPH;
      map['action'] = action;
      map['mode'] = mode;
      map['act_joint'] = act_joint;
      map['end_eff'] = end_eff;
      map['conveyorbox'] = conveyorbox;
      map['conveyorfruit'] = conveyorfruit;
      map['digitaltwin'] = digitaltwin;
      final response = await http.post(Uri.parse(REALTIME), body: map);
      if (200 == response.statusCode) {
        var data = jsonDecode(response.body);
        //print("Checking data: ${data}");
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<String> getDetectedImage(
    String action,
    String mode,
    String act_joint,
    String end_eff,
    String conveyorbox,
    String conveyorfruit,
    String digitaltwin,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['task'] = _GET_DETECTED_IMAGE;
      map['action'] = action;
      map['mode'] = mode;
      map['act_joint'] = act_joint;
      map['end_eff'] = end_eff;
      map['conveyorbox'] = conveyorbox;
      map['conveyorfruit'] = conveyorfruit;
      map['digitaltwin'] = digitaltwin;
      final response = await http.post(Uri.parse(REALTIME), body: map);
      if (200 == response.statusCode) {
        var data = jsonDecode(response.body);
        //print("Checking data: ${data["image"]}");
        return data["image"];
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  static Future<List> getBoxCount(
    String action,
    String mode,
    String act_joint,
    String end_eff,
    String conveyorbox,
    String conveyorfruit,
    String digitaltwin,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['task'] = _GET_BOX_COUNT;
      map['action'] = action;
      map['mode'] = mode;
      map['act_joint'] = act_joint;
      map['end_eff'] = end_eff;
      map['conveyorbox'] = conveyorbox;
      map['conveyorfruit'] = conveyorfruit;
      map['digitaltwin'] = digitaltwin;
      final response = await http.post(Uri.parse(REALTIME), body: map);
      if (200 == response.statusCode) {
        var data = jsonDecode(response.body);
        //print("Checking data: ${data}");
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<String> getConnectionStatus(
    String action,
    String mode,
    String act_joint,
    String end_eff,
    String conveyorbox,
    String conveyorfruit,
    String digitaltwin,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['task'] = _CONNECTION_STATUS;
      map['action'] = action;
      map['mode'] = mode;
      map['act_joint'] = act_joint;
      map['end_eff'] = end_eff;
      map['conveyorbox'] = conveyorbox;
      map['conveyorfruit'] = conveyorfruit;
      map['digitaltwin'] = digitaltwin;
      final response = await http.post(Uri.parse(REALTIME), body: map);
      if (200 == response.statusCode) {
        List<dynamic> data = jsonDecode(response.body);
        var status = "Disconnected";
        //print("Checking data: ${data}");
        //print("Checking data: ${data[0][2]} and ${data[0][3]}");
        if(data[0][2] == "Disconnected" || data[0][3] == "Disconnected") {
          status = "Disconnected";
        }
        else {
          status = "Connected";
        }
        return status;
      } else {
        return "Disconnected";
      }
    } catch (e) {
      return "Disconnected";
    }
  }

  static Future realtimeLiveControl(
    String action,
    String mode,
    List<String> act_joint,
    String end_eff,
    String conveyorbox,
    String conveyorfruit,
    String page,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['task'] = _LIVE_CONTROL;
      map['action'] = action;
      map['mode'] = mode;
      map['act_joint'] = '${act_joint[0]},${act_joint[1]},${act_joint[2]},${act_joint[3]},${act_joint[4]},${act_joint[5]}';
      map['end_eff'] = end_eff;
      map['conveyorbox'] = conveyorbox;
      map['conveyorfruit'] = conveyorfruit;
      map['page'] = page;
      final response = await http.post(
        Uri.parse(REALTIME),
        body: map,
      );
    } catch (e) {
      print("realtimeLiveControl Error: $e");
    }
  }
}

class ServiceAPI {
  static var MSSQLAPILocation = APILocation;
  static var SAVE_PROGRAM = MSSQLAPILocation + 'program_file.php';
  static var _SAVE_FILE = "SAVE_FILE";
  static var _GET_PROGRAM_LIST = "GET_PROGRAM_LIST";

  static Future<void> saveProgramFile(
    String programName,
    String programContent,
  ) async {
    try {
      // Create a map with the form data
      final Map<String, String> map = {
        'task': _SAVE_FILE,
        'program_name': programName,
        'program_json': programContent,
      };
      final response = await http.post(
        Uri.parse(SAVE_PROGRAM),
        body: map,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] != null) {
          //print('Program saved successfully');
        } else {
          print('Error: ${responseData['error']}');
        }
      } else {
        print('Failed to save program. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  static Future<List<String>> getProgramList() async {
    try {
      var map = <String, dynamic>{};
      map['task'] = _GET_PROGRAM_LIST;
      final response = await http.post(Uri.parse(SAVE_PROGRAM), body: map);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> processedData = List<String>.from(data.map((item) => item.toString()));
        //print("Checking data: $data");
        //print("Processed data: ${processedDate}");
        //return List<String>.from(data.map((item) => item.toString())); 
        return processedData;
      } else {
        return ['Sorting'];
      }
    } catch (e) {
      return ['Sorting'];
    }
  }
}