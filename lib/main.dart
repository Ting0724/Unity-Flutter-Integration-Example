import 'dart:async';
import 'package:digittwinsystem/api/api_communication.dart';
import 'package:digittwinsystem/api/server.dart';
import 'package:digittwinsystem/controller/globalvar.dart';
import 'package:digittwinsystem/controller/robot_controller.dart';
import 'package:digittwinsystem/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

void main() async {
  final GlobalVariable globalVariable = Get.put(GlobalVariable());
  final RobotController robotController = Get.put(RobotController());
  InitServer.init();
  globalVariable.connection_status.value = "Disconnected";
  
  Duration refreshTime = Duration(seconds: 1);
  Duration fastRefresh = Duration(milliseconds: 100);
  late Timer timer;
  late Timer timer2;
  timer = Timer.periodic(refreshTime, (timer) async {
    //print("Running API here");
    globalVariable.connection_status.value = await ServicesRealTime.getConnectionStatus("", "", "", "", "", "", "");
    globalVariable.yolo_image.value = await ServicesRealTime.getDetectedImage("", "", "", "", "", "", "");
    globalVariable.box_fruit_count.value = await ServicesRealTime.getBoxCount("", "", "", "", "", "", "");
    globalVariable.latency_graph.value = await ServicesRealTime.getLatencyGraph("", "", "", "", "", "", "");
  });

  timer2 = Timer.periodic(fastRefresh, (timer) async {
    if(globalVariable.page.value == "Robot") {
      //await ServicesRealTime.realtimeLiveControl(robotController.playProgram.value, robotController.selectedMode.value, robotController.act_joint, "Off", "Off", "Off", globalVariable.page.value);
      for (int i=0; i<6; i++) {
        robotController.jointAngle[i] = globalVariable.joint_feedback[i];
        robotController.cartesianValue[i] = globalVariable.cartesian_feedback[i];
        /* 
        if (robotController.selectedMode.value == 'Live Control') {
          //print("Selected Mode: ${robotController.selectedMode.value}");
          robotController.jointAngle[i] = globalVariable.joint_feedback[i];
        }*/
      }  
    }
  });
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Twin of Robotic Sorting System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthenticationPage(),
    );
  }
}
